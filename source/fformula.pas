{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 200-2007 Allan Lima, Bel�m-Par�-Brasil.

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

unit fformula;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids,
  QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls, QAKLabel,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls, AKLabel,
  {$ENDIF}
  {$IFDEF SYN_EDIT}
    {$IFDEF CLX}
    QSynHighlighterCAC, QSynEdit, QSynDBEdit, QSynEditExport, QSynExportRTF, QSynExportHTML,
    {$ENDIF}
    {$IFDEF VCL}
    SynHighlighterCAC, SynEdit, SynDBEdit, SynEditExport, SynExportRTF, SynExportHTML,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Variants, fcadastro, DB, DBClient, Menus, Clipbrd;

type
  TFrmFormula = class(TFrmCadastro)
    mtRegistroNOME: TStringField;
    mtRegistroFORMULA: TBlobField;
    mtListagemIDFORMULA: TIntegerField;
    mtRegistroIDFORMULA: TIntegerField;
    mtListagemFORMULA: TStringField;
    PopupMenu1: TPopupMenu;
    miExportAsHTML: TMenuItem;
    miExportAsRTF: TMenuItem;
    N1: TMenuItem;
    miExportToFile: TMenuItem;
    N2: TMenuItem;
    miExportClipboardNative: TMenuItem;
    miExportClipboardText: TMenuItem;
    miExportAllFormats: TMenuItem;
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ListDblClick(Sender: TObject);
    procedure miExportAsClicked(Sender: TObject);
    procedure miExportToFileClick(Sender: TObject);
    procedure miExportClipboardNativeClick(Sender: TObject);
    procedure miExportClipboardTextClick(Sender: TObject);
    procedure mExportClick(Sender: TObject);
  protected
    { Protected declarations }
    lbCodigo: TLabel;
    dbCodigo: TDBEdit;
    lbNome: TLabel;
    dbNome: TDBEdit;
    { 17-02-2004 - o componente TDBSynEdit estar sendo criando em designer
      porque h� um bug quando se o criamos dinamicamente: a grava��o n�o funciona }
    { 15-10-2005 - O bug acima foi retirado de SynEdit.pas }
    {$IFDEF SYN_EDIT}
    dbFormula: TDBSynEdit;
    {$ELSE}
    dbFormula: TDBMemo;
    {$ENDIF}
  private
    { Private declarations }
    fExportAs: Integer;

  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaFormula();
procedure FindFormula( const Pesquisa: String; DataSet: TDataSet; var Key: Word); overload;
procedure FindFormula( const Pesquisa: String; DataSet: TDataSet); overload;

implementation

uses fdb, ftext, fbase, ffind, fsuporte;

{$R *.dfm}

procedure FindFormula( const Pesquisa: String; DataSet: TDataSet; var Key: Word);
var
  sPesq, sWhere: String;
  cd: TClientDataSet;
  vValue: Variant;
begin

  sPesq := Pesquisa;

  if (Length(sPesq) = 0) then
  begin

    sPesq := '*';

    if (kCountSQL('F_FORMULA', '') > 30) then
      if not InputQuery( 'Pesquisa F�rmulas',
                         'Informe um texto para pesquisar', sPesq) then
        Exit;

  end;

  if (Length(sPesq) = 0) then
    Exit;

  sPesq := StringReplace( sPesq, '*', '%', [rfReplaceAll]);

  if kNumerico(sPesq) then
    sWhere := 'IDFORMULA = '+sPesq
  else
    sWhere := 'NOME LIKE '+QuotedStr(sPesq+'%');

  cd := TClientDataSet.Create(NIL);

  try try

    kOpenSQL( cd, '',
              'SELECT IDFORMULA ID, NOME, FORMULA FROM F_FORMULA'#13+
              'WHERE '+sWhere, []);

    if (cd.RecordCount = 0) then
    begin
      kAviso('F�rmula n�o localizada. Tente Novamente');
      Key := 0;
    end else if kFindDataSet( cd, 'Pesquisa F�rmulas', 'NOME', vValue,
                              [foNoPanel, foNoTitle]) then
    begin
      if Assigned(DataSet) and (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDFORMULA')) then
          DataSet.FieldByName('IDFORMULA').AsString := cd.Fields[0].AsString;
        if Assigned(DataSet.FindField('FORMULA')) and
           (DataSet.FieldByName('FORMULA').FieldKind = fkData) then
          DataSet.FieldByName('FORMULA').AsString := cd.Fields[1].AsString;
        if Assigned(DataSet.FindField('FORMULA_SOURCE')) and
           (DataSet.FieldByName('FORMULA_SOURCE').FieldKind = fkData) then
          DataSet.FieldByName('FORMULA_SOURCE').AsString := cd.Fields[2].AsString;
      end;
    end else
    begin
      kAviso('A f�rmula n�o foi selecionada. Tente Novamente');
      Key := 0;
    end;

  except
    on E:Exception do
      kErro( E.Message, 'fformula', 'FindFormula()');
  end;
  finally
    cd.Free;
  end;

end;  // FindFormula

procedure FindFormula( const Pesquisa: String; DataSet: TDataSet);
var
  Key: Word;
begin
  FindFormula( Pesquisa, DataSet, Key);
end;  // FindFormula

procedure CriaFormula();
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmFormula) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmFormula.Create(Application) do
    try
      pvTabela := 'F_FORMULA';
      Iniciar();
      Show;
    except
      on E: Exception do
        kErro( E.Message, '.', 'CriaFormula()');
    end; // try

end;

procedure TFrmFormula.Iniciar;
begin

  //  pvSELECT := 'SELECT IDFORMULA, NOME FROM F_FORMULA';
  //  kNovaPesquisa( mtPesquisa, 'ID', 'WHERE IDFORMULA = '+QuotedStr('#'));
  //  kNovaPesquisa( mtPesquisa, 'NOME', 'WHERE NOME LIKE '+QuotedStr('#%'));

  dbgRegistro.Options := dbgRegistro.Options + [dgIndicator];

  mtListagem.IndexFieldNames := 'IDFORMULA';

  inherited Iniciar;

end;  // iniciar

procedure TFrmFormula.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbNome.SetFocus;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
end;

procedure TFrmFormula.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := DataSet.FieldByName('NOME').AsString;
  if not kConfirme('Excluir a f�rmula "'+sNome+'" ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmFormula.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
end;

procedure TFrmFormula.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbCodigo.SetFocus;
end;

procedure TFrmFormula.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  {$IFDEF SYN_EDIT}
  if (Key = VK_RETURN) and (pvDataSet.State in [dsInsert,dsEdit])  and
     (ActiveControl is TCustomSynEdit) then else
  {$ENDIF}
  inherited;
end;

procedure TFrmFormula.FormCreate(Sender: TObject);
var
  PgcFormula: TPageControl;
  TabSheet1: TTabSheet;
  ListBox1: TListBox;
  Panel1: TPanel;
begin

  inherited;

  pnlPesquisa.Visible := False;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := TabDetalhe;
    Align       := alTop;
    Caption     := '';
    Height      := 55;
    ParentColor := True;
    TabOrder    := 0;
  end;

  lbCodigo := TLabel.Create(Self);

  with lbCodigo do
  begin
    Parent  := Panel1;
    Caption := 'C�digo';
    Left    := 8;
    Top     := 8;
  end;

  dbCodigo := TDBEdit.Create(Self);

  with dbCodigo do
  begin
    Parent := lbCodigo.Parent;
    DataSource := dtsRegistro;
    DataField  := 'IDFORMULA';
    Left   := lbCodigo.Left;
    Top    := lbCodigo.Top + lbCodigo.Height + 3;
    Width  := 50;
  end;

  lbNome := TLabel.Create(Self);

  with lbNome do
  begin
    Parent  := lbCodigo.Parent;
    Caption := 'Descri��o da F�rmula';
    Left    := dbCodigo.Left + dbCodigo.Width + 5;
    Top     := lbCodigo.Top;
  end;

  dbNome := TDBEdit.Create(Self);

  with dbNome do
  begin
    Parent := lbCodigo.Parent;
    DataSource := dtsRegistro;
    DataField  := 'NOME';
    Left   := lbNome.Left;
    Top    := lbNome.Top + lbNome.Height + 3;
    Width  := dbCodigo.Width*8;
  end;

  {$IFDEF SYN_EDIT}
  if not Assigned(dbFormula) then
    dbFormula := TDBSynEdit.Create(Self);

  with dbFormula do
  begin
    Gutter.Visible := True;
    Gutter.ShowLineNumbers := True;
    Highlighter := TSynCACSyn.Create(Self);
    Highlighter.CommentAttribute.Foreground := clRed;
    Highlighter.StringAttribute.Foreground  := clBlue;
  end;
  {$ELSE}
  if not Assigned(dbFormula) then
    dbFormula := TDBMemo.Create(Self);
  {$ENDIF}

  with dbFormula do
  begin
    Font.Name := 'Courier New';
    Parent := TabDetalhe;
    Align  := alClient;
    if not Assigned(DataSource) then
      DataSource := dtsRegistro;
    if (DataField = '') then
      DataField  := 'FORMULA';
    ScrollBars := ssVertical;
    PopupMenu  := PopupMenu1;
  end;

  PgcFormula := TPageControl.Create(Self);

  with PgcFormula do
  begin
    Parent := TabDetalhe;
    Align  := alBottom;
    Height := 130;
    Style  := tsButtons;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Funcion�rios';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('CG -- C�digo do Cargo');
    Items.Add('CH -- Carga Hor�ria Mensal');
    Items.Add('D? -- Qtde de Dependentes do Tipo ?');
    Items.Add('GI -- Grau de Instru��o');
    Items.Add('HT -- Valor da Hora Trabalhada');
    Items.Add('ID -- C�digo Identificador');
    Items.Add('LT -- C�digo da Lota��o');
    Items.Add('MM -- Meses para M�dia');
    Items.Add('MMA -- Meses de Admiss�o no Ano');
    Items.Add('SN -- Sal�rio Normal');
    Items.Add('SM -- Calcula o Sal�rio Mensal (considera VI)');
    Items.Add('SALARIO -- Sal�rio Cadastral');
    Items.Add('TN -- Tempo de Nascimento (em meses)');
    Items.Add('TS -- Tempo de Servi�o (em meses)');
    Sorted := True;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Folha';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('DSR -- Descanso Semanal Remunerado');
    Items.Add('GN -- Gratifica��o Natalina - 13o. sal�rio');
    Items.Add('DPU - N�mero de dias �teis no per�odo da folha');
    Items.Add('DPF - N�mero de dias n�o-�teis no per�odo da folha');
    ParentColor := True;
    Sorted := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Eventos';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('TX -- Valor da �ltima Taxa acessado pela F�rmula');
    Items.Add('MN -- Valor Minimo');
    Items.Add('MINIMO -- Vaor Minimo)');
    Items.Add('MX -- Valor M�ximo');
    Items.Add('MAXIMO -- Valor M�ximo');
    Items.Add('MT -- Multiplicador');
    Items.Add('VI -- Valor Informado');
    Items.Add('VR -- Valor refer�ncia');
    Items.Add('VT -- Valor Totalizado');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Ind�ces';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('IL(<i>) -- Indice Local <i>');
    Items.Add('IL<i>   -- Indice Local <i>');
    Items.Add('IG(<i>) -- Indice Global <i>');
    Items.Add('IG<i>   -- Indice Global <i>');
    Items.Add('II(<i>) -- �ndice Local ou Global <i>');
    Items.Add('II<i>   -- �ndice Local ou Global <i>');
    Items.Add('I<i>    -- �ndice Local ou Global <i>');
    Items.Add('-- Veja o arquivo indice.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Tabelas';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('-- Tabelas Globais --');
    Items.Add('TG(<t>,<v>)  -- Tabela Global - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TG<t>(<v>)   -- Tabela Global - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TGI(<t>,<i>) -- Valor do item <i> da tabela global <t>');
    Items.Add('TGI<t>(<i>)  -- Valor do item <i> da tabela global <t>');
    Items.Add('-- Tabelas Locais --');
    Items.Add('TL(<t>,<v>)  -- Tabela Local - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TL<t>(<v>)   -- Tabela Local - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TLI(<t>,<i>) -- Valor do item <i> da tabela local <t>');
    Items.Add('TLI<t>(<i>)  -- Valor do item <i> da tabela local <t>');
    Items.Add('-- Tabelas Locais ou Globais --');
    Items.Add('TB(<t>,<v>)  -- Tabela Local ou Global - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TB<t>(<v>)   -- Tabela Local ou Global - aplicar taxa, reducao e acescrimo em <v>');
    Items.Add('TBI(<t>,<i>) -- Valor do item <i> da tabela Local ou Global <t>');
    Items.Add('TBI<t>(<i>)  -- Valor do item <i> da tabela Local ou Global <t>');
    Items.Add('-- Veja o arquivo tabela_calculo.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Totalizadores';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('-- Fun��es Acumuladoras --');
    Items.Add('T<n>    -- Total de incid�ncia de n�mero <n> (1 a 20)');
    Items.Add('TI<n>   -- Total de incid�ncia de n�mero <n> (1 a 20)');
    Items.Add('TI(<n>) -- Total de incid�ncia de n�mero <n> (1 a 20)');
    Items.Add('TB      -- Total dos eventos BASE');
    Items.Add('TD      -- Total dos eventos DESCONTO');
    Items.Add('TP      -- Total dos eventos PROVENTO');
    Items.Add('-- Fun��es Totalizadoras --');
    Items.Add('TT      -- Totaliza��o Padr�o');
    Items.Add('TT<n>   -- Executa o totalizador n�mero <n>');
    Items.Add('TT(<n>) -- Executa o totalizador n�mero <n>');
    Items.Add('TA      -- Totaliza��o Padr�o');
    Items.Add('TA<n>   -- Executa o totalizador n�mero <n>');
    Items.Add('TA(<n>) -- Executa o totalizador n�mero <n>');
    Items.Add('-- Fun��es Totalizadoras Anuais --');
    Items.Add('AA      -- Executa uma totaliza��o padrao');
    Items.Add('-- Veja o arquivo totalizador.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  with TabSheet1 do
  begin
    Caption     := '&Valores Fixos';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('VG(<v>) -- Valor do valor-global <v> (c�digo ou nome)');
    Items.Add('VG<v>   -- Valor do valor-global <v> (c�digo)');
    Items.Add('VL(<v>) -- Valor do valor-local <v> (c�digo ou nome)');
    Items.Add('VL<v>   -- Valor do valor-local <v> (c�digo)');
    Items.Add('VV(<v>) -- Valor do valor-local ou global <v> (c�digo ou nome)');
    Items.Add('VV<v>   -- Valor do valor-local ou global <v> (c�digo)');
    Items.Add('V<v>    -- Valor do valor-local ou global <v> (c�digo)');
    Items.Add('-- Veja o arquivo valor_fixo.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  TabSheet1 := TTabSheet.Create(Self);

  { 29/05/2005 - Allan Lima }

  with TabSheet1 do
  begin
    Caption     := '&Rescis�o';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('R:DEMISSAO          -- Data de rescis�o do funcion�rio');
    Items.Add('R:REMUNERACAO       -- Valor da remunera��o para fins rescis�rio');
    Items.Add('R:AVISO_PREVIO_X    -- 0 (Sem aviso) ou 1 (com aviso)');
    Items.Add('R:AVISO_PREVIO_DATA -- Data do aviso pr�vio');
    Items.Add('R:IDRESCISAO        -- C�digo da causa da rescis�o');
    Items.Add('R:IDCAGED           -- C�digo CAGED da rescis�o');
    Items.Add('-- Veja o arquivo rescis�o.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

  { 06/06/2005 - Allan Lima }

  with TabSheet1 do
  begin
    Caption     := '&Outros';
    PageControl := PgcFormula;
  end;

  ListBox1 := TListBox.Create(Self);

  with ListBox1 do
  begin
    Parent := TabSheet1;
    Align  := alClient;
    Font.Assign( dbFormula.Font);
    Items.Add('-- Totaliza��o por Incid�ncia - m�s de cr�dito da folha --');
    Items.Add('XI                  -- Incid�ncia de mesmo nome do evento atual no m�s de cr�dito da folha em c�lculo');
    Items.Add('XI<i>               -- Incid�ncia <i> no m�s de cr�dito da folha em c�lculo');
    Items.Add('XI(<i>)             -- Idem');
    Items.Add('XI(<i>,<mes>)       -- Incid�ncia <i> no m�s <m�s> e ano da folha em c�lculo');
    Items.Add('XI(<i>,<mes>,<ano>) -- Incid�ncia <i> no m�s <m�s> e <ano>');
    Items.Add('-- Totaliza��o de Evento - m�s de cr�dito da folha --');
    Items.Add('XE                  -- Evento atual no m�s de cr�dito da folha em c�lculo');
    Items.Add('XE<e>               -- Evento <e> no m�s de cr�dito da folha em c�lculo');
    Items.Add('XE(<e>)             -- Idem');
    Items.Add('XE(<e>,<mes>)       -- Evento <e> no m�s <mes> e ano da folha em c�lculo');
    Items.Add('XE(<e>,<mes>,<ano>) -- Evento <e> no m�s <mes> e <ano>');
    Items.Add('-- Veja o arquivo formula.txt para mais informa��es --');
    Parent      := TabSheet1;
    ParentColor := True;
    OnDblClick  := ListDblClick;
  end;

end;

procedure TFrmFormula.ListDblClick(Sender: TObject);
var
  iPos: Integer;
  sText: String;
begin

  if not (Sender is TListBox) or
     not (mtRegistro.State in [dsInsert,dsEdit]) then
    Exit;

  // Recupera o texto que se encontra no item selecionado
  sText := TListBox(Sender).Items[TListBox(Sender).ItemIndex];

  // Retira a parte de coment�rio do texto
  iPos := Pos( '--', sText);

  if (iPos > 0) then
    sText := Trim(Copy( sText, 1, iPos-1));

  dbFormula.DoCopyToClipboard(sText);
  dbFormula.PasteFromClipboard;

end;

// exportacao

procedure TFrmFormula.mExportClick(Sender: TObject);
var
  HasText, IsEnabled: boolean;
  i: integer;
begin

  miExportAsHTML.Checked := fExportAs = 1;
  miExportAsRTF.Checked := fExportAs = 2;
  miExportAllFormats.Checked := fExportAs = 0;

  HasText := FALSE;

  for i := 0 to dbFormula.Lines.Count - 1 do
    if dbFormula.Lines[i] <> '' then
    begin
      HasText := TRUE;
      break;
    end;

  IsEnabled := HasText and Assigned(dbFormula.Highlighter);
  miExportClipboardNative.Enabled := IsEnabled;
  IsEnabled := IsEnabled and (fExportAs > 0);
  miExportToFile.Enabled := IsEnabled;
  miExportClipboardText.Enabled := IsEnabled;

end;

procedure TFrmFormula.miExportAsClicked(Sender: TObject);
begin
  if Sender = miExportAsHTML then
    fExportAs := 1
  else if Sender = miExportAsRTF then
    fExportAs := 2
  else
    fExportAs := 0;
end;

procedure TFrmFormula.miExportToFileClick(Sender: TObject);
var
  FileName: string;
  Exporter: TSynCustomExporter;
  DlgFileSaveAs: TSaveDialog;
begin

  if (fExportAs = 1) then
    Exporter := TSynExporterHTML.Create(Self)
  else if (fExportAs = 2) then
    Exporter := TSynExporterRTF.Create(Self)
  else
    Exit;

  DlgFileSaveAs := TSaveDialog.Create(Self);

  try

    DlgFileSaveAs.Filter   := Exporter.DefaultFilter;
    DlgFileSaveAs.FileName := kSubstitui( AnsiLowerCase(mtRegistro.FieldByName('NOME').AsString), ' ', '_');

    if DlgFileSaveAs.Execute then
    begin

      FileName := dlgFileSaveAs.FileName;

      case fExportAs of
        1: if ExtractFileExt(FileName) = '' then FileName := FileName + '.html';
        2: if ExtractFileExt(FileName) = '' then FileName := FileName + '.rtf';
      end;

      with Exporter do
      begin
        Title := 'Source file exported to file';
        Highlighter := dbFormula.Highlighter;
        ExportAsText := TRUE;
        ExportAll(dbFormula.Lines);
        SaveToFile(FileName);
      end;

    end;

  finally
    DlgFileSaveAs.Free;
    Exporter.Free;
  end;

end;

procedure TFrmFormula.miExportClipboardNativeClick(Sender: TObject);
begin

  Clipboard.Open;

  try

    Clipboard.AsText := dbFormula.Lines.Text;

    // HTML?
    if fExportAs in [0, 1] then
      with TSynExporterHTML.Create(Self) do
      try
        Title := 'Source file exported to clipboard (native format)';
        ExportAsText := FALSE;
        Highlighter := dbFormula.Highlighter;
        ExportAll(dbFormula.Lines);
        CopyToClipboard;
      finally
        Free;
      end;

    // RTF?
    if fExportAs in [0, 2] then
      with TSynExporterRTF.Create(Self) do
      try
        Title := 'Source file exported to clipboard (native format)';
        ExportAsText := FALSE;
        Highlighter := dbFormula.Highlighter;
        ExportAll(dbFormula.Lines);
        CopyToClipboard;
      finally
        Free;
      end;

  finally
    Clipboard.Close;
  end;

end;

procedure TFrmFormula.miExportClipboardTextClick(Sender: TObject);
var
  Exporter: TSynCustomExporter;
begin

  case fExportAs of
    1: Exporter := TSynExporterHTML.Create(Self);
    2: Exporter := TSynExporterRTF.Create(Self);
    else Exit;
  end;

  try

    with Exporter do
    begin
      Title := 'Source file exported to clipboard (as text)';
      ExportAsText := TRUE;
      Highlighter := dbFormula.Highlighter;
      ExportAll(dbFormula.Lines);
      CopyToClipboard;
    end;

  finally
    Exporter.Free;
  end;

end;

end.
