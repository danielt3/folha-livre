{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Dependentes para Funcionarios

Copyright (c) 2004 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@file-date: 09/02/2004
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fdependente;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls,
  QDBCtrls, QMask, QGrids, QDBGrids, QComCtrls, QButtons, QMenus,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, Menus,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$IFDEF RX_LIB}RXDBCtrl,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DBClient, DB, Types;

type
  TFrmDependente = class(TFrmDialogo)
  protected
    { Protected declarations }
    dsFuncionario: TDataSource;
    cdFuncionario: TClientDataSet;
    dbFuncionario: {$IFDEF AK_LABEL}TAKDBEdit{$ELSE}TDBEdit{$ENDIF};
    lbNome: TLabel;
    dbNome: TDBEdit;
    procedure FuncionarioButtonClick(Sender: TObject);
    procedure GetData; override;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Pesquisar; override;
  private
    { Private declarations }
    FTipos: String;
    function GetFuncionario: Integer;
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
  end;

procedure CriaDependente;

implementation

uses ftext, fdb, fsuporte, futil, fbase;

const
  C_AUTO_EDIT = True;
  C_UNIT = 'fdependente.pas';

procedure CriaDependente;
begin

  with TFrmDependente.Create(Application) do
  try
    pvTabela := 'F_DEPENDENTE';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;

{ TFrmDependente }

constructor TFrmDependente.Create(AOwner: TComponent);
var
  Panel1: TPanel;
  Label1: TLabel;
  Control1: TWinControl;
  iTop: Integer;
  ClientDataSet1: TClientDataSet;
  DataSource1: TDataSource;
begin

  inherited;

  Caption          := 'Dependentes';
  RxTitulo.Caption := ' + Cadastro de Dependentes';

  OnKeyDown := FormKeyDown;

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.OnNewRecord  := mtRegistroNewRecord;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;
  mtRegistro.BeforePost   := mtRegistroBeforePost;
  
  // Criação de componentes locais

  cdFuncionario := TClientDataSet.Create(Self);

  with cdFuncionario do
  begin
    FieldDefs.Add('IDFUNCIONARIO', ftString, 10);
    FieldDefs.Add('FUNCIONARIO', ftString, 50);
    CreateDataSet;
  end;

  dsFuncionario := TDataSource.Create(Self);
  dsFuncionario.DataSet  := cdFuncionario;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent   := PnlClaro;
    Align    := alTop;
    Height   := 55;
    Color    := PnlControle.Color;
    TabOrder := 0
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Código';
    FocusControl := dbFuncionario;
    Left    := 8;
    Top     := 8;
  end;

  dbFuncionario := {$IFDEF AK_LABEL}TAKDBEdit.Create(Self)
                             {$ELSE}TDBEdit.Create(Self){$ENDIF};

  with dbFuncionario do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFuncionario;
    DataField  := 'IDFUNCIONARIO';
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 60;
    OnButtonClick := FuncionarioButtonClick;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Nome do Funcionário';
    {$IFDEF AK_LABEL}
    Left    := dbFuncionario.EditButton.Left +
               dbFuncionario.EditButton.Width + 5;
    {$ELSE}
    Left    := dbFuncionario.Left + dbFuncionario.Width + 5;
    {$ENDIF}
    Top     := 8;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    DataSource  := dsFuncionario;
    DataField   := 'FUNCIONARIO';
    Left        := Label1.Left;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 400;
    Parent      := Panel1;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
    Label1.FocusControl := Control1;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Nome do Dependente';
    Width := 280;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'SEXO';
    Title.Caption := 'Sexo';
    Width := 40;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'NASCIMENTO';
    Title.Caption := 'Nascimento';
    Width := 80;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'TIPO';
    Title.Caption := 'Tipo(s)';
    Width := 90;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'INVALIDO_X';
    Title.Caption := 'Inv.';
    Width := 25;
  end;

  lbNome := TLabel.Create(Self);

  with lbNome do
  begin
    Parent  := Panel;
    Caption := 'Nome do Dependente';
    Left    := 8;
    Top     := 8;
  end;

  dbNome := TDBEdit.Create(Self);

  with dbNome do
  begin
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'NOME';
    Left        := lbNome.Left;
    Parent      := Panel;
    Top         := lbNome.Top+lbNome.Height+3;
    Width       := 400;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Nascimento';
    Left    := dbNome.Left;
    Top     := dbNome.Top + dbNome.Height + 3;
    iTop    := Top;
  end;

  Control1 := {$IFDEF RX_LIB}TDBDateEdit.Create(Self)
                      {$ELSE}TDBEdit.Create(Self){$ENDIF};

  with {$IFDEF RX_LIB}TDBDateEdit(Control1)
               {$ELSE}TDBEdit(Control1){$ENDIF} do
  begin
    Parent      := Panel;
    DataSource  := dtsRegistro;
    DataField   := 'NASCIMENTO';
    Left        := Label1.Left;
    Height      := dbNome.Height;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 100;
    Label1.FocusControl := Control1;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Sexo';
    Left    := Control1.Left + Control1.Width + 5;
    Top     := iTop;
  end;

  // ** SEXO **
  ClientDataSet1 := TClientDataSet.Create(Self);

  with ClientDataSet1 do
  begin
    FieldDefs.Add('SEXO', ftString, 1);
    FieldDefs.Add('NOME', ftString, 15);
    CreateDataSet;
    AppendRecord( ['M', 'Masculino']);
    AppendRecord( ['F', 'Feminino']);
  end;

  DataSource1 := TDataSource.Create(Self);
  DataSource1.DataSet := ClientDataSet1;

  Control1 := TDBLookupComboBox.Create(Self);

  with TDBLookupComboBox(Control1) do
  begin
    Parent       := Panel;
    DataSource   := dtsRegistro;
    DataField    := 'SEXO';
    Left         := Label1.Left;
    Top          := Label1.Top+Label1.Height+3;
    Width        := 100;
    Label1.FocusControl := Control1;
    ListSource   := DataSource1;
    KeyField    := 'SEXO';
    ListField   := 'NOME';
    OnEnter := PesquisaTipo.OnEnter;
    OnExit  := PesquisaTipo.OnExit;
  end;

  // Relação de Tipos

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent   := Panel;
    Caption  := 'Relação de Tipos';
    Hint     := 'Separe os tipos com hífen (-). Ex. "S-R-K"';
    Left     := Control1.Left+Control1.Width+5;
    Top      := iTop;
    ShowHint := True;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel;
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'TIPO';
    Hint        := Label1.Hint;
    Left        := Label1.Left;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 100;
    ShowHint    := Label1.ShowHint;
    Label1.FocusControl := Control1;
  end;

  Control1 := TDBCheckBox.Create(Self);

  with TDBCheckBox(Control1) do
  begin
    Parent         := Panel;
    Caption        := '&Inválido';
    DataSource     := dtsRegistro;
    DataField      := 'INVALIDO_X';
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Left           := Label1.Left + Label1.FocusControl.Width+5;
    Top            := Label1.Top+Label1.Height+3;
    Width          := 100;
  end;

  // Ajustar a altura do Panel de edicao
  Panel.Height := Control1.Top + Control1.Height + 10;

