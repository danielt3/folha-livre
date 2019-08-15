{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (C) 2002-2005 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@file-name: r_total_lotacao.pas
@license: GNU GPL
@autor-name: Allan Kardek Lima
@email: allan_kardek@yahoo.com.br;folha_livre@yahoo.com.br
@date: 29-07-2003
}

unit r_total_lotacao;

{$I flivre.inc}

interface

uses
  {$IFDEF VCL}
  Windows, Graphics, Forms, Controls, ExtCtrls, StdCtrls, DBCtrls, Mask, AKPrint,
  {$ENDIF}
  {$IFDEF CLX}
  QForms, QGraphics, QControls, QExtCtrls, QStdCtrls, QDBCtrls, QMask, QAKPrint,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, DBClient, Variants;

type
  TFrmTotalLotacao = class(TForm)
  protected
    DataSet1: TClientDataSet;
    DataSource1: TDataSource;
    pnlControle: TPanel;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
    pnlConfig: TPanel;
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacao: TDBEdit;
    dbLotacao2: TDBEdit;
    gpCargo: TGroupBox;
    dbCargoX: TCheckBox;
    dbCargo: TDBEdit;
    dbCargo2: TDBEdit;
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipo: TDBEdit;
    dbTipo2: TDBEdit;
    gpRecurso: TGroupBox;
    dbRecursoX: TCheckBox;
    dbRecurso: TDBEdit;
    dbRecurso2: TDBEdit;
    dbModo: TCheckBox;
    dbQuebra: TCheckBox;
    dbResumo: TCheckBox;
    {$IFDEF VCL}
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    {$ENDIF}
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
    FReport: TTbCustomReport;
    FPrinter: TTbPrinter;
    mtDetalhe, mtEmpresa, mtFolha: TClientDataSet;
    pvEmpresa, pvFolha, pvLotacao, pvCargo: Integer;
    pvTipo, pvRecurso: String;
    pvModoComprimido,
    pvSeparaLotacao, pvSeparaResumo: Boolean;

    function Processa():Boolean;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure ImprimeTotalLotacao( Empresa, Folha, Lotacao, Cargo: Integer;
  Recurso, Tipo: String;
  ModoComprimido, SeparaLotacao, SeparaResumo, Imprimir: Boolean);

procedure CriaTotalLotacao( Empresa, Folha:Integer);

implementation

uses fdb, ftext, fsuporte, ffind, flotacao, fcargo, ftipo, frecurso;

const
  C_AUTO_EDIT = True;

procedure ImprimeTotalLotacao( Empresa, Folha, Lotacao, Cargo: Integer;
  Recurso, Tipo: String;
  ModoComprimido, SeparaLotacao, SeparaResumo, Imprimir: Boolean);
begin

  with TFPrint.Create(NIL) do
  try

    if SeparaLotacao then
      SeparaResumo := True;

    pvEmpresa := Empresa;
    pvFolha   := Folha;
    pvRecurso := Recurso;
    pvCargo   := Cargo;
    pvLotacao := Lotacao;
    pvTipo    := Tipo;
    pvModoComprimido := ModoComprimido;
    pvSeparaLotacao  := SeparaLotacao;
    pvSeparaResumo   := SeparaResumo;

    Processa();

    FPrinter.Preview := not Imprimir;
    FReport.OnGenerate := CustomReportGenerate;
    FReport.Execute;

  finally
    Free;
  end;

end;  // ImprimeTotalLotacao

procedure CriaTotalLotacao( Empresa, Folha:Integer);
begin

  if (Folha <= 0) then
    Exit;

  with TFrmTotalLotacao.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    pvFolha   := Folha;
    ShowModal;
  finally
    Free;
  end;

end;

