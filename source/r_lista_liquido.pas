{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2004 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@file-name: r_lista_liquido.pas
@file-date: 17-10-2004
@license: GNU GPL
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

unit r_lista_liquido;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QTypes, QForms, QGraphics, QControls, QMask, QExtCtrls, QStdCtrls,
  QDBCtrls, QAKPrint,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Forms, Graphics, Controls, Mask, ExtCtrls, StdCtrls, DBCtrls,
  Dialogs, AKPrint,
  {$ENDIF}
  SysUtils, Classes, DB, DBClient, MidasLib, Variants, MaskUtils;

type
  TFrmListaLiquido = class(TForm)
  protected
    DataSet1: TClientDataSet;
    DataSource1: TDataSource;
    pnlConfig: TPanel;
    { Lotacoes }
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacao: TDBEdit;
    dbLotacao2: TDBEdit;
    { Cargos }
    gpCargo: TGroupBox;
    dbCargoX: TCheckBox;
    dbCargo: TDBEdit;
    dbCargo2: TDBEdit;
    { Tipos }
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipo: TDBEdit;
    dbTipo2: TDBEdit;
    { Recursos }
    gpRecurso: TGroupBox;
    dbRecursoX: TCheckBox;
    dbRecurso: TDBEdit;
    dbRecurso2: TDBEdit;
    { Opcoes diversas }
    gpOrdem: TRadioGroup;
    dbSemLiquido: TCheckBox;
    dbAssinatura: TCheckBox;
    dbMostrarCPF: TCheckBox;
    dbTotalizar: TCheckBox;
    dbComprimir: TCheckBox;
    dbAgruparLotacao: TCheckBox;
    dbSepararLotacao: TCheckBox;
    { Botoes }
    pnlControle: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure dbLotacaoXClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    { Private declarations }
  private
    pvEmpresa: Integer;
    pvFolha: Integer;
    procedure CreateDB;
    procedure CreateControls;
    procedure CreateButtons;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

procedure CriaListaLiquido( Empresa, Folha:Integer);

procedure ImprimeListaLiquido( Empresa, Folha, Cargo: Integer;
  Lotacao, Tipo, Recurso, Ordem: String;
  Exc_Sem_Liquido, Assinatura, MostrarCPF, Totalizar,
  Comprimir, AgruparLotacao, SepararLotacao, Imprimir: Boolean);

implementation

uses
  fdb, ftext, fsuporte, flotacao, fcargo, ftipo, frecurso, fdepvar, fprint;

const
  C_AUTO_EDIT = True;

procedure CriaListaLiquido( Empresa, Folha:Integer);
begin

  if (Folha <= 0) then
    Exit;

  with TFrmListaLiquido.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    pvFolha   := Folha;
    ShowModal;
  finally
    Free;
  end;

end;

procedure ImprimeListaLiquido( Empresa, Folha, Cargo: Integer;
  Lotacao, Tipo, Recurso, Ordem: String;
  Exc_Sem_Liquido, Assinatura, MostrarCPF, Totalizar,
  Comprimir, AgruparLotacao, SepararLotacao, Imprimir: Boolean);
var
  DataSet1, cdEmpresa, cdFolha: TClientDataSet;
  SQL: TStringList;
  Deposito: TDeposito;
  sLoja: String;
  i: Integer;
begin

  DataSet1  := TClientDataSet.Create(NIL);
  cdEmpresa := TClientDataSet.Create(NIL);
  cdFolha   := TClientDataSet.Create(NIL);

  SQL       := TStringList.Create;
  Deposito  := TDeposito.Create;

  try try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');

    if AgruparLotacao then
      SQL.Add('  CF.IDLOTACAO, L.NOME LOTACAO,');

    SQL.Add('  F.IDFUNCIONARIO CODIGO, P.NOME,');

    if MostrarCPF then
      SQL.Add('  P.CPF_CGC CPF,');

    SQL.Add('  SUM(C.CALCULADO*C.LIQUIDO) LIQUIDO');

    if Assinatura then
      SQL.Add(', ''*'' AS ASSINATURA');

    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL C, F_CENTRAL_FUNCIONARIO CF,');
    SQL.Add('  FUNCIONARIO F, PESSOA P, F_LOTACAO L');

    SQL.Add('WHERE');

    SQL.Add('  C.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND C.IDFOLHA = :FOLHA');

    SQL.Add('  AND CF.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND CF.IDFOLHA = C.IDFOLHA');
    SQL.Add('  AND CF.IDFUNCIONARIO = C.IDFUNCIONARIO');

    SQL.Add('  AND F.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND F.IDFUNCIONARIO = C.IDFUNCIONARIO');

    if (Tipo <> '') then
      SQL.Add('  AND F.IDTIPO = '+QuotedStr(Tipo) );

    if (Recurso <> '') then
      SQL.Add('  AND F.IDRECURSO = '+QuotedStr(Recurso) );

    SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

    SQL.Add('  AND L.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND L.IDLOTACAO = CF.IDLOTACAO');

    if (Lotacao <> '') then
      SQL.Add('  AND L.CODIGO STARTING '+QuotedStr(Lotacao) );

    SQL.Add('GROUP BY');

    if AgruparLotacao then
      SQL.Add('  CF.IDLOTACAO, L.NOME,');

    SQL.Add('  F.IDFUNCIONARIO, P.NOME');

    if MostrarCPF then
      SQL.Add(', P.CPF_CGC');

    if Exc_Sem_Liquido then
      SQL.Add('HAVING SUM(C.CALCULADO*C.LIQUIDO) > 0');

    SQL.Add('ORDER BY');

    if AgruparLotacao then
      SQL.Add('  L.NOME, ');

    if (Ordem = 'N') then
      SQL.Add('  P.NOME')
    else
      SQL.Add('  F.IDFUNCIONARIO');

    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text, [Empresa, Folha]) then
      raise Exception.Create(kGetErrorLastSQL);

    if not kSQLSelectFrom( cdEmpresa, 'EMPRESA', Empresa) then
      raise Exception.Create(kGetErrorLastSQL);

    if not kSQLSelectFrom( cdFolha, 'F_FOLHA', Empresa,
                           'IDFOLHA = '+IntToStr(Folha)) then
      raise Exception.Create(kGetErrorLastSQL);

    with DataSet1 do
    begin

      if (RecordCount = 0) then
        raise Exception.Create('Não há dados a imprimir.');

      for i := 0 to FieldCount - 1 do
      begin

        Fields[i].Tag := 1; // Imprimir coluna

        if (Fields[i].FieldName = 'IDLOTACAO') then
        begin
          Fields[i].Tag := 2; // Agrupar
          Fields[i].DisplayLabel := '* LOTACAO:';
          Fields[i].DisplayWidth := 3;

        end else if (Fields[i].FieldName = 'LOTACAO') then
        begin
          Fields[i].Tag := 2; // Agrupar
          Fields[i].DisplayLabel := '-';

        end else if (Fields[i].FieldName = 'CODIGO') then
        begin
          Fields[i].DisplayLabel := 'CODIGO;;';
          Fields[i].DisplayWidth := 6;

        end else if (Fields[i].FieldName = 'NOME') then
        begin
          Fields[i].DisplayLabel := 'NOME DO FUNCIONARIO';
          if not SepararLotacao then
            Fields[i].DisplayLabel := Fields[i].DisplayLabel + ';SUBTOTAIS -> %S';
          Fields[i].DisplayLabel := Fields[i].DisplayLabel + ';TOTAIS -> %s';
          Fields[i].DisplayWidth := 40;

          if Assinatura then
            Fields[i].DisplayWidth := Fields[i].DisplayWidth - 5;

          if Comprimir then
            Fields[i].DisplayWidth := 50;

        end else if (Fields[i].FieldName = 'CPF') then
        begin
          Fields[i].DisplayLabel := 'CPF;;';
          Fields[i].DisplayWidth := 11;

        end else if (Fields[i].FieldName = 'LIQUIDO') then
        begin
          Fields[i].DisplayLabel := 'VALOR';
          Fields[i].DisplayWidth := 10;
          TCurrencyField(Fields[i]).DisplayFormat := ',0.00';

        end else if (Fields[i].FieldName = 'ASSINATURA') then
        begin
          Fields[i].DisplayLabel := 'ASSINATURA;;';
          Fields[i].DisplayWidth := 20;

        end else
          Fields[i].Tag := 0;  // Não imprimir

      end;

    end;  // DataSet1

    Deposito.SetDeposito( 'TITULO', 'RELACAO DE LIQUIDOS');
    Deposito.SetDeposito( 'COMPRIMIDO', Comprimir);
    Deposito.SetDeposito( 'SEPARA_QUEBRA', SepararLotacao);

    sLoja := 'FOLHA: '+
             cdFolha.FieldByName('IDFOLHA').AsString + ' - ' +
             cdFolha.FieldByName('DESCRICAO').AsString +
             ' - PERIODO: ' + cdFolha.FieldByName('PERIODO_INICIO').AsString +
             ' A ' + cdFolha.FieldByName('PERIODO_FIM').AsString;

    Deposito.SetDeposito( 'EMPRESA', cdEmpresa.FieldByName('NOME').AsString);         
    Deposito.SetDeposito( 'LOJA', sLoja);

    if not Comprimir then
      Deposito.SetDeposito( 'MARGEM_DIREITA', 80);

    Deposito.SetDeposito( 'TOTAL', Totalizar);

    if SepararLotacao then
      Deposito.SetDeposito( 'TOTAL', False);

    if Assinatura then
      Deposito.SetDeposito('SEPARA_LINHA', '-');

    kPrint( DataSet1, Imprimir, Deposito);

  except
    on E:Exception do
      kErro('Erro na Impressão da Lista de Líquidos.'#13#13+E.Message);
  end;
  finally

    DataSet1.Free;
    cdEmpresa.Free;
    cdFolha.Free;

    Deposito.Free;
    SQL.Free;

  end;

end;  // ImprimeListaLiquido

{ Formulario de Filtragem }

procedure TFrmListaLiquido.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = dbLotacao) and (Key = VK_RETURN) then
    PesquisaLotacao( dbLotacao.Text, pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_F12) then
    PesquisaLotacao( '', pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_RETURN) then
    PesquisaCargo( dbCargo.Text, pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_F12) then
    PesquisaCargo( '', pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_RETURN) then
    PesquisaTipo( dbTipo.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_F12) then
    PesquisaTipo( '', DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_RETURN) then
    PesquisaRecurso( dbRecurso.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_F12) then
    PesquisaRecurso( '', DataSet1, Key, '', C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;

procedure TFrmListaLiquido.dbLotacaoXClick(Sender: TObject);
var
  wControl: TControl;
  wCheck: TCheckBox;
begin

  wCheck   := TCheckBox(Sender);
  // Retorna o proximo controle cfe ordem de tabulacao
  wControl := kGetTabOrder( wCheck.Parent, wCheck.TabOrder+1);

  if Assigned(wControl) and (wControl is TDBEdit) then
    with TDBEdit(wControl) do
    begin
      TabStop := not wCheck.Checked;
      if wCheck.Checked then
        ParentColor := True
      else
        Color := clWindow;
    end;  // with TDBEdit

end;

procedure TFrmListaLiquido.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmListaLiquido.btnImprimirClick(Sender: TObject);
var
  iCargo: Integer;
  sLotacao, sRecurso, sTipo, sOrdem: String;
begin

  with DataSet1 do
  begin

    if State in [dsInsert,dsEdit] then
      Post;

    // valores padroes - todos os funcionarios
    iCargo   := -1;
    sLotacao := '';
    sTipo    := '';
    sRecurso := '';

    if not dbLotacaoX.Checked then
      sLotacao := FieldByName('LOTACAO_CODIGO').AsString;

    if not dbTipoX.Checked then
      sTipo := FieldByName('IDTIPO').AsString;

    if not dbRecursoX.Checked then
      sRecurso := FieldByName('IDRECURSO').AsString;

    if not dbCargoX.Checked then
      iCargo := FieldByName('IDCARGO').AsInteger;

    sOrdem   := gpOrdem.Items[gpOrdem.ItemIndex][1];

  end;  // with DataSet1

  ImprimeListaLiquido( pvEmpresa, pvFolha, iCargo, sLotacao, sTipo, sRecurso,
                       sOrdem, dbSemLiquido.Checked,
                       dbAssinatura.Checked,
                       dbMostrarCPF.Checked,
                       dbTotalizar.Checked,
                       dbComprimir.Checked,
                       dbAgruparLotacao.Checked,
                       dbSepararLotacao.Checked,
                       (TButton(Sender).Caption = '&Imprimir') );

end;

constructor TFrmListaLiquido.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption      := 'Impressão de Listagem de Líquidos';
  ClientHeight := 400;
  ClientWidth  := 550;

  Color  := $00E0E9EF;

  KeyPreview := True;
  Position   := poScreenCenter;

  {$IFDEF VCL}
  OnKeyDown := FormKeyDown;
  {$ENDIF}

  CreateDB;   // Criacao dos componentes de acesso a dados
  CreateControls; // Criacao dos componentes de interface

end;

procedure TFrmListaLiquido.CreateControls;
begin

  pnlConfig := TPanel.Create(Self);
  with pnlConfig do
  begin
    Parent := Self;
    Align := alTop;
    BevelOuter := bvNone;
    ParentColor := True;
  end;

  { Lotacao }

  gpLotacao := TGroupBox.Create(Self);
  with gpLotacao do
  begin
    Parent := pnlConfig;
    Left := 8;
    Top := 8;
    Width := Self.ClientWidth - (Left*2);
    Caption := 'Lotação';
  end;

  dbLotacaoX := TCheckBox.Create(Self);
  with dbLotacaoX do
  begin
    Parent := gpLotacao;
    Left := 8;
    Top := 20;
    Width := 120;
    Caption := 'Todas as &Lotações';
    Checked := True;
    State := cbChecked;
    OnClick := dbLotacaoXClick;
  end;

  dbLotacao := TDBEdit.Create(Self);
  with dbLotacao do
  begin
    Parent := gpLotacao;
    // Coordenadas
    Left   := dbLotacaoX.Left + dbLotacaoX.Width + 5;
    Top    := dbLotacaoX.Top;
    Width  := 80;
    Height := 21;
    CharCase := ecUpperCase;
    DataField := 'IDLOTACAO';
    DataSource := DataSource1;
    ParentColor := True;
    TabStop  := False;
  end;

  dbLotacao2 := TDBEdit.Create(Self);
  with dbLotacao2 do
  begin
    Parent    := gpLotacao;
    // Coordenadas
    Left   := dbLotacao.Left + dbLotacao.Width + 5;
    Top    := dbLotacao.Top;
    Width  := 280;
    Height := dbLotacao.Height;
    TabStop     := False;
    DataField   := 'LOTACAO';
    DataSource  := DataSource1;
    ParentColor := True;
    ReadOnly    := True;
    // Redimensionar
    Parent.Width  := Left + Width + (dbLotacaoX.Left);
    Parent.Height := Top + Height + (dbLotacaoX.Top div 2);
  end;

  ClientWidth := gpLotacao.Left + gpLotacao.Width + gpLotacao.Left;

  { Cargo de Funcionario }

  gpCargo := TGroupBox.Create(Self);
  with gpCargo do
  begin
    kControlAssigned( gpLotacao, gpCargo);
    Caption := 'Cargo';
  end;

  dbCargoX := TCheckBox.Create(Self);
  with dbCargoX do
  begin
    Parent := gpCargo;
    kControlAssigned( dbLotacaoX, dbCargoX);
    Caption := 'Todos os &Cargos';
    OnClick := dbLotacaoXClick;
  end;

  dbCargo := TDBEdit.Create(Self);
  with dbCargo do
  begin
    Parent := gpCargo;
    DataField := 'IDCARGO';
    kControlAssigned( dbLotacao, dbCargo);
  end;

  dbCargo2 := TDBEdit.Create(Self);
  with dbCargo2 do
  begin
    Parent := gpCargo;
    DataField := 'CARGO';
    kControlAssigned( dbLotacao2, dbCargo2);
  end;

  { Tipo de Funcionarios }

  gpTipo := TGroupBox.Create(Self);
  with gpTipo do
  begin
    kControlAssigned( gpCargo, gpTipo);
    Caption := 'Tipo de &Funcionário';
  end;

  dbTipoX := TCheckBox.Create(Self);
  with dbTipoX do
  begin
    Parent := gpTipo;
    kControlAssigned( dbCargoX, dbTipoX);
    Caption := 'Todos os &Tipos';
    OnClick := dbLotacaoXClick;
  end;

  dbTipo := TDBEdit.Create(Self);
  with dbTipo do
  begin
    Parent := gpTipo;
    DataField := 'IDTIPO';
    kControlAssigned( dbCargo, dbTipo);
  end;

  dbTipo2 := TDBEdit.Create(Self);
  with dbTipo2 do
  begin
    Parent := gpTipo;
    DataField := 'TIPO';
    kControlAssigned( dbCargo2, dbTipo2);
  end;

  { Recurso para Pagamento do Funcionario }

  gpRecurso := TGroupBox.Create(Self);
  with gpRecurso do
  begin
    kControlAssigned( gpTipo, gpRecurso);
    Caption := 'Recursos';
  end;

  dbRecursoX := TCheckBox.Create(Self);
  with dbRecursoX do
  begin
    Parent := gpRecurso;
    kControlAssigned( dbTipoX, dbRecursoX);
    Caption := 'Todos os &Recursos';
    OnClick := dbLotacaoXClick;
  end;

  dbRecurso := TDBEdit.Create(Self);
  with dbRecurso do
  begin
    Parent := gpRecurso;
    DataField := 'IDRECURSO';
    kControlAssigned( dbTipo, dbRecurso);
  end;

  dbRecurso2 := TDBEdit.Create(Self);
  with dbRecurso2 do
  begin
    Parent := gpRecurso;
    DataField := 'RECURSO';
    kControlAssigned( dbTipo2, dbRecurso2);
  end;

  { Opcoes Diversas }

  gpOrdem := TRadioGroup.Create(Self);
  with gpOrdem do
  begin
    Parent  := pnlConfig;
    Left    := gpRecurso.Left;
    Top     := gpRecurso.Top + gpRecurso.Height + 5;
    Width   := 100;
    Height  := gpRecurso.Height + 5;
    Caption := 'Cla&ssificação';
    Items.Add('Nome');
    Items.Add('Código');
    ItemIndex := 0;
  end;

  dbSemLiquido := TCheckBox.Create(Self);

  with dbSemLiquido do
  begin
    Parent  := pnlConfig;
    Left    := gpOrdem.Left + gpOrdem.Width + 10;
    Top     := gpOrdem.Top + 5;
    Width   := 120;
    Caption := 'Excluir sem Líquido';
    State   := cbChecked;
    Checked := True;
  end;

  dbAssinatura := TCheckBox.Create(Self);

  with dbAssinatura do
  begin
    Parent  := pnlConfig;
    Left    := dbSemLiquido.Left;
    Top     := dbSemLiquido.Top + dbSemLiquido.Height + 5;
    Width   := dbSemLiquido.Width;
    Caption := 'Assinatura';
    State   := cbChecked;
    Checked := True;
  end;

  dbMostrarCPF := TCheckBox.Create(Self);

  with dbMostrarCPF do
  begin
    Parent  := pnlConfig;
    Left    := dbAssinatura.Left;
    Top     := dbAssinatura.Top + dbAssinatura.Height + 5;
    Width   := dbAssinatura.Width;
    Caption := 'Mostrar CPF';
    State   := cbChecked;
    Checked := False;
  end;

  // --

  dbTotalizar := TCheckBox.Create(Self);

  with dbTotalizar do
  begin
    Parent  := pnlConfig;
    Left    := dbSemLiquido.Left + dbSemLiquido.Width + 5;
    Top     := dbSemLiquido.Top;
    Width   := dbSemLiquido.Width;
    Caption := 'Totalizar';
    State   := cbChecked;
    Checked := True;
  end;

  dbAgruparLotacao := TCheckBox.Create(Self);

  with dbAgruparLotacao do
  begin
    Parent  := pnlConfig;
    Left    := dbTotalizar.Left;
    Top     := dbTotalizar.Top + dbTotalizar.Height + 5;
    Width   := dbTotalizar.Width;
    Caption := 'Agrupar por Agência';
    State   := cbChecked;
    Checked := False;
  end;

  dbSepararLotacao := TCheckBox.Create(Self);

  with dbSepararLotacao do
  begin
    Parent  := pnlConfig;
    Left    := dbAgruparLotacao.Left;
    Top     := dbAgruparLotacao.Top + dbAgruparLotacao.Height + 5;
    Width   := dbAgruparLotacao.Width;
    Caption := 'Separar por Agência';
    State   := cbChecked;
    Checked := False;
  end;

  // --

  dbComprimir := TCheckBox.Create(Self);

  with dbComprimir do
  begin
    Parent  := pnlConfig;
    Left    := dbTotalizar.Left + dbTotalizar.Width + 5;
    Top     := dbTotalizar.Top;
    Width   := dbTotalizar.Width;
    Caption := 'Comprimir';
    State   := cbChecked;
    Checked := False;
  end;

  pnlConfig.Height := dbSepararLotacao.Top + dbSepararLotacao.Height + 5;

  CreateButtons;

  Self.ClientHeight := pnlConfig.Height + pnlControle.Height + 5;

end;

procedure TFrmListaLiquido.CreateDB;
begin

  DataSet1 := TClientDataSet.Create(Self);

  with DataSet1 do
  begin
    FieldDefs.Add( 'IDLOTACAO', ftInteger);
    FieldDefs.Add( 'LOTACAO', ftString, 50);
    FieldDefs.Add( 'LOTACAO_CODIGO', ftString, 15);
    FieldDefs.Add( 'IDTIPO', ftString, 2);
    FieldDefs.Add( 'TIPO', ftString, 30);
    FieldDefs.Add( 'IDCARGO', ftInteger);
    FieldDefs.Add( 'CARGO', ftString, 50);
    FieldDefs.Add( 'IDRECURSO', ftString, 2);
    FieldDefs.Add( 'RECURSO', ftString, 30);
    CreateDataSet;
    Append;
  end;

  DataSource1 := TDataSource.Create(Self);
  DataSource1.AutoEdit := True;
  DataSource1.DataSet  := DataSet1;

end;  // CreateDB

procedure TFrmListaLiquido.CreateButtons;
var
  bImprimir, bVisualizar, bCancelar: TButton;
begin

  pnlControle := TPanel.Create(Self);

  with pnlControle do
  begin
    Parent := Self;
    Align := alBottom;
    BevelOuter := bvLowered;
    ParentColor := True;
  end;

  bImprimir := TButton.Create(Self);

  with bImprimir do
  begin
    Parent  := pnlControle;
    Left    := Parent.Width - ((Width*3) + 40);
    Top     := 10;
    Width   := 75;
    Caption := '&Imprimir';
    OnClick := btnImprimirClick;
  end;

  bVisualizar := TButton.Create(Self);

  with bVisualizar do
  begin
    Parent  := bImprimir.Parent;
    Left    := bImprimir.Left + bImprimir.Width + 10;
    Top     := bImprimir.Top;
    Width   := bImprimir.Width;
    Height  := bImprimir.Height;
    Caption := '&Visualizar';
    OnClick := bImprimir.OnClick;
  end;

  bCancelar := TButton.Create(Self);

  with bCancelar do
  begin
    Parent  := bVisualizar.Parent;
    Left    := bVisualizar.Left + bVisualizar.Width + 10;
    Top     := bVisualizar.Top;
    Width   := bVisualizar.Width;
    Height  := bVisualizar.Height;
    Cancel  := True;
    Caption := 'Cancelar';
    OnClick := btnCancelarClick;
  end;

  pnlControle.Height := (bImprimir.Top*2) + bImprimir.Height;

end;  // CreateButtons

end.
