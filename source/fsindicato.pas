{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Sindicatos

Copyright (c) 2002-2007 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Histórico

- 06/10/2007 - Incluído o validador de CNPJ;

}

unit fsindicato;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids,
  QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$ENDIF}
  Variants, fcadastro, DB, DBClient;

type
  TFrmSindicato = class(TFrmCadastro)
    pnlDados: TPanel;
    lbCodigo: TLabel;
    lbNome: TLabel;
    dbCodigo: TDBEdit;
    dbNome: TDBEdit;
    Bevel2: TBevel;
    mtListagemIDSINDICATO: TIntegerField;
    mtListagemNOME: TStringField;
    mtListagemCNPJ: TStringField;
    mtRegistroIDSINDICATO: TIntegerField;
    mtRegistroNOME: TStringField;
    mtRegistroCNPJ: TStringField;
    mtRegistroENDERECO: TStringField;
    mtRegistroCOMPLEMENTO: TStringField;
    mtRegistroBAIRRO: TStringField;
    mtRegistroCIDADE: TStringField;
    mtRegistroIDPAIS: TStringField;
    mtRegistroIDUF: TStringField;
    mtRegistroCEP: TStringField;
    mtRegistroTELEFONE: TStringField;
    lblCPF: TLabel;
    dbCNPJ: TDBEdit;
    mtListagemTELEFONE: TStringField;
    mtRegistroOBSERVACAO: TMemoField;
    pnlEndereco1: TPanel;
    LblEndereco1: TLabel;
    lblComplemento1: TLabel;
    lbTelefone: TLabel;
    dbEndereco: TDBEdit;
    dbComplemento: TDBEdit;
    dbBairro: TDBEdit;
    dbCidade: TDBEdit;
    dbPais: TDBLookupComboBox;
    dbUF: TDBLookupComboBox;
    dbCEP: TDBEdit;
    dbTelefone: TDBEdit;
    dbObservacao: TDBMemo;
    Label1: TLabel;
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure dbCNPJExit(Sender: TObject);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroCNPJGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    function VerificaCNPJ(Sindicato: Integer; CNPJ: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

function FindSindicato( Pesquisa: String;
  var Codigo: Integer; var Nome: String):Boolean; overload;

function FindSindicato( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaSindicato();

implementation

uses fdb, ftext, fbase, fsuporte, ffind;

const
  C_UNIT = 'fsindicato.pas';

{$R *.dfm}

function FindSindicato( Pesquisa: String;
  var Codigo: Integer; var Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  sWhere: String;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Sindicato',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  if (Length(Pesquisa) = 0) then
    Exit;

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  if kNumerico(Pesquisa) then
    sWhere := 'IDSINDICATO = '+Pesquisa
  else
    sWhere := 'NOME LIKE '+QuotedStr(Pesquisa+'%');

  sWhere := 'SELECT IDSINDICATO, NOME FROM F_SINDICATO WHERE '+sWhere;

  DataSet := TClientDataSet.Create(NIL);

  try try

    if not kOpenSQL( DataSet, sWhere) then
      raise Exception.Create(kGetErrorLastSQL);

    if (DataSet.RecordCount = 1) or
       kFindDataSet( DataSet, 'Sindicatos', 'NOME', vCodigo, [foNoPanel, foNoTitle]) then
    begin
      Codigo := DataSet.FieldByName('IDSINDICATO').AsInteger;
      Nome   := DataSet.FieldByName('NOME').AsString;
      Result := True;
    end;

  except
    on E:Exception do
      kErro(E.Message, C_UNIT, 'FindSindicato()');
  end;
  finally
    DataSet.Free;
  end;

end;  // FindSindicato

function FindSindicato( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  iCodigo: Integer;
  sNome: String;
  bSave: Boolean;
begin

  Result := FindSindicato( Pesquisa, iCodigo, sNome);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      bSave := False;

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
      begin
        DataSet.Edit;
        bSave := True;
      end;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDSINDICATO')) then
          DataSet.FieldByName('IDSINDICATO').AsInteger := iCodigo;
        if Assigned(DataSet.FindField('SINDICATO')) then
          DataSet.FieldByName('SINDICATO').AsString := sNome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := sNome
      end;

      if bSave and (DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Post;

    end;

  end else
  begin
    kErro('Sindicato não encontrado !!!');
    Key := 0;
  end;

end;  // FindSindicato

procedure CriaSindicato();
var
  Frm: TFrmSindicato;
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmSindicato) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  Frm := TFrmSindicato.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'F_SINDICATO';
      Iniciar();
      Show;
    end;  // with Frm do
  except
    on E: Exception do
      kErro( E.Message, '.', 'CriaSindicato()');
  end; // try

end;

procedure TFrmSindicato.Iniciar;
var
  cdUF, cdPais:  TClientDataSet;
  dsUF, dsPais: TDataSource;
begin

  kNovaPesquisa( mtPesquisa, 'ID', 'WHERE IDSINDICATO = #');
  kNovaPesquisa( mtPesquisa, 'NOME', 'WHERE NOME LIKE '+QuotedStr('#%'));

  cdUF   := TClientDataSet.Create(Self);
  cdPais := TClientDataSet.Create(Self);

  kSQLSelectFrom( cdUF, 'UF');
  cdUF.IndexFieldNames := 'IDUF';

  kSQLSelectFrom( cdPais, 'PAIS');
  cdPais.IndexFieldNames := 'IDPAIS';

  dsPais := TDataSource.Create(Self);
  dsPais.DataSet := cdPais;

  with dbPais do begin
    ListSource := dsPais;
    KeyField   := 'IDPAIS';
    ListField  := 'IDPAIS';
  end;

  dsUF := TDataSource.Create(Self);
  dsUF.DataSet := cdUF;

  with dbUF do begin
    ListSource := dsUF;
    KeyField   := 'IDUF';
    ListField  := 'IDUF';
  end;

  inherited Iniciar;

  dbgRegistro.SetFocus;

end;  // iniciar

procedure TFrmSindicato.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
end;

procedure TFrmSindicato.FormCreate(Sender: TObject);
begin
  inherited;
  dbNome.Font.Style := dbNome.Font.Style + [fsBold];
end;

procedure TFrmSindicato.mtRegistroBeforeDelete(DataSet: TDataSet);
begin

  with DataSet do
   if FieldByName('IDSINDICATO').AsInteger = 0 then
   begin
     kErro('Este sindicato é o padrão e não pode ser excluído.');
     SysUtils.Abort;
   end else if not kConfirme('Excluir o sindicato '+
                             QuotedStr(FieldByName('NOME').AsString)+' ?') then
      SysUtils.Abort;

  inherited;

end;

procedure TFrmSindicato.mtRegistroNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDSINDICATO').AsInteger := kMaxCodigo( pvTabela, 'IDSINDICATO');
    FieldByName('IDPAIS').AsString       := 'BRA';
  end;
end;

procedure TFrmSindicato.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
end;

procedure TFrmSindicato.dbCNPJExit(Sender: TObject);
var
  iSindicato: Integer;
  sCNPJ: String;
begin

  if not (mtRegistro.State in [dsInsert,dsEdit]) then
    Exit;

  iSindicato := mtRegistro.FieldByName('IDSINDICATO').AsInteger;
  sCNPJ      := mtRegistro.FieldByName(TDBEdit(Sender).DataField).AsString;

  if not VerificaCNPJ( iSindicato, sCNPJ) then
  begin
    TDBEdit(Sender).SelectAll;
    TDBEdit(Sender).SetFocus;
  end;

end;

procedure TFrmSindicato.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('CNPJ').AsString = EmptyStr) then
      FieldByName('CNPJ').Value := Null
    else if not VerificaCNPJ( FieldByName('IDSINDICATO').AsInteger,
                              FieldByName('CNPJ').AsString) then
      SysUtils.Abort;
  inherited;
end;

procedure TFrmSindicato.mtRegistroCNPJGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatCPF(Text);
end;

function TFrmSindicato.VerificaCNPJ( Sindicato: Integer; CNPJ: String):Boolean;
begin

  Result := False;

  if (CNPJ = EmptyStr) then
    Result := True

  else if not kChecaCGC(CNPJ) then
    kErro('O número de CNPJ está inválido.'+sLineBreak+
          'Verifique e informe novamente.')

  else if (kCountSQL( pvTabela, 'IDSINDICATO <> :E AND CNPJ = :C',
                          [Sindicato,CNPJ]) > 0) then
    kErro('Você não pode usar esse número de CNPJ.'+sLineBreak+
          'Há outro sindicato utilizando esse número.'+sLineBreak+sLineBreak+
          'Informe outro número ou deixe esse campo em branco.')
  else
    Result := True;

end;

end.
