{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Cargos

Copyright (C) 2002 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

unit fcargo;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, fdialogo, DBClient;

procedure CriaCargo;

function FindCargo( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;

procedure PesquisaCargo( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);

implementation

uses fdb, ftext, fsuporte, fbase, ffind, Math;

type
  TFrmCargo = class(TFrmDialogo)
  protected
    lbCargo: TLabel;
    lbNome: TLabel;
    lbCBO: TLabel;
    dbCargo: TDBEdit;
    dbNome: TDBEdit;
    dbCBO: TDBEdit;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

function FindCargo( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  lSQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Cargo',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  if (Length(Pesquisa) = 0) then
    Exit;

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet := TClientDataSet.Create(NIL);
  lSQL    := TStringList.Create;

  try

    lSQL.BeginUpdate;
    lSQL.Add('SELECT IDCARGO AS ID, NOME, CBO');
    lSQL.Add('FROM F_CARGO');
    lSQL.Add('WHERE IDEMPRESA = :EMPRESA');
    if kIsNumerico(Pesquisa) then
      lSQL.Add('AND IDCARGO = '+Pesquisa)
    else
      lSQL.Add('AND NOME LIKE '+QuotedStr(Pesquisa+'%'));
    lSQL.EndUpdate;

    if not kOpenSQL( DataSet, lSQL.Text, [Empresa]) then
      Exit;

     with DataSet do
     begin
       if (RecordCount = 1) or
          kFindDataSet( DataSet, 'Cargo',
                        Fields[1].FieldName, vCodigo, [foNoPanel],
                        Fields[0].FieldName) then
       begin
         Codigo := Fields[0].AsInteger;
         Nome   := Fields[1].AsString;
         Result := True;
       end;
     end;  // with DataSet

  finally
    DataSet.Free;
    lSQL.Free;
  end;

end;  // function FindCargo

procedure PesquisaCargo( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);
var
  Codigo: Integer;
  Nome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDCARGO';

  if FindCargo( Pesquisa, Empresa, Codigo, Nome) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsInteger := Codigo;
        if Assigned(DataSet.FindField('CARGO')) then
          DataSet.FieldByName('CARGO').AsString := Nome;
      end;

    end;

  end else
  begin
    kErro('Cargo não encontrado !!!');
    Key := 0;
  end;

end;  // procedure PesquisaCargo

procedure CriaCargo;
begin

  with TFrmCargo.Create(Application) do
    try
      pvTabela := 'F_CARGO';
      Iniciar();
      ShowModal;
    finally
      Free;
    end;

end;  // procedure

constructor TFrmCargo.Create(AOwner: TComponent);
var
  Column: TColumn;
  Control1: TControl;
  Label1: TLabel;
  iTop, iLeft: Integer;
begin

  inherited Create(AOwner);

  Self.Caption := 'Cadastro de Cargos';
  RxTitulo.Caption := ' + Listagem de Cargos';

  lbCargo := TLabel.Create(Self);
  with lbCargo do
  begin
    Parent := Panel;
    Left := 8;
    Top := 8;
    Caption := 'Código';
    FocusControl := dbCargo;
  end;

  dbCargo := TDBEdit.Create(Self);
  with dbCargo do
  begin
    Parent := Panel;
    Left   := lbCargo.Left;
    Top    := lbCargo.Top + 15;
    Width  := 60;
    Height := 19;
    DataField := 'IDCARGO';
    DataSource := dtsRegistro;
  end;

  lbNome := TLabel.Create(Self);
  with lbNome do
  begin
    Parent := Panel;
    Left := dbCargo.Left + dbCargo.Width + 5;
    Top  := lbCargo.Top;
    Caption := 'Nome';
    FocusControl := dbNome;
  end;

  dbNome := TDBEdit.Create(Self);
  with dbNome do
  begin
    Parent := Panel;
    Left := lbNome.Left;
    Top  := dbCargo.Top;
    if kExistField('F_CARGO', 'AGENDA_X') then
      Width := 250
    else
      Width := 320;
    Height := dbCargo.Height;
    CharCase := ecUpperCase;
    DataField := 'NOME';
    DataSource := dtsRegistro;
  end;

  lbCBO := TLabel.Create(Self);
  with lbCBO do
  begin
    Parent := Panel;
    Left := dbNome.Left + dbNome.Width + 5;
    Top := lbNome.Top;
    Caption := 'C.B.O.';
    FocusControl := dbCBO;
  end;

  dbCBO := TDBEdit.Create(Self);
  with dbCBO do
  begin
    Parent := Panel;
    Left   := lbCBO.Left;
    Top    := dbNome.Top;
    Width  := 70;
    Height := dbNome.Height;
    DataField := 'CBO';
    DataSource := dtsRegistro;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent := Panel;
    Left := dbCBO.Left + dbCBO.Width + 5;
    Top := lbCBO.Top;
    Caption := 'Salário Padrão';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent := Panel;
    Left := Label1.Left;
    Top := dbCBO.Top;
    Width := 80;
    Height := dbCBO.Height;
    DataField := 'SALARIO';
    DataSource := dtsRegistro;
    iTop := Top;
    iLeft := Left + Width + 5;
  end;

  if kExistField( 'F_CARGO', 'AGENDA_X') then
  begin

    Control1 := TDBCheckBox.Create(Self);

    with TDBCheckBox(Control1) do
    begin
      Parent := Panel;
      Caption := 'Possui Agenda';
      Left := iLeft;
      Top := iTop;
      Width := 100;
      DataField := 'AGENDA_X';
      DataSource := dtsRegistro;
      ValueChecked := '1';
      ValueUnchecked := '0';
    end;

  end;  // AGENDA_X

  Column := dbgRegistro.Columns.Add;

  with Column do
  begin
    FieldName := 'IDCARGO';
    Title.Caption := 'Código';
    Width := 55;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Nome do Cargo';
    Width := 360;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'CBO';
    Width := 65;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'SALARIO';
    Title.Caption := 'Salário';
    Width := 70;
  end;

  ClientWidth := kMaxWidthColumn( dbgRegistro.Columns, Rate);

  with mtRegistro do
  begin

    FieldDefs.BeginUpdate;
    FieldDefs.Add( 'IDEMPRESA', ftInteger);
    FieldDefs.Add( 'IDCARGO', ftInteger);
    FieldDefs.Add( 'NOME', ftString, 50);
    FieldDefs.Add( 'CBO', ftString, 7);
    FieldDefs.Add( 'SALARIO', ftCurrency);
    if kExistField('F_CARGO', 'AGENDA_X') then
      FieldDefs.Add('AGENDA_X', ftSmallint);

    FieldDefs.EndUpdate;

    IndexFieldNames := 'IDCARGO';

    AfterCancel  := mtRegistroAfterCancel;
    AfterOpen    := mtRegistroAfterOpen;
    AfterPost    := mtRegistroAfterCancel;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit   := mtRegistroBeforeEdit;
    BeforeInsert := mtRegistroBeforeInsert;
    BeforePost   := mtRegistroBeforePost;

  end;  // with mtRegistro

end; // create

procedure TFrmCargo.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDCARGO').AsInteger = 0) and (State = dsInsert) then
      FieldByName('IDCARGO').AsInteger := kMaxCodigo( pvTabela, 'IDCARGO', pvEmpresa);
  inherited;
end;

procedure TFrmCargo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCargo.Enabled := True;
  dbCargo.Enabled := True;
end;

procedure TFrmCargo.mtRegistroBeforeDelete(DataSet: TDataSet);
var sNome: String;
begin
  sNome := DataSet.FieldByName('NOME').AsString;
  if not kConfirme( 'Excluir o cargo "'+sNome+'" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmCargo.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbCargo.SetFocus
end;

procedure TFrmCargo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbCargo.Enabled := False;
  dbCargo.Enabled := False;
end;

procedure TFrmCargo.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('IDEMPRESA').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
    FieldByName('IDCARGO').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
    if Assigned(FindField('SALARIO')) then
      TCurrencyField(FieldByName('SALARIO')).DisplayFormat := ',0.00';
    if Assigned(FindField('CBO')) then
      TStringField(FieldByName('CBO')).EditMask := '99999\-99;0;';
  end;
end;

end.
