{
Projeto FolhaLivre - Folha de Pagamento Livre
Rescisão de Contrato de Funcionarios

Copyright (c) 2005 Allan Lima, Brazil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@file-create: 02/05/2005
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

{$IFNDEF QFLIVRE}
unit frescisao_funcionario;
{$ENDIF}

{$I flivre.inc}

interface

uses
  SysUtils, Variants, Classes,
  {$IFDEF MSWINDOWS}
  Windows, Messages,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, StdCtrls, DBCtrls, Mask, ExtCtrls,
  {$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QDBCtrls, QMask, QExtCtrls,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient;

type
  TfrmRescisaoFuncionario = class(TForm)
    cdRescisao: TClientDataSet;
    cdRescisaoIDEMPRESA: TIntegerField;
    cdRescisaoIDFUNCIONARIO: TIntegerField;
    cdRescisaoDEMISSAO: TDateField;
    cdRescisaoREMUNERACAO: TCurrencyField;
    cdRescisaoAVISO_PREVIO_X: TSmallintField;
    cdRescisaoAVISO_PREVIO_DATA: TDateField;
    cdRescisaoIDRESCISAO: TStringField;
    cdRescisaoIDFOLHA: TIntegerField;
    cdRescisaoNOME: TStringField;
    cdRescisaoRESCISAO: TStringField;
    dsRescisao: TDataSource;
    Panel1: TPanel;
    lbDemissao: TLabel;
    dbDemissao: TDBEdit;
    dbRemuneracao: TDBEdit;
    lbRemuneracao: TLabel;
    dbAviso: TDBCheckBox;
    dbAvisoData: TDBEdit;
    Label7: TLabel;
    Panel2: TPanel;
    Label8: TLabel;
    dbCausa: TDBEdit;
    dbCausa2: TDBEdit;
    pnlControle: TPanel;
    pnlFuncionario: TPanel;
    Label2: TLabel;
    dbFuncionario: TDBEdit;
    dbNome: TDBEdit;
    btnOK: TButton;
    btnCancelar: TButton;
    cdRescisaoIDCAGED: TStringField;
    lbCAGED: TLabel;
    dbCAGED: TDBEdit;
    dbCAGED2: TDBEdit;
    cdRescisaoCAGED: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure cdRescisaoNewRecord(DataSet: TDataSet);
    procedure cdRescisaoBeforePost(DataSet: TDataSet);
    procedure btnOKClick(Sender: TObject);
    procedure cdRescisaoAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
    pvEmpresa: Integer;
    pvFolha: Integer;
    pvIncluir: Boolean;
    function VerificarFolha: Boolean;
    procedure VerificarRescisao( Pesquisa: String; var Key: Word);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

procedure CriaRescisaoFuncionario;

implementation

{$R *.dfm}

uses fsuporte, fdb, futil, fdeposito, ftext, frescisao_causa, fcaged;

procedure CriaRescisaoFuncionario;
var
  Frm: TfrmRescisaoFuncionario;
begin

  Frm := TfrmRescisaoFuncionario.Create(Application);

  try
    with Frm do
    begin
      if VerificarFolha() then
        ShowModal;
    end;
  finally
    Frm.Free;
  end;

end;

procedure TfrmRescisaoFuncionario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_ESCAPE) then
    Close

  else if (Key = VK_F12) and ( (ActiveControl = dbFuncionario) or (ActiveControl = dbNome) ) then
    VerificarRescisao( '', Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbFuncionario) then
    VerificarRescisao( dbFuncionario.Text, Key)

  else if (Key = VK_F12) and ( (ActiveControl = dbCausa) or (ActiveControl = dbCausa2) ) then
    FindRescisaoCausa( '*', cdRescisao, Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbCausa) then
    FindRescisaoCausa( dbCausa.Text, cdRescisao, Key)

  else if (Key = VK_F12) and ( (ActiveControl = dbCAGED) or (ActiveControl = dbCAGED2) ) then
    FindCAGED( 'D', '*', cdRescisao, Key, True)

  else if (Key = VK_RETURN) and (ActiveControl = dbCAGED) then
    FindCAGED( 'D', dbCAGED.Text, cdRescisao, Key, True);

  kKeyDown( Self, Key, Shift);

end;

procedure TfrmRescisaoFuncionario.FormShow(Sender: TObject);
begin

  Ctl3D := True;
  Color := clBtnFace;

  Self.ClientWidth := (pnlControle.Left*2) + pnlFuncionario.Width;

  dbNome.ParentColor := True;
  dbNome.TabStop     := False;
  dbNome.ReadOnly    := True;

  dbCausa2.ParentColor := True;
  dbCausa2.TabStop     := False;
  dbCausa2.ReadOnly    := True;

  dbCAGED2.ParentColor := True;
  dbCAGED2.TabStop     := False;
  dbCAGED2.ReadOnly    := True;

  Self.ClientHeight := pnlControle.Top + pnlControle.Height + 1;

  with cdRescisao do
  begin
    CreateDataSet;
    Append;
  end;

  dbFuncionario.SetFocus;

end;

procedure TfrmRescisaoFuncionario.cdRescisaoNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').AsInteger           := pvEmpresa;
    FieldByName('IDFOLHA').AsInteger             := pvFolha;
    FieldByName('DEMISSAO').AsDateTime           := Date();
    FieldByName('AVISO_PREVIO_X').AsInteger      := 1;
    FieldByName('AVISO_PREVIO_DATA').AsDateTime  := Date();
    FieldByName('REMUNERACAO').AsCurrency        := 0.0;
  end;
end;

procedure TfrmRescisaoFuncionario.cdRescisaoBeforePost(DataSet: TDataSet);
var
  bResult: Boolean;
begin

  if pvIncluir then
    bResult := kSQLInsert( DataSet, 'F_RESCISAO_CONTRATO', DataSet.Fields)
  else
    bResult := kSQLUpdate( DataSet, 'F_RESCISAO_CONTRATO', DataSet.Fields);

  if not bResult then
    SysUtils.Abort;

end;

procedure TfrmRescisaoFuncionario.btnOKClick(Sender: TObject);
begin
  if cdRescisao.State in [dsInsert,dsEdit] then
    cdRescisao.Post;
  if cdRescisao.State = dsBrowse then
    Close;
end;

constructor TfrmRescisaoFuncionario.Create(AOwner: TComponent);
begin
  pvEmpresa := StrToInt( kGetDeposito('EMPRESA_ID', '1'));
  pvFolha   := StrToInt( kGetDeposito('FOLHA_ID', '1'));
  inherited;
end;

function TfrmRescisaoFuncionario.VerificarFolha: Boolean;
var
  sTipo: String;
  iArquivar: Integer;
begin

  Result := False;

  if not kGetFieldSQL( 'SELECT IDFOLHA_TIPO FROM F_FOLHA'#13+
                       'WHERE IDEMPRESA = :EMPRESA AND IDFOLHA = :FOLHA',
                       [pvEmpresa, pvFolha], sTipo) then
    Exit;

  if (sTipo <> 'R') then
  begin
    kErro( 'A folha atual não é do tipo "RESCISÃO".'#13+
           'Esta operação só pode ser realizada em folhas de tipo "RESCISÃO".');
    Exit;
  end;

  if not kGetFieldSQL( 'SELECT ARQUIVAR_X FROM F_FOLHA'#13+
                       'WHERE IDEMPRESA = :EMPRESA AND IDFOLHA = :FOLHA',
                       [pvEmpresa, pvFolha], iArquivar) then
    Exit;

  if (iArquivar = 1) then
  begin
    kErro( 'A folha atual já está encerrada/arquivada.'#13+
           'Esta operação só pode ser realizada em folhas não encerradas/arquivada.');
    Exit;
  end;

  Result := True;

end;

procedure TfrmRescisaoFuncionario.cdRescisaoAfterOpen(DataSet: TDataSet);
begin
  TCurrencyField(DataSet.FieldByName('REMUNERACAO')).DisplayFormat := ',0.00';
end;

procedure TfrmRescisaoFuncionario.VerificarRescisao( Pesquisa: String; var Key: Word);
var
  sNome: String;
  iFuncionario, iCount: Integer;
  SQL: TStringList;
begin

  pvIncluir := True;

  PesquisaFuncionario( Pesquisa, pvEmpresa, cdRescisao, Key);

  if (Key <> 0) then
  begin

    iFuncionario := cdRescisao.FieldByName('IDFUNCIONARIO').AsInteger;
    sNome        := cdRescisao.FieldByName('NOME').AsString;

    iCount       := kCountSQL( 'F_RESCISAO_CONTRATO',
                               'IDEMPRESA = :EMPRESA AND IDFUNCIONARIO = :FUNCIONARIO',
                               [pvEmpresa, iFuncionario]);

    if (iCount = 0) then
      Exit;

    pvIncluir := False;

    if kConfirme('Já existe uma Rescisão prevista para o funcionário "'+sNome+'.'#13#13+
                 'Deseja excluí-la?') then
    begin
      if kSQLDelete( cdRescisao, 'F_RESCISAO_CONTRATO', cdRescisao.Fields) then
        kAviso('A rescisão foi excluída com sucesso', mtInformation);
      Close;
      Exit;
    end;

    SQL := TStringList.Create;

    try

      SQL.BeginUpdate;
      sql.Add('SELECT');
      SQL.Add('  R.*, P.NOME,');
      SQL.Add('  T.NOME AS RESCISAO, C.NOME AS CAGED');
      SQL.Add('FROM');
      SQL.Add('  F_RESCISAO_CONTRATO R, FUNCIONARIO F,');
      SQL.Add('  PESSOA P, F_RESCISAO T, F_CAGED C');
      SQL.Add('WHERE');
      SQL.Add('  R.IDEMPRESA = :EMPRESA');
      SQL.Add('  AND R.IDFUNCIONARIO = :FUNCIONARIO');
      SQL.Add('  AND F.IDEMPRESA = R.IDEMPRESA');
      SQL.Add('  AND F.IDFUNCIONARIO = R.IDFUNCIONARIO');
      SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
      SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');
      SQL.Add('  AND T.IDRESCISAO = R.IDRESCISAO');
      SQL.Add('  AND C.IDCAGED = R.IDCAGED');
      SQL.EndUpdate;

      kOpenSQL( cdRescisao, SQL.Text, [pvEmpresa, iFuncionario]);

    finally
      SQL.Free;
    end;

  end;

end;

end.
