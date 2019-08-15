{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Empresas

Copyright (C) 2002-2007 Allan Lima, Belém-Pará-Brasil.

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

unit fempresas;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids,
  QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$ENDIF}
  Variants, fcadastro, DB, DBClient;

type
  TFrmEmpresa = class(TFrmCadastro)
    pnlDados: TPanel;
    lbCodigo: TLabel;
    lbNome: TLabel;
    dbCodigo: TDBEdit;
    dbNome: TDBEdit;
    Bevel2: TBevel;
    mtListagemIDEMPRESA: TIntegerField;
    mtListagemNOME: TStringField;
    mtListagemCPF_CGC: TStringField;
    mtListagemIDGE: TIntegerField;
    mtListagemAPELIDO: TStringField;
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroNOME: TStringField;
    mtRegistroCPF_CGC: TStringField;
    mtRegistroAPELIDO: TStringField;
    mtRegistroENDERECO: TStringField;
    mtRegistroCOMPLEMENTO: TStringField;
    mtRegistroBAIRRO: TStringField;
    mtRegistroCIDADE: TStringField;
    mtRegistroIDPAIS: TStringField;
    mtRegistroIDUF: TStringField;
    mtRegistroCEP: TStringField;
    mtRegistroTELEFONE: TStringField;
    mtRegistroOBSERVACAO: TStringField;
    lbApelido: TLabel;
    dbApelido: TDBEdit;
    mtRegistroPESSOA: TStringField;
    mtRegistroIDGE: TStringField;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    dbObservacao: TDBMemo;
    TabGeral: TTabSheet;
    pnlDoc: TPanel;
    Bevel4: TBevel;
    lblCPF: TLabel;
    lblPessoa: TLabel;
    lbTelefone: TLabel;
    lbGrupoEmpresa: TLabel;
    dbCPF: TDBEdit;
    dbPessoa: TDBLookupComboBox;
    dbTelefone: TDBEdit;
    dbGrupoEmpresa: TDBLookupComboBox;
    pnlEndereco1: TPanel;
    Bevel1: TBevel;
    LblEndereco1: TLabel;
    lblComplemento1: TLabel;
    dbEndereco: TDBEdit;
    dbComplemento: TDBEdit;
    dbBairro: TDBEdit;
    dbCidade: TDBEdit;
    dbPais: TDBLookupComboBox;
    dbUF: TDBLookupComboBox;
    dbCEP: TDBEdit;
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroCPF_CGCGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbCPFExit(Sender: TObject);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
  private
    function VerificaCNPJ(Empresa: Integer; CNPJ: String): Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaEmpresa();

implementation

uses fdb, ftext, fbase, fsuporte;

{$R *.dfm}

procedure CriaEmpresa();
var
  Frm: TFrmEmpresa;
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmEmpresa) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  Frm := TFrmEmpresa.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'EMPRESA';
      Iniciar();
      Show;
    end;  // with Frm do
  except
    on E: Exception do
      kErro( E.Message, '.', 'CriaEmpresa()');
  end; // try

end;

procedure TFrmEmpresa.Iniciar;
var
  cdUF, cdPais, cdNatureza, cdGrupo: TClientDataSet;
  dsNatureza, dsGE, dsUF, dsPais: TDataSource;
