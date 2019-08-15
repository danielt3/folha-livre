{
Projeto FolhaLivre - Folha de Pagamento
Copyright (c) 2003-2007 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Historico das modificacoes
--------------------------

* 29/07/2003 - Primeira versão
* 11/01/2007 - Geracao de arquivo no formato CNAB240
}

unit r_lista_bancaria;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QTypes, QForms, QGraphics, QControls, QMask, QExtCtrls, QStdCtrls,
  QDBCtrls, QAKPrint,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Forms, Graphics, Controls, Mask, ExtCtrls, StdCtrls, DBCtrls,
  Dialogs, AKPrint,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, Variants, MaskUtils;

type
  TFrmListaBancaria = class(TForm)
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
    { Bancos e Agencias }
    gpBanco: TGroupBox;
    dbBancoX: TCheckBox;
    dbBanco: TDBEdit;
    dbBanco2: TDBEdit;
    dbAgenciaX: TCheckBox;
    dbAgencia: TDBEdit;
    dbAgencia2: TDBEdit;
    { Opcoes diversas }
    gpFormato: TRadioGroup;
    gpOrdem: TRadioGroup;
    dbSemConta: TCheckBox;
    dbSemLiquido: TCheckBox;
    { Botoes }
    pnlControle: TPanel;
    btnGravar: TButton;
    btnImprimir: TButton;
    btnVisualizar: TButton;
    btnCancelar: TButton;
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

  TFPrint = class(TComponent)
  protected
    procedure CustomReportGenerate(Sender: TObject);
  private
    { Private declarations }
    FReport: TAKCustomReport;
    FPrinter: TAKPrinter;
    mtBanco: TClientDataSet;
    mtEmpresa: TClientDataSet;
    mtEmpresaDados: TClientDataSet;
    mtFolha: TClientDataSet;
    mtDetalhe: TClientDataSet;
    pvEmpresa, pvFolha, pvLotacao: Integer;
    pvRecurso, pvTipo: string;
    pvBanco, pvAgencia: String;
    pvFormato, pvOrdem: String;
    pvExc_Sem_Conta: Boolean;
    pvExc_Sem_Liquido: Boolean;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Processa;
    function GravarArquivo(const NomeArquivo: string):Integer;
  end;

procedure CriaListaBancaria( Empresa, Folha:Integer);

procedure ImprimeListaBancaria( Empresa, Folha, Lotacao, Cargo: Integer;
  Tipo, Recurso, Banco, Agencia, Formato, Ordem: String;
  Exc_Sem_Conta, Exc_Sem_Liquido: Boolean;
  Arquivo: String; Imprimir: Boolean);

implementation

uses
  fdb, ftext, fsuporte, flotacao, fcargo, ftipo, frecurso, fbanco, cnab240;

const
  C_AUTO_EDIT = True;

procedure CriaListaBancaria( Empresa, Folha:Integer);
begin

  if (Folha <= 0) then
    Exit;

  with TFrmListaBancaria.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    pvFolha   := Folha;
    ShowModal;
  finally
    Free;
  end;

end;

procedure ImprimeListaBancaria( Empresa, Folha, Lotacao, Cargo: Integer;
  Tipo, Recurso, Banco, Agencia, Formato, Ordem: String;
  Exc_Sem_Conta, Exc_Sem_Liquido: Boolean;
  Arquivo: String; Imprimir: Boolean);
var
  iNSA: Integer;