{$IFDEF VCL}
procedure TFrmTotalLotacao.FormKeyDown(Sender: TObject; var Key: Word;
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
    PesquisaTipo( '*', DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_RETURN) then
    PesquisaRecurso( dbRecurso.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_F12) then
    PesquisaRecurso( '*', DataSet1, Key, '', C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;
{$ENDIF}

procedure TFrmTotalLotacao.dbLotacaoXClick(Sender: TObject);
var
  wControl: TControl;
  wCheck: TCheckBox;
begin

  wCheck   := TCheckBox(Sender);
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

procedure TFrmTotalLotacao.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTotalLotacao.btnImprimirClick(Sender: TObject);
var
  iLotacao, iCargo: Integer;
  sRecurso, sTipo: String;
begin

  with DataSet1 do
  begin

    if State in [dsInsert,dsEdit] then
      Post;

    iLotacao := -1;
    sTipo := '';
    sRecurso := '';
    iCargo := -1;

    if not dbLotacaoX.Checked then
      iLotacao := FieldByName('IDLOTACAO').AsInteger;

    if not dbTipoX.Checked then
      sTipo := FieldByName('IDTIPO').AsString;

    if not dbRecursoX.Checked then
      sRecurso := FieldByName('IDRECURSO').AsString;

    if not dbCargoX.Checked then
      iCargo := FieldByName('IDCARGO').AsInteger;

  end;  // with DataSet1

  ImprimeTotalLotacao( pvEmpresa, pvFolha, iLotacao, iCargo, sRecurso, sTipo,
                       dbModo.Checked, dbQuebra.Checked, dbResumo.Checked,
                       (Sender = btnImprimir) );

end;

constructor TFrmTotalLotacao.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption := 'Impressão de Total por Lotações';
  ClientHeight := 400;
  ClientWidth := 450;

  Color  := $00E0E9EF;

  KeyPreview := True;
  Position := poScreenCenter;

  {$IFDEF VCL}
  OnKeyDown := FormKeyDown;
  {$ENDIF}

  CreateDB;   // Criacao dos componentes de acesso a dados
  CreateControls; // Criacao dos componentes de interface

end;

procedure TFrmTotalLotacao.CreateControls;
begin

  pnlConfig := TPanel.Create(Self);
  with pnlConfig do
  begin
    Parent := Self;
    Align := alTop;
    BevelOuter := bvNone;
    ParentColor := True;
  end;

  // Lotacao

  gpLotacao := TGroupBox.Create(Self);
  with gpLotacao do
  begin
    Parent := pnlConfig;
    Left := 8;
    Top := 8;
    Width := 420;
    Height := 70;
    Caption := 'Lotação';
  end;

  dbLotacaoX := TCheckBox.Create(Self);
  with dbLotacaoX do
  begin
    Parent := gpLotacao;
    Left := 8;
    Top := 19;
    Width := 120;
    Height := 17;
    Caption := 'Todas as &Lotações';
    Checked := True;
    State := cbChecked;
    OnClick := dbLotacaoXClick;
  end;

  dbLotacao := TDBEdit.Create(Self);
  with dbLotacao do
  begin
    Parent := gpLotacao;
    Left := 8;
    Top := 39;
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
    Width := 300;
    Height := dbLotacao.Height;
    TabStop := False;
    DataField := 'LOTACAO';
    DataSource := DataSource1;
    ParentColor := True;
    ReadOnly := True;
  end;

  // Cargo de Funcionario ***************************

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

  // Tipo de Funcionarios ***************************

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

  // Recurso para Pagamento do Funcionario

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

  // Opcoes Diversas ***************************

  dbModo := TCheckBox.Create(Self);
  with dbModo do
  begin
    Parent  := pnlConfig;
    Left    := gpRecurso.Left;
    Top     := gpRecurso.Top + gpRecurso.Height + 10;
    Width   := 120;
    Caption := 'Modo Comprimido';
    Checked := True;
    State   := cbChecked;
  end;

  dbQuebra := TCheckBox.Create(Self);
  with dbQuebra do
  begin
    Parent := pnlConfig;
    Left := dbModo.Left + dbModo.Width + 5;
    Top := dbModo.Top;
    Width := 120;
    Caption := 'Separar Lotações';
    Checked := False;
    State := cbChecked;
  end;

  dbResumo := TCheckBox.Create(Self);
  with dbResumo do
  begin
    Parent := pnlConfig;
    Left := dbQuebra.Left + dbQuebra.Width + 5;
    Top := dbQuebra.Top;
    Width := 120;
    Caption := 'Separar Resumo';
    Checked := True;
    State := cbChecked;
  end;

  pnlConfig.Height := dbResumo.Top + dbResumo.Height + 10;

  CreateButtons;

  Self.ClientHeight := pnlConfig.Height + pnlControle.Height + 5;

end;

procedure TFrmTotalLotacao.CreateDB;
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
    CreateDataSet;
    Append;
  end;

  DataSource1 := TDataSource.Create(Self);
  DataSource1.AutoEdit := True;
  DataSource1.DataSet  := DataSet1;

end;  // CreateDB

procedure TFrmTotalLotacao.CreateButtons;
begin

  pnlControle := TPanel.Create(Self);
  with pnlControle do
  begin
    Parent := Self;
    Align := alBottom;
    BevelOuter := bvLowered;
    ParentColor := True;
  end;

  btnImprimir := TButton.Create(Self);
  with btnImprimir do
  begin
    Parent := pnlControle;
    Left := 172;
    Top := 8;
    Width := 75;
    Height := 25;
    Caption := '&Imprimir';
    OnClick := btnImprimirClick;
  end;

  btnVisualizar := TButton.Create(Self);
  with btnVisualizar do
  begin
    Parent  := btnImprimir.Parent;
    Left    := btnImprimir.Left + btnImprimir.Width + 10;
    Top     := btnImprimir.Top;
    Width   := btnImprimir.Width;
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
    Width   := btnVisualizar.Width;
    Height  := btnVisualizar.Height;
    Cancel  := True;
    Caption := 'Cancelar';
    OnClick := btnCancelarClick;
  end;

  pnlControle.Height := btnImprimir.Top + btnImprimir.Height + 10;

end;  // CreateButtons

{ TFPrint }

constructor TFPrint.Create(AOwner: TComponent);
begin

  inherited;

  FPrinter := TTbPrinter.Create(Self);
  FPrinter.FastFont := FPrinter.FastFont + [Comprimido];
  FPrinter.Zoom := zReal;

  FReport  := TTbCustomReport.Create(Self);
  FReport.Printer := FPrinter;

  mtEmpresa := TClientDataSet.Create(Self);
  mtFolha   := TClientDataSet.Create(Self);
  mtDetalhe := TClientDataSet.Create(Self);

  with mtDetalhe do
  begin
    FieldDefs.Add( 'IDLOTACAO', ftInteger);
    FieldDefs.Add( 'LOTACAO', ftString, 50);
    FieldDefs.Add( 'P_CODIGO', ftInteger);
    FieldDefs.Add( 'P_NOME', ftString, 30);
    FieldDefs.Add( 'P_INF', ftCurrency);
    FieldDefs.Add( 'P_VALOR', ftCurrency);
    FieldDefs.Add( 'D_CODIGO', ftInteger);
    FieldDefs.Add( 'D_NOME', ftString, 30);
    FieldDefs.Add( 'D_INF', ftCurrency);
    FieldDefs.Add( 'D_VALOR', ftCurrency);
    CreateDataSet;
  end;

end;

destructor TFPrint.Destroy;
begin
  mtFolha.Free;
  mtEmpresa.Free;
  mtDetalhe.Free;
  FReport.Free;
  FPrinter.Free;
  inherited;
end;

function TFPrint.Processa():Boolean;
var
  iLotacao, iEvento: Integer;
  sLotacao: String;
  sEvento, sTipo: String;
  cInformado, cValor: Currency;
  SQL: TStringList;
  cdLoad: TClientDataSet;
begin

  kSQLSelectFrom( mtEmpresa, 'EMPRESA', pvEmpresa);
  kSQLSelectFrom( mtFolha, 'F_FOLHA', pvEmpresa, 'IDFOLHA = '+IntToStr(pvFolha));

  SQL    := TStringList.Create;
  cdLoad := TClientDataSet.Create(NIL);

  try

    SQL.BeginUpdate;
    SQL.Clear ;
    SQL.Add('SELECT');
    SQL.Add('  L.NOME LOTACAO, L.IDLOTACAO,');
    SQL.Add('  E.NOME EVENTO, E.IDEVENTO,');
    SQL.Add('  E.TIPO_EVENTO, C.SEQUENCIA,');
    SQL.Add('  SUM(C.INFORMADO) INFORMADO, SUM(C.CALCULADO) CALCULADO');
    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL_FUNCIONARIO CF, F_CENTRAL C,');
    SQL.Add('  F_LOTACAO L, F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  CF.IDEMPRESA = '+IntToStr(pvEmpresa) );
    SQL.Add('  AND CF.IDFOLHA = '+IntToStr(pvFolha) );

    if (pvCargo <> -1) then
      SQL.Add(' AND CF.IDCARGO = '+IntToStr(pvCargo) );

    if (pvTipo <> '') then
      SQL.Add(' AND CF.IDTIPO = '+QuotedStr(pvTipo) );

    if (pvRecurso <> '') then
      SQL.Add(' AND CF.IDRECURSO = '+QuotedStr(pvRecurso) );

    if (pvLotacao <> -1) then
      SQL.Add(' AND CF.IDLOTACAO = '+IntToStr(pvLotacao));

    SQL.Add('  AND C.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND C.IDFOLHA = CF.IDFOLHA');
    SQL.Add('  AND C.IDFUNCIONARIO = CF.IDFUNCIONARIO');

    SQL.Add('  AND L.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND L.IDLOTACAO = CF.IDLOTACAO');

    SQL.Add('  AND E.IDEVENTO = C.IDEVENTO');
    SQL.Add('  AND E.TOTAL_LOTACAO_X = 1');

    SQL.Add('GROUP BY');
    SQL.Add('  L.NOME, L.IDLOTACAO, E.NOME, E.IDEVENTO,');
    SQL.Add('  E.TIPO_EVENTO, C.SEQUENCIA');

    SQL.Add('ORDER BY');
    SQL.Add('  L.NOME, E.TIPO_EVENTO DESC, C.SEQUENCIA, E.IDEVENTO');

    SQL.EndUpdate;

    kOpenSQL( cdLoad, SQL.Text);

    with cdLoad do
    begin

      First;

      while not EOF do
      begin

        iLotacao   := FieldByName('IDLOTACAO').AsInteger;
        sLotacao   := FieldByName('LOTACAO').AsString;
        iEvento    := FieldByName('IDEVENTO').AsInteger;
        sEvento    := FieldByName('EVENTO').AsString;
        sTipo      := FieldByName('TIPO_EVENTO').AsString;
        cInformado := FieldByName('INFORMADO').AsCurrency;
        cValor     := FieldByName('CALCULADO').AsCurrency;

        if (sTipo[1] in ['P','B']) then
        begin

          if (sTipo[1] = 'B') then
            sEvento := '(*) '+sEvento;

          if mtDetalhe.Locate( 'IDLOTACAO;P_CODIGO',
                               VarArrayOf( [iLotacao, NULL]), []) then
            mtDetalhe.Edit
          else
            mtDetalhe.Append;

          mtDetalhe.FieldByName('P_CODIGO').AsInteger := iEvento;
          mtDetalhe.FieldByName('P_NOME').AsString    := sEvento;
          mtDetalhe.FieldByName('P_INF').AsCurrency   := cInformado;
          mtDetalhe.FieldByName('P_VALOR').AsCurrency := cValor;

        end else
        begin  // if sRubrica <> 'P'

          if mtDetalhe.Locate( 'IDLOTACAO;D_CODIGO',
                        VarArrayOf( [iLotacao, NULL]), []) then
            mtDetalhe.Edit
          else
            mtDetalhe.Append;

          mtDetalhe.FieldByName('D_CODIGO').AsInteger := iEvento;
          mtDetalhe.FieldByName('D_NOME').AsString    := sEvento;
          mtDetalhe.FieldByName('D_INF').AsCurrency   := cInformado;
          mtDetalhe.FieldByName('D_VALOR').AsCurrency := cValor;

        end;  // if

        mtDetalhe.FieldByName('LOTACAO').AsString    := sLotacao;
        mtDetalhe.FieldByName('IDLOTACAO').AsInteger := iLotacao;
        mtDetalhe.Post;

        Next;

      end; // while not EOF do

    end;

    Result := True;

  finally
    SQL.Free;
    cdLoad.Free;
  end;

end; // function Processa

procedure TFPrint.CustomReportGenerate(Sender: TObject);
const
  FMT_REF   = '#,###,###.##';
  FMT_VALOR = '#,###,##0.00';

var
  sEmpresa: String;
  iMargem, iPaginaAtual, iLinhaAtual, iLinhaPorPagina: Integer;
  sTitulo, sSubTitulo, sCabecalhoColuna, Texto: String;
  iMargemDireita: Integer;
  cVantagem, cDesconto, cTotalVantagem, cTotalDesconto: Currency;
  iLotacao: Integer;
  sNome, sProvento: String;

  function Formata(const Formato, Prefixo: string; Valor: Extended): string;
  begin
    Result := FormatFloat( Formato, Valor);
    Result := StringOfChar( Prefixo[1], Length(Formato)-Length(Result))+Result;
  end;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    with FPrinter do
      Escribir( Coluna, Linha, Texto, FastFont );
  end;

  procedure CabecalhoLotacao();
  begin

    with mtDetalhe do
    begin

      iLotacao  := FieldByName('IDLOTACAO').AsInteger;
      sNome     := FieldByName('LOTACAO').AsString;

      if (iLotacao = 9999) then
      begin
        sNome := 'T O T A L  G E R A L  D A S  L O T A C O E S';
        Escreve( iLinhaAtual, (iMargemDireita-iMargem-Length(sNome)) div 2, sNome);
      end else
        Escreve( iLinhaAtual, iMargem, 'LOTACAO: '+IntToStr(iLotacao)+' - '+sNome);

      Escreve( iLinhaAtual+1, iMargem, Replicate('-', iMargemDireita) );
      iLinhaAtual := iLinhaAtual + 2;

    end;  // with mtDetalhe

  end;

  procedure Cabecalho;
  begin

    FPrinter.NuevaPagina;
    iPaginaAtual := iPaginaAtual + 1;

    Escreve( 2, iMargem,
             kSpaceString( [ 'FolhaLivre - Folha de Pagamento Livre',
                             sEmpresa, FormatDateTime('dd/mm/yyyy - hh:nn',Now)], iMargemDireita));

    Escreve( 3, iMargem, kSpaceString( [sTitulo, 'Pag. '+kStrZero( iPaginaAtual, 3)], iMargemDireita));

    Escreve( 4, iMargem, sSubTitulo);

    Escreve( 5, iMargem, Replicate('-', iMargemDireita)) ;
    Escreve( 6, iMargem, sCabecalhoColuna);
    Escreve( 7, iMargem, Replicate('-', iMargemDireita)) ;

    iLinhaAtual := 8;

  end;

begin

  iLinhaPorPagina := 60;
  iPaginaAtual    := 0;
  iMargemDireita  := 132;
  iMargem         := 1;

  cTotalDesconto := 0;
  cTotalVantagem := 0;
  iLotacao       := 0;

  sEmpresa   := mtEmpresa.FieldByName('NOME').AsString;
  sTitulo    := 'Endereco: '+mtEmpresa.FieldByName('ENDERECO').AsString+kEspaco(10)+
                'CNPJ/CEI: '+mtEmpresa.FieldByName('CPF_CGC').AsString;
  sSubTitulo := 'Periodo: '+FormatDateTime( 'dd/mm/yyyy', mtFolha.FieldByName('PERIODO_INICIO').AsDateTime)+' a '+
                         FormatDateTime( 'dd/mm/yyyy', mtFolha.FieldByName('PERIODO_FIM').AsDateTime) +
                '  -  Folha No.: '+mtFolha.FieldByName('IDFOLHA').AsString + ' - '+
                mtFolha.FieldByName('DESCRICAO').AsString ;

  sCabecalhoColuna := 'Cod'+ kEspaco(2) +
                      PadRightChar( 'Vantagem', 30, #32) + kEspaco(2) +
                      PadLeftChar( 'Inf.', Length(FMT_REF), #32) + kEspaco(2) +
                      PadLeftChar( 'Valor', Length(FMT_VALOR), #32) +
                      kEspaco(4) +
                      'Cod'+ kEspaco(2) +
                      PadRightChar( 'Desconto', 30, #32) + kEspaco(2) +
                      PadLeftChar( 'Inf.', Length(FMT_REF), #32) + kEspaco(2) +
                      PadLeftChar( 'Valor', Length(FMT_VALOR), #32) ;


  with mtDetalhe do
  begin

    First;

    while not EOF do
    begin

      if (iPaginaAtual = 0) or (iLinhaAtual > iLinhaPorPagina) or
         ( pvSeparaLotacao and (iLotacao <> FieldByName('IDLOTACAO').AsInteger) ) then
      begin
        Cabecalho();
        CabecalhoLotacao();

      end else if (iLotacao  = 0) or (iLotacao <> FieldByName('IDLOTACAO').AsInteger) then
      begin

        if (iLinhaAtual+7 > iLinhaPorPagina) or
           ( (FieldByName('IDLOTACAO').AsInteger = 9999) and pvSeparaResumo )then
          Cabecalho();

         CabecalhoLotacao();

      end;

      cVantagem := FieldByName('P_VALOR').AsCurrency;
      cDesconto := FieldByName('D_VALOR').AsCurrency;

      sProvento      := FieldByName('P_NOME').AsString;
      cTotalDesconto := cTotalDesconto + cDesconto;

      if (Copy( sProvento, 1, 4) <> '(*) ') then
        cTotalVantagem := cTotalVantagem + cVantagem;

      Texto :=
         PadRightChar( FieldByName('P_CODIGO').AsString, 3, #32) + kEspaco(2) +
         PadRightChar( sProvento, 30, #32 ) + kEspaco(2)+
         Formata( FMT_REF, #32, FieldByName('P_INF').AsCurrency)+ kEspaco(2)+
         Formata( kIfThenStr( cVantagem = 0, FMT_REF, FMT_VALOR), #32, cVantagem) +
         kEspaco(4) +
         PadRightChar( FieldByName('D_CODIGO').AsString, 3, #32)+ kEspaco(2)+
         PadRightChar( FieldByName('D_NOME').AsString, 30, #32 ) + kEspaco(2)+
         Formata( FMT_REF,   #32, FieldByName('D_INF').AsCurrency)+ kEspaco(2)+
         Formata( kIfThenStr( cDesconto = 0, FMT_REF, FMT_VALOR), #32, cDesconto) ;

      Escreve( iLinhaAtual, iMargem, Texto);

      Inc(iLinhaAtual);

      Next;

      if Eof or (iLotacao <> FieldByName('IDLOTACAO').AsInteger) then
      begin

        Texto :=
           kEspaco(3) + kEspaco(2)+
           PadRightChar( 'Total de Vantagens', 30, #32) + kEspaco(2)+
           kEspaco( Length(FMT_REF))+ kEspaco(2)+
           Formata( kIfThenStr( cTotalVantagem = 0, FMT_REF, FMT_VALOR), #32, cTotalVantagem) +
           kEspaco(4) +
           kEspaco(3) + kEspaco(2)+
           PadRightChar( 'Total de Descontos', 30, #32) + kEspaco(2)+
           kEspaco( Length(FMT_REF))+ kEspaco(2)+
           Formata( kIfThenStr( cTotalDesconto = 0, FMT_REF, FMT_VALOR), #32, cTotalDesconto) ;

        Escreve( iLinhaAtual, iMargem, Texto);

        Texto := kEspaco(39) +
                 '           ' + Formata( FMT_REF, #32, 0 ) + kEspaco(2) +
                 '      ' +Formata( FMT_REF, #32, 0) + kEspaco(2) +
                 '           ' + Formata( FMT_REF, #32, 0) + kEspaco(2) +
                 'Liquido: ' +Formata( FMT_VALOR, #32, cTotalVantagem-cTotalDesconto) ;

        Escreve( iLinhaAtual+1, iMargem, Texto);
        Escreve( iLinhaAtual+2, iMargem, Replicate('-', iMargemDireita)) ;

        iLinhaAtual := iLinhaAtual + 3;

        cTotalDesconto := 0.0;
        cTotalVantagem := 0.0;

      end;

    end; // while

  end;

end;

end.