end;

procedure TFrmDependente.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').ProviderFlags     := [pfInKey];
    FieldByName('IDFUNCIONARIO').ProviderFlags := [pfInKey];
    FieldByName('NOME').ProviderFlags          := [pfInKey];
  end;
end;

procedure TFrmDependente.mtRegistroNewRecord(DataSet: TDataSet);
var
  cdTipo: TClientDataSet;
begin

  if (FTipos = '') then
  begin
    FTipos := '';
    cdTipo := TClientDataSet.Create(NIL);
    try
      if kSQLSelectFrom( cdTipo, 'F_DEPENDENTE_TIPO') then
      begin
        cdTipo.First;
        while not cdTipo.Eof do
        begin
          if (FTipos <> '') then FTipos := FTipos + '-';
          FTipos := FTipos + cdTipo.FieldByName('IDTIPO').AsString;
          cdTipo.Next;
        end;
      end;
    finally
      cdTipo.Free;
    end;
  end;

  inherited;

  with DataSet do
  begin
    FieldByName('IDFUNCIONARIO').AsInteger := GetFuncionario();
    FieldByName('NASCIMENTO').AsDateTime   := Date();
    FieldByName('SEXO').AsString           := 'M';  // Masculino
    FieldByName('TIPO').AsString           := FTipos;
    FieldByName('INVALIDO_X').AsInteger    := 0;
  end;

end;

procedure TFrmDependente.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (ActiveControl = dbFuncionario) then
  begin

    PesquisaFuncionario( TDBEdit(ActiveControl).Text,
                         pvEmpresa, cdFuncionario, Key, C_AUTO_EDIT);
    GetData();

  end else if (Key = VK_F12) and (ActiveControl <> dbFuncionario) then
  begin
    PesquisaFuncionario( '', pvEmpresa, cdFuncionario, Key, C_AUTO_EDIT);
    GetData();
  end;

  inherited;

end;

procedure TFrmDependente.FuncionarioButtonClick(Sender: TObject);
var
  Key: Word;
begin
  PesquisaFuncionario( '', pvEmpresa, cdFuncionario, Key, C_AUTO_EDIT);
  GetData();
end;

procedure TFrmDependente.GetData;
begin

  try

    if not kOpenSQL( pvDataSet, 'F_DEPENDENTE',
                     'IDEMPRESA = :EMPRESA AND IDFUNCIONARIO = :FUNCIONARIO',
                     [pvEmpresa, GetFuncionario()]) then
      raise Exception.Create(kGetErrorLastSQL);

    pvDataSet.Last;
    pvDataSet.First;

  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'GetData()');
  end;

end;

function TFrmDependente.GetFuncionario: Integer;
begin
  try
    Result := cdFuncionario.FieldByName('IDFUNCIONARIO').AsInteger;
  except
    Result := 0;
  end;
end;

procedure TFrmDependente.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome:= DataSet.FieldByName('NOME').AsString;
  if not kConfirme('Excluir o Dependente "'+sNome+'" ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmDependente.Pesquisar;
begin
  GetData();
end;

procedure TFrmDependente.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  lbNome.Enabled := False;
  dbNome.Enabled := False;
  inherited;
end;

procedure TFrmDependente.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  lbNome.Enabled := True;
  dbNome.Enabled := True;
  inherited;
end;

procedure TFrmDependente.mtRegistroBeforePost(DataSet: TDataSet);
var
  sTipo: String;
begin
  with DataSet do
  begin
    if FieldByName('NOME').AsString = '' then
      raise Exception.Create('Faltou informar um nome para o dependente');
    sTipo := FieldByName('TIPO').AsString;
    sTipo := kRetiraChar(sTipo, 'DMFI');
    sTipo := kSubstitui(sTipo, '--', '-');
    if Copy( sTipo, 1, 1) = '-' then
      sTipo := Copy( sTipo, 2, Length(sTipo));
    if Copy( sTipo, Length(sTipo), 1) = '-' then
      sTipo := Copy( sTipo, 1, Length(sTipo)-1);
    FieldByName('TIPO').AsString := sTipo;
  end; // DataSet
  inherited;
end;

end.