begin

  kNovaPesquisa( mtPesquisa, 'ID', 'WHERE IDEMPRESA = #');
  kNovaPesquisa( mtPesquisa, 'NOME', 'WHERE NOME LIKE '+QuotedStr('#%'));

  cdUF       := TClientDataSet.Create(Self);
  cdPais     := TClientDataSet.Create(Self);
  cdNatureza := TClientDataSet.Create(Self);
  cdGrupo    := TClientDataSet.Create(Self);

  kSQLSelectFrom( cdUF, 'UF');
  cdUF.IndexFieldNames := 'IDUF';

  kSQLSelectFrom( cdPais, 'PAIS');
  cdPais.IndexFieldNames := 'IDPAIS';
  
  with cdNatureza do
  begin
    FieldDefs.Add('PESSOA', ftString, 1);
    FieldDefs.Add('NOME', ftString, 15);
    CreateDataSet;
    AppendRecord( ['F', 'Física']);
    AppendRecord( ['J', 'Jurídica']);
  end;

  cdGrupo.FieldDefs.Add('IDGE', ftString, 10);
  cdGrupo.FieldDefs.Add('NOME', ftString, 30);

  kSQLSelectFrom( cdGrupo, 'F_GRUPO_EMPRESA');

  dsGE := TDataSource.Create(Self);
  dsGE.DataSet := cdGrupo;

  with dbGrupoEmpresa do begin
    ListSource := dsGE;
    ListField  := 'NOME';
    KeyField   := 'IDGE';
    DropDownRows := cdGrupo.RecordCount;
  end;

  dsNatureza := TDataSource.Create(Self);
  dsNatureza.DataSet := cdNatureza;

  with dbPessoa do
  begin
    ListSource := dsNatureza;
    KeyField   := 'PESSOA';
    ListField  := 'NOME';
  end;

  dsPais := TDataSource.Create(Self);
  dsPais.DataSet := cdPais;

  with dbPais do
  begin
    ListSource := dsPais;
    KeyField   := 'IDPAIS';
    ListField  := 'IDPAIS';
  end;

  dsUF := TDataSource.Create(Self);
  dsUF.DataSet := cdUF;

  with dbUF do
  begin
    ListSource := dsUF;
    KeyField   := 'IDUF';
    ListField  := 'IDUF';
  end;

  inherited Iniciar;

  dbgRegistro.SetFocus;

end;  // iniciar

procedure TFrmEmpresa.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
  lbGrupoEmpresa.Enabled := False;
  dbGrupoEmpresa.Enabled := False;
end;

procedure TFrmEmpresa.FormCreate(Sender: TObject);
begin
  inherited;
  dbNome.Font.Style := dbNome.Font.Style + [fsBold];
end;

procedure TFrmEmpresa.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin

  sNome := DataSet.FieldByName('NOME').AsString;

  if (DataSet.FieldByName('IDEMPRESA').AsInteger = 0) then
  begin
    kErro('A Empresa Global não pode ser excluída');
    SysUtils.Abort;
  end else if not kConfirme('Excluir a Empresa "'+sNome+'" ?') then
    SysUtils.Abort
  else
    inherited;

end;

procedure TFrmEmpresa.mtRegistroNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('PESSOA').AsString := 'J';
    FieldByName('IDPAIS').AsString := 'BRA';
    FieldByName('IDGE').AsString   := dbGrupoEmpresa.DataSource.DataSet.FieldByName('IDGE').AsString;
  end;
end;

procedure TFrmEmpresa.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
  lbGrupoEmpresa.Enabled := True;
  dbGrupoEmpresa.Enabled := True;
end;

procedure TFrmEmpresa.mtRegistroCPF_CGCGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatCPF(Text);
end;

procedure TFrmEmpresa.dbCPFExit(Sender: TObject);
var
  iEmpresa: Integer;
  sCNPJ: String;
begin

  if not (mtRegistro.State in [dsInsert,dsEdit]) then
    Exit;

  iEmpresa := mtRegistro.FieldByName('IDEMPRESA').AsInteger;
  sCNPJ    := mtRegistro.FieldByName(TDBEdit(Sender).DataField).AsString;

  if (sCNPJ = EmptyStr) then
    Exit;

  if not VerificaCNPJ( iEmpresa, sCNPJ) then
  begin
    TDBEdit(Sender).SelectAll;
    TDBEdit(Sender).SetFocus;
  end;

end;


procedure TFrmEmpresa.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('CPF_CGC').AsString = EmptyStr) then
      FieldByName('CPF_CGC').Value := Null
    else if not VerificaCNPJ( FieldByName('IDEMPRESA').AsInteger,
                              FieldByName('CPF_CGC').AsString) then
      SysUtils.Abort;
  inherited;
end;

function TFrmEmpresa.VerificaCNPJ( Empresa: Integer; CNPJ: String):Boolean;
begin

  Result := False;

  if (CNPJ = EmptyStr) then
    Result := True

  else if not kChecaCPFCGC(CNPJ, True) then
    kErro('O número de CNPJ está inválido.'+sLineBreak+
          'Verifique e informe novamente.')

  else if (kCountSQL( pvTabela, 'IDEMPRESA <> :E AND CPF_CGC = :C',
                                [Empresa,CNPJ]) > 0) then
    kErro('Você não pode usar esse número de CNPJ.'+sLineBreak+
          'Há outra empresa utilizando esse número.'+sLineBreak+sLineBreak+
          'Informe outro número ou deixe esse campo em branco.')
  else
    Result := True;

end;
end.