begin

  with TFPrint.Create(NIL) do
  try try

    pvEmpresa := Empresa;
    pvFolha   := Folha;
    pvRecurso := Recurso;
    pvLotacao := Lotacao;
    pvTipo    := Tipo;
    pvBanco   := Banco;
    pvAgencia := Agencia;
    pvFormato := Formato;
    pvOrdem   := Ordem;

    pvExc_Sem_Conta   := Exc_Sem_Conta;
    pvExc_Sem_Liquido := Exc_Sem_Liquido;

    if (Arquivo <> '') then
    begin
      if (pvBanco = '') then  // Todos os Bancos
        raise Exception.Create('A escolha do banco é obrigatória para a geração do arquivo.');
      pvExc_Sem_Conta   := True;
      pvExc_Sem_Liquido := True;
      if (pvAgencia <> '') then
        kAviso('O sistema considerará todas as agências do banco selecionado');
      pvAgencia := '';   // Todas as agências
    end;

    Processa();

    if (Arquivo <> '') then
    begin

      iNSA := GravarArquivo(Arquivo);

      if kConfirme( 'O arquivo "'+Arquivo+'" foi gerado com sucesso.'#13+
                    'Deseja que o número sequencial de arquivo seja incrementado?') then
      begin
        if kCountSQL( 'EMPRESA_DADOS',
                      'IDEMPRESA = :EMPRESA AND CHAVE = :CHAVE',
                      [pvEmpresa, 'NSA_'+pvBanco]) = 0 then
          kExecSQL('INSERT INTO EMPRESA_DADOS'#13+
                   '(IDEMPRESA, CHAVE, VALOR, ATIVO_X)'#13+
                   'VALUES (:EMPRESA, :CHAVE, :VALOR, :ATIVO)',
                   [pvEmpresa, 'NSA_'+pvBanco, iNSA, 1])
        else
          kExecSQL('UPDATE EMPRESA_DADOS SET VALOR = :VALOR'#13+
                   'WHERE IDEMPRESA = :EMPRESA AND CHAVE = :CHAVE',
                   [iNSA, pvEmpresa, 'NSA_'+pvBanco]);
      end;
    end else
    begin
      FPrinter.Preview := (not Imprimir);
      FReport.OnGenerate := CustomReportGenerate;
      FReport.Execute;
    end;

  except
    on E:Exception do
      kErro('Erro na Impressão da Lista Bancária.'#13#13+E.Message);
  end;
  finally
    Free;
  end;

end;  // ImprimeListaBancaria

{ Formulario de Filtragem para Contra Cheque}

procedure TFrmListaBancaria.FormKeyDown(Sender: TObject; var Key: Word;
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
    PesquisaRecurso( '', DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbBanco) and (Key = VK_RETURN) then
    PesquisaBanco( dbBanco.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbBanco) and (Key = VK_F12) then
    PesquisaBanco( '', DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbAgencia) and (Key = VK_RETURN) then
    PesquisaAgencia( dbAgencia.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbAgencia) and (Key = VK_F12) then
    PesquisaAgencia( '', DataSet1, Key, '', C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;

procedure TFrmListaBancaria.dbLotacaoXClick(Sender: TObject);
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

procedure TFrmListaBancaria.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmListaBancaria.btnImprimirClick(Sender: TObject);
var
  iCargo, iLotacao: Integer;
  sRecurso, sTipo, sBanco, sAgencia, sFormato, sOrdem, sArquivo: String;
begin

  sArquivo := '';

  if (Sender = btnGravar) then
  begin
    with TSaveDialog.Create(Self) do
    try
      Title := 'Salvar Arquivo Como';
      Filter  := 'Arquivo Texto (*.txt)|*.txt|Todos os Arquivos (*.*)|*.*';
      if Execute then
        sArquivo := FileName;
    finally
      Free;
    end;
    if (sArquivo = '') then
      Exit;
  end;

  with DataSet1 do
  begin

    if State in [dsInsert,dsEdit] then
      Post;

    // valores padroes - todos os funcionarios
    iLotacao := -1;
    iCargo   := -1;
    sTipo    := '';
    sRecurso := '';
    sBanco   := '';
    sAgencia := '';

    if not dbLotacaoX.Checked then
      iLotacao := FieldByName('IDLOTACAO').AsInteger;

    if not dbTipoX.Checked then
      sTipo := FieldByName('IDTIPO').AsString;

    if not dbRecursoX.Checked then
      sRecurso := FieldByName('IDRECURSO').AsString;

    if not dbCargoX.Checked then
      iCargo := FieldByName('IDCARGO').AsInteger;

    if not dbBancoX.Checked then
      sBanco := FieldByName('IDBANCO').AsString;

    if not dbAgenciaX.Checked then
      sAgencia := FieldByName('IDAGENCIA').AsString;

    sFormato := gpFormato.Items[gpFormato.ItemIndex][1];
    sOrdem   := gpOrdem.Items[gpOrdem.ItemIndex][1];

  end;  // with DataSet1

  ImprimeListaBancaria( pvEmpresa, pvFolha, iLotacao, iCargo, sTipo, sRecurso,
                        sBanco, sAgencia, sFormato, sOrdem,
                        dbSemConta.Checked, dbSemLiquido.Checked,
                        sArquivo, (Sender = btnImprimir) );

end;

constructor TFrmListaBancaria.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption      := 'Impressão de Listagem Bancária';
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

procedure TFrmListaBancaria.CreateControls;
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
    Left := dbLotacaoX.Left + dbLotacaoX.Width + 5;
    Top := dbLotacaoX.Top;
    Width := 80;
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
    Parent := gpLotacao;
    Left := dbLotacao.Left + dbLotacao.Width + 5;
    Top := dbLotacao.Top;
    Width := 280;
    Height := dbLotacao.Height;
    TabStop := False;
    DataField := 'LOTACAO';
    DataSource := DataSource1;
    ParentColor := True;
    ReadOnly := True;
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

  { Bancos e Agencias }

  gpBanco := TGroupBox.Create(Self);
  with gpBanco do
  begin
    kControlAssigned( gpRecurso, gpBanco);
    Caption := 'Bancos e Agências';
  end;

  dbBancoX := TCheckBox.Create(Self);
  with dbBancoX do
  begin
    Parent  := gpBanco;
    kControlAssigned( dbRecursoX, dbBancoX);
    Caption := 'Todos os &Bancos';
    OnClick := dbLotacaoXClick;
  end;

  dbBanco := TDBEdit.Create(Self);
  with dbBanco do
  begin
    Parent := dbBancoX.Parent;
    DataField := 'IDBANCO';
    kControlAssigned( dbRecurso, dbBanco);
  end;

  dbBanco2 := TDBEdit.Create(Self);
  with dbBanco2 do
  begin
    Parent := dbBancoX.Parent;
    DataField := 'BANCO';
    kControlAssigned( dbRecurso2, dbBanco2);
  end;

  { Agencias }

  dbAgenciaX := TCheckBox.Create(Self);
  with dbAgenciaX do
  begin
    Parent  := dbBancoX.Parent;
    kControlAssigned( dbBancoX, dbAgenciaX);
    Top     := dbBanco.Top + dbBanco.Height + 5;
    Caption := 'Todas as &Agencias';
    OnClick := dbLotacaoXClick;
  end;

  dbAgencia := TDBEdit.Create(Self);
  with dbAgencia do
  begin
    Parent := dbBancoX.Parent;
    DataField := 'IDAGENCIA';
    kControlAssigned( dbBanco, dbAgencia);
    Top := dbAgenciaX.Top;
  end;

  dbAgencia2 := TDBEdit.Create(Self);
  with dbAgencia2 do
  begin
    Parent := dbBancoX.Parent;
    DataField := 'AGENCIA';
    kControlAssigned( dbBanco2, dbAgencia2);
    Top := dbAgencia.Top;
    Parent.Height := Top + Height + ( dbBancoX.Top div 2);
  end;

  { Opcoes Diversas }

  gpFormato := TRadioGroup.Create(Self);
  with gpFormato do
  begin
    Parent := pnlConfig;
    Left   := gpBanco.Left;
    Top    := gpBanco.Top + gpBanco.Height + 5;
    Width  := 120;
    Height := 60;
    Caption := 'Formato';
    Items.Add('Resumo');
    Items.Add('Detalhado');
    ItemIndex := 0;
  end;

  gpOrdem := TRadioGroup.Create(Self);
  with gpOrdem do
  begin
    Parent := pnlConfig;
    Left := gpFormato.Left + gpFormato.Width + 5;
    Top := gpFormato.Top;
    Width := gpFormato.Width;
    Height := gpFormato.Height;
    Caption := 'Cla&ssificação';
    Items.Add('Nome');
    Items.Add('Código');
    ItemIndex := 0;
  end;

  dbSemConta := TCheckBox.Create(Self);
  with dbSemConta do
  begin
    Parent  := pnlConfig;
    Left    := gpOrdem.Left + gpOrdem.Width + 5;
    Top     := gpOrdem.Top + 5;
    Width   := 150;
    Height  := 17;
    Caption := 'Excluir sem Conta Bancária';
    Checked := True;
    State   := cbChecked;
  end;

  dbSemLiquido := TCheckBox.Create(Self);
  with dbSemLiquido do
  begin
    Parent  := pnlConfig;
    Left    := dbSemConta.Left;
    Top     := dbSemConta.Top + dbSemConta.Height + 5;
    Width   := dbSemConta.Width;
    Height  := dbSemConta.Height;
    Caption := 'Excluir sem Líquido';
    Checked := True;
    State   := cbChecked;
  end;

  pnlConfig.Height := gpOrdem.Top + gpOrdem.Height + 5;

  CreateButtons;

  Self.ClientHeight := pnlConfig.Height + pnlControle.Height + 5;

end;

procedure TFrmListaBancaria.CreateDB;
begin

  DataSet1 := TClientDataSet.Create(Self);

  with DataSet1 do
  begin
    FieldDefs.Add( 'IDLOTACAO', ftInteger);
    FieldDefs.Add( 'LOTACAO', ftString, 50);
    FieldDefs.Add( 'IDTIPO', ftString, 2);
    FieldDefs.Add( 'TIPO', ftString, 30);
    FieldDefs.Add( 'IDCARGO', ftInteger);
    FieldDefs.Add( 'CARGO', ftString, 50);
    FieldDefs.Add( 'IDRECURSO', ftString, 2);
    FieldDefs.Add( 'RECURSO', ftString, 30);
    FieldDefs.Add( 'IDBANCO', ftString, 3);
    FieldDefs.Add( 'BANCO', ftString, 50);
    FieldDefs.Add( 'IDAGENCIA', ftString, 4);
    FieldDefs.Add( 'AGENCIA', ftString, 50);
    CreateDataSet;
    Append;
  end;

  DataSource1 := TDataSource.Create(Self);
  DataSource1.AutoEdit := True;
  DataSource1.DataSet  := DataSet1;

end;  // CreateDB

procedure TFrmListaBancaria.CreateButtons;
begin

  pnlControle := TPanel.Create(Self);

  with pnlControle do
  begin
    Parent := Self;
    Align := alBottom;
    BevelOuter := bvLowered;
    ParentColor := True;
  end;

  btnGravar := TButton.Create(Self);

  with btnGravar do
  begin
    Parent := pnlControle;
    Top := 10;
    Width := 150;
    Left := Parent.Width - ((75*5) + 40);
    Caption := '&Gravar (CNAB240) ...';
    OnClick := btnImprimirClick;
  end;

  btnImprimir := TButton.Create(Self);

  with btnImprimir do
  begin
    Parent  := btnGravar.Parent;
    Left    := btnGravar.Left + btnGravar.Width + 10;
    Top     := btnGravar.Top;
    Width   := 75;
    Height  := btnGravar.Height;
    Caption := '&Imprimir';
    OnClick := btnImprimirClick;
  end;

  btnVisualizar := TButton.Create(Self);

  with btnVisualizar do
  begin
    Parent  := btnImprimir.Parent;
    Left    := btnImprimir.Left + btnImprimir.Width + 10;
    Top     := btnImprimir.Top;
    Width   := 75;
    Height  := btnImprimir.Height;
    Caption := '&Visualizar';
    OnClick := btnImprimirClick;
  end;

  btnCancelar := TButton.Create(Self);

  with btnCancelar do
  begin
    Parent  := btnVisualizar.Parent;
    Left    := btnVisualizar.Left + btnVisualizar.Width + 10;
    Top     := btnVisualizar.Top;
    Width   := 75;
    Height  := btnVisualizar.Height;
    Cancel  := True;
    Caption := 'Cancelar';
    OnClick := btnCancelarClick;
  end;

  pnlControle.Height := (btnImprimir.Top*2) + btnImprimir.Height;

end;  // CreateButtons

{Impressão}

procedure TFPrint.Processa;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  F.IDBANCO, B.NOME BANCO,');
    SQL.Add('  F.IDAGENCIA, A.NOME AGENCIA,');
    SQL.Add('  F.IDFUNCIONARIO CODIGO, P.NOME,');
    SQL.Add('  CF.SALARIO, P.CPF_CGC CPF,');
    SQL.Add('  CF.IDLOTACAO, L.NOME LOTACAO,');
    SQL.Add('  F.CONTA_BANCARIA CONTA,');
    SQL.Add('  SUM(C.CALCULADO*C.LIQUIDO) LIQUIDO');
    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL C, F_CENTRAL_FUNCIONARIO CF,');
    SQL.Add('  FUNCIONARIO F, PESSOA P, F_EVENTO E,');
    SQL.Add('  BANCO B, AGENCIA A, F_LOTACAO L');
    SQL.Add('WHERE');

    SQL.Add('  C.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND C.IDFOLHA = :FOLHA');

    SQL.Add('  AND CF.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND CF.IDFOLHA = C.IDFOLHA');
    SQL.Add('  AND CF.IDFUNCIONARIO = C.IDFUNCIONARIO');

    if (pvLotacao <> -1) then
      SQL.Add(' AND CF.IDLOTACAO = '+IntToStr(pvLotacao) );

    SQL.Add('  AND F.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND F.IDFUNCIONARIO = C.IDFUNCIONARIO');

    if (pvTipo <> '') then
      SQL.Add('  AND F.IDTIPO = '+QuotedStr(pvTipo) );

    if (pvRecurso <> '') then
      SQL.Add('  AND F.IDRECURSO = '+QuotedStr(pvRecurso) );

    if (pvBanco <> '') then
      SQL.Add('  AND F.IDBANCO = '+QuotedStr(pvBanco) );

    if (pvAgencia <> '') then
      SQL.Add('  AND F.IDAGENCIA = '+QuotedStr(pvAgencia) );

    if pvExc_Sem_Conta then
    begin
      SQL.Add('  AND F.IDBANCO <> '+QuotedStr('000') );
      SQL.Add('  AND F.IDAGENCIA <> '+QuotedStr('00000'));
      SQL.Add('  AND (F.CONTA_BANCARIA IS NOT NULL)');
      SQL.Add('  AND F.CONTA_BANCARIA <> '+QuotedStr(''));
    end;

    SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

    SQL.Add('  AND E.IDEVENTO = C.IDEVENTO');

    SQL.Add('  AND B.IDBANCO = F.IDBANCO');
    SQL.Add('  AND A.IDBANCO = F.IDBANCO');
    SQL.Add('  AND A.IDAGENCIA = F.IDAGENCIA');

    SQL.Add('  AND L.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND L.IDLOTACAO = CF.IDLOTACAO');

    SQL.Add('GROUP BY');
    SQL.Add('  F.IDBANCO, B.NOME,');
    SQL.Add('  F.IDAGENCIA, A.NOME,');
    SQL.Add('  F.IDFUNCIONARIO, P.NOME,');
    SQL.Add('  CF.SALARIO, P.CPF_CGC,');
    SQL.Add('  CF.IDLOTACAO, L.NOME, F.CONTA_BANCARIA');

    if pvExc_Sem_Liquido then
      SQL.Add('HAVING SUM(C.CALCULADO*C.LIQUIDO) > 0');

    SQL.Add('ORDER BY');
    SQL.Add('  F.IDBANCO, F.IDAGENCIA');

    if (pvOrdem = 'N') then
      SQL.Add(', P.NOME')
    else
      SQL.Add(', F.IDFUNCIONARIO');

    SQL.EndUpdate;

    if not kOpenSQL( mtDetalhe, SQL.Text, [pvEmpresa, pvFolha]) then
      raise Exception.Create(kGetErrorLastSQL);

    if (mtDetalhe.RecordCount = 0) then
      raise Exception.Create('Não há dados a imprimir.');

    kSQLSelectFrom( mtEmpresa, 'EMPRESA', pvEmpresa);
    kSQLSelectFrom( mtEmpresaDados, 'EMPRESA_DADOS', pvEmpresa);
    kSQLSelectFrom( mtFolha, 'F_FOLHA', pvEmpresa, 'IDFOLHA = '+IntToStr(pvFolha));

    kOpenSQL( mtBanco, 'BANCO', 'IDBANCO = :BANCO', [pvBanco]);

  finally
    SQL.Free;
  end;

end; // Processa

function TFPrint.GravarArquivo(const NomeArquivo: string):Integer;
var
  cLiquido: Currency;
  sRazaoSocial, sCNPJ, sBancoNome: string;
  sNome, sConta, sBanco, sAgencia: string;
  sDocumento: String;
  dCredito: TDateTime;
begin

  Result := 0;

  sRazaoSocial := mtEmpresa.FieldByName('NOME').AsString;
  sCNPJ := mtEmpresa.FieldByName('CPF_CGC').AsString;
  dCredito := mtFolha.FieldByName('DATA_CREDITO').AsDateTime;
  sBancoNome := mtBanco.FieldByName('NOME').AsString;

  with TCNAB240.Create do
  try

    // Dados da empresa
    Banco := pvBanco; // Provisorio
    NomeBanco := sBancoNome;
    NomeEmpresa := sRazaoSocial;
    Inscricao := sCNPJ;

    if not mtEmpresaDados.Locate('CHAVE', 'CONVENIO_'+Banco, []) then
      raise Exception.Create('O número do convênio com o banco não foi encontrado.'#13+
                             'Cadastre em "Configurações da Empresa Ativa" a chave'#13+
                             '"CONVENIO_'+Banco+' com o número do convênio.');

    Convenio := mtEmpresaDados.FieldByName('VALOR').AsString;

    if mtEmpresaDados.Locate('CHAVE', 'NSA_'+Banco, []) then
      NumeroSequencial := mtEmpresaDados.FieldByName('VALOR').AsInteger + 1;

    AddHeaderFile();
    AddHeaderLote();

    while not mtDetalhe.Eof do
    begin

      { Composicao do registro Transação }

      sNome     := mtDetalhe.FieldByName('NOME').AsString;
      cLiquido  := mtDetalhe.FieldByName('LIQUIDO').AsCurrency;
      sConta    := mtDetalhe.FieldByName('CONTA').AsString;
      sBanco := mtDetalhe.FieldByName('IDBANCO').AsString;
      sAgencia  := mtDetalhe.FieldByName('IDAGENCIA').AsString;
      sDocumento := '';

      AddDetalhe( ccDOC, sBanco, sAgencia, sConta, sNome, sDocumento,
                  dCredito, cLiquido, sfAtivo);

       mtDetalhe.Next;

    end;

    AddTraillerLote();
    AddTraillerFile();

    SaveToFile(NomeArquivo);
    Result := NumeroSequencial;

  finally
    Free;
  end;

end;

procedure TFPrint.CustomReportGenerate(Sender: TObject);
const
  FMT_VALOR = '#,###,##0.00';

var
  sEmpresa: String;
  iMargem, iPaginaAtual, iLinhaAtual, iLinhaPorPagina: Integer;
  sTitulo, sSubTitulo, sCabecalhoColuna, Texto: String;
  iMargemDireita: Integer;
  sBanco, sBancoNome, sAgencia, sAgenciaNome: String;
  cLiquido, cTotalBanco, cTotalAgencia: Currency;
  cTotalPagina, cTotalGeral: Currency;

  function FormataCpf( const Cpf:String):String;
  var
    Texto: String;
  begin

    Texto := kRetiraChar( Cpf, '.-/');
    Texto := Trim(Cpf);

    if (Length(Texto) = 11) then
      Result := FormatMaskText( '999.999.999-99;0;_', Texto)
    else if (Length(Texto) = 14) then
      Result := FormatMaskText( '99.999.999/9999-99;0;_', Texto)
    else
      Result := kEspaco(14);

  end;  // FormataCpf

  function FormataConta( const Conta:String):String;
  var
    Texto: String;
  begin

    Texto := kRetiraChar( Trim(Conta), '.-');

    if (Length(Texto) = 0) then
      Result := kEspaco(13)
    else begin

      Texto := PadLeftChar( Texto, 10);
      Texto := Trim(FormatMaskText( '999.999.999-9;0;_', Texto));

      while (Texto[1] = '.') or (Texto[1] = ' ') do
        Texto := Copy( Texto, 2, Length(Texto));

      Result := PadLeftChar( Texto, 13);

    end;

  end;  // FormataConta

  function Formata( const Formato, Prefixo: string; Valor: Extended): string;
  begin
    Result := FormatFloat( Formato, Valor);
    Result := StringOfChar( Prefixo[1], Length(Formato)-Length(Result))+Result;
  end;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    with FPrinter do
      Escribir( Coluna, Linha, Texto, FastFont );
    Inc(iLinhaAtual);
  end;

  procedure CabecalhoBanco();
  begin

    sBanco     := mtDetalhe.FieldByName('IDBANCO').AsString;
    sBancoNome := mtDetalhe.FieldByName('BANCO').AsString;

    sAgencia     := mtDetalhe.FieldByName('IDAGENCIA').AsString;
    sAgenciaNome := mtDetalhe.FieldByName('AGENCIA').AsString;

    Escreve( iLinhaAtual, iMargem, Replicate('-', iMargemDireita) );
    Escreve( iLinhaAtual, iMargem, 'BANCO: '+sBanco+' - '+sBancoNome+
                                   ' * AGENCIA: '+sAgencia+' - '+sAgenciaNome );
    Escreve( iLinhaAtual, iMargem, Replicate('-', iMargemDireita) );

  end;

  procedure Cabecalho;
  begin

    sEmpresa := mtEmpresa.FieldByName('NOME').AsString;
    sTitulo  := 'Endereco: '+mtEmpresa.FieldByName('ENDERECO').AsString+kEspaco(10)+
                'CNPJ/CEI: '+FormataCpf( mtEmpresa.FieldByName('CPF_CGC').AsString);

    sSubTitulo := 'Ref.: '+FormatDateTime( 'dd/mm/yyyy', mtFolha.FieldByName('PERIODO_INICIO').AsDateTime)+' a '+
                           FormatDateTime( 'dd/mm/yyyy', mtFolha.FieldByName('PERIODO_FIM').AsDateTime) +
                  '  -  Folha no.: '+mtFolha.FieldByName('IDFOLHA').AsString + ' - '+
                  mtFolha.FieldByName('DESCRICAO').AsString ;

    sCabecalhoColuna := PadRightChar( 'C/C', 13) + kEspaco(2) +
                        'Mat.' +  kEspaco(2) +
                        PadRightChar( 'Nome do Funcionario', 50) + kEspaco(2) +
                        PadRightChar( 'CPF', 14) + kEspaco(2) +
                        PadLeftChar( 'Liquido', Length(FMT_VALOR) ) + kEspaco(2) +
                        PadLeftChar( 'Tot. Agencia', Length(FMT_VALOR) ) + kEspaco(2) +
                        PadLeftChar( 'Total Banco', Length(FMT_VALOR) );

    FPrinter.NuevaPagina;
    iPaginaAtual := iPaginaAtual + 1;

    Escreve( 2, iMargem, 'FolhaLivre - folha-livre.codigolivre.org');
    Escreve( 2, (iMargemDireita-iMargem-Length(sEmpresa)) div 2, sEmpresa );
    Escreve( 2, iMargemDireita-18, FormatDateTime('dd/mm/yyyy - hh:nn',Now) );

    Escreve( 3, (iMargemDireita-iMargem-Length(sTitulo)) div 2, sTitulo );
    Escreve( 3, iMargemDireita-8, 'Pag. '+kStrZero( iPaginaAtual, 3) );

    Escreve( 4, (iMargemDireita-iMargem-Length(sSubTitulo)) div 2, sSubTitulo);

    Escreve( 5, iMargem, Replicate('-', iMargemDireita)) ;
    Escreve( 6, iMargem, sCabecalhoColuna);

    iLinhaAtual  := 7;
    cTotalPagina := 0.00;

  end;

begin

  iLinhaPorPagina := 60;
  iPaginaAtual    := 0;
  iMargemDireita  := 132;
  iMargem         := 1;

  cTotalAgencia   := 0.00;
  cTotalBanco     := 0.00;
  cTotalPagina    := 0.00;
  cTotalGeral     := 0.00;

  with mtDetalhe do
  begin

    First;

    sAgencia := '';
    sBanco   := '';

    while not EOF do
    begin

      if (iPaginaAtual = 0) or (iLinhaAtual > iLinhaPorPagina) then
      begin
        Cabecalho();
        CabecalhoBanco();

      end else if (sBanco = '') or (sBanco <> FieldByName('IDBANCO').AsString) then
      begin

        cTotalBanco   := 0.0;
        cTotalAgencia := 0.0;

        if (iLinhaAtual > iLinhaPorPagina) then
          Cabecalho();

        CabecalhoBanco();

      end else if (sAgencia = '') or (sAgencia <> FieldByName('IDAGENCIA').AsString) then
      begin

        cTotalAgencia := 0.0;

        if (iLinhaAtual > iLinhaPorPagina) then
          Cabecalho();

        CabecalhoBanco();

      end;

      cLiquido      := FieldByName('LIQUIDO').AsCurrency;

      cTotalAgencia := cTotalAgencia + cLiquido;
      cTotalBanco   := cTotalBanco   + cLiquido;

      cTotalPagina  := cTotalPagina + cLiquido;
      cTotalGeral   := cTotalGeral  + cLiquido;

      Texto :=
         FormataConta( FieldByName('CONTA').AsString ) + kEspaco(2) +
         Formata( '####', #32, FieldByName('CODIGO').AsInteger) + kEspaco(2) +
         PadRightChar( FieldByName('NOME').AsString, 50 ) + kEspaco(2)+
         FormataCpf( FieldByName('CPF').AsString) + kEspaco(2) +
         Formata( FMT_VALOR, #32, cLiquido ) ;

      Next;

      if (not Eof) and (sAgencia <> FieldByName('IDAGENCIA').AsString) and
                       (sBanco = FieldByName('IDBANCO').AsString) then
      begin
        Texto := Texto + kEspaco(2) + Formata( FMT_VALOR, #32, cTotalAgencia ) ;

        Escreve( iLinhaAtual, iMargem, Texto);

      end else if Eof or (sBanco <> FieldByName('IDBANCO').AsString) then
      begin
        Texto := Texto + kEspaco(2) +
                 Formata( FMT_VALOR, #32, cTotalAgencia ) +  kEspaco(2) +
                 Formata( FMT_VALOR, #32, cTotalBanco ) ;

        Escreve( iLinhaAtual, iMargem, Texto);

      end else
        Escreve( iLinhaAtual, iMargem, Texto);

      if Eof or (iLinhaAtual > iLinhaPorPagina) then
      begin
        Texto := kEspaco(70) + 'Total da Pagina -> ' +
                 Formata( FMT_VALOR, #32, cTotalPagina) +
                 '  Total Acum. ->'+
                  Formata( FMT_VALOR, #32, cTotalGeral);
        Escreve( iLinhaAtual, iMargem, Replicate( '-', iMargemDireita));
        Escreve( iLinhaAtual, iMargem, Texto);

      end;

    end; // while

  end;

end;

constructor TFPrint.Create(AOwner: TComponent);
begin

  inherited;

  FPrinter := TAKPrinter.Create(Self);
  FPrinter.FastFont := FPrinter.FastFont + [Comprimido];
  FPrinter.Zoom := zReal;

  FReport  := TAKCustomReport.Create(Self);
  FReport.Printer := FPrinter;

  mtEmpresa := TClientDataSet.Create(Self);
  mtEmpresaDados := TClientDataSet.Create(Self);
  mtFolha   := TClientDataSet.Create(Self);
  mtDetalhe := TClientDataSet.Create(Self);
  mtBanco   := TClientDataSet.Create(Self);

end;

destructor TFPrint.Destroy;
begin
  mtBanco.Free;
  mtFolha.Free;
  mtEmpresa.Free;
  mtEmpresaDados.Free;
  mtDetalhe.Free;
  FReport.Free;
  FPrinter.Free;
  inherited;
end;

end.
