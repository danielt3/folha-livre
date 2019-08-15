{
FolhaLivre - Folha de Pagamento Copyright (C) 2002 Allan Kardek N Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

autor(es): Allan Kardek Neponuceno Lima
emails: allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}
unit sys_conta_bancaria;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RXCtrls, RXDBCtrl, StdCtrls,
  Db, DBCtrls, Mask, Grids, DBGrids, DBClient, ComCtrls, Buttons,
  fdialogo, VolDBEdit, AKLabel;

type
  TFrmContaBancaria = class(TFrmDialogo)
    lbID: TLabel;
    dbID: TDBEdit;
    dbTitulo: TDBEdit;
    lbTitulo: TLabel;
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroIDCONTA: TStringField;
    mtRegistroIDBANCO: TStringField;
    mtRegistroIDAGENCIA: TStringField;
    mtRegistroTITULO: TStringField;
    dbBanco: TDBEdit;
    lbBanco: TLabel;
    dbAgencia: TDBEdit;
    lbAgencia: TLabel;
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CriaContaBancaria;

function kPesquisaContaBancaria( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word):Boolean;

implementation

uses fdb, ftext, fsuporte, ffind;

{$R *.DFM}

function kPesquisaContaBancaria( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word):Boolean;
var
  mtConta: TClientDataSet;
  vConta: Variant;
  i: Integer;
begin

  Result  := False;

  mtConta := TClientDataSet.Create(NIL);

  try

    mtConta.FieldDefs.Add('IDCONTA', ftString, 9);
    mtConta.FieldDefs.Add('IDBANCO', ftString, 3);
    mtConta.FieldDefs.Add('IDAGENCIA', ftString, 4);
    mtConta.FieldDefs.Add('TITULO', ftString, 10);

    kSQLSelectFrom( mtConta, 'CONTA_BANCARIA', Empresa);

    for i := 0 to mtConta.FieldCount-1 do
      mtConta.Fields[i].DisplayLabel := kRetira( mtConta.Fields[i].DisplayLabel, 'ID');

    if mtConta.Locate( 'IDCONTA', Pesquisa, []) or
       kFindDataSet( mtConta, 'Pesquisando Contas Bancárias', 'IDCONTA',
                     vConta, [foNoPanel]) then
    begin
      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDCONTA')) then
          DataSet.FieldByName('IDCONTA').AsString := mtConta.FieldByName('IDCONTA').AsString;
        if Assigned(DataSet.FindField('CONTA')) then
          DataSet.FieldByName('CONTA').AsString := mtConta.FieldByName('TITULO').AsString;
      end;
    end else begin
      kErro('Conta Bancária não encontrada. Tente novamente !!!');
      Key := 0;
    end;
    
  finally
    mtConta.Free;
  end;

end;

procedure CriaContaBancaria;
var
  Frm: TFrmContaBancaria;
begin

  Frm := TFrmContaBancaria.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'CONTA_BANCARIA';
      Iniciar();
      ShowModal;
    end;
  finally
    Frm.Free;
  end;

end;  // procedure

procedure TFrmContaBancaria.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir a Conta "'+
                    Dataset.FieldByName('TITULO').AsString+' ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmContaBancaria.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbBanco.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmContaBancaria.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmContaBancaria.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus;
end;

end.
