{
FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2002 Allan Kardek Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Autor: Allan Kardek Lima
E-mail: allan_kardek@yahoo.com.br ; folha_livre@yahoo.com.br
}

unit fendereco;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QMask, QDBCtrls, QExtCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes, DB;

type
  TFrameEndereco = class(TFrame)
    pnlEndereco1: TPanel;
    LblEndereco1: TLabel;
    lblComplemento1: TLabel;
    dbEndereco1: TDBEdit;
    dbComplemento1: TDBEdit;
    dbBairro1: TDBEdit;
    dbCidade1: TDBEdit;
    dbPais1: TDBLookupComboBox;
    dbUF1: TDBLookupComboBox;
    dbCEP1: TDBEdit;
    pnlEndereco2: TPanel;
    lblEndereco2: TLabel;
    lblComplemento2: TLabel;
    dbEndereco2: TDBEdit;
    dbBairro2: TDBEdit;
    dbCidade2: TDBEdit;
    dbPais2: TDBLookupComboBox;
    dbComplemento2: TDBEdit;
    dbUF2: TDBLookupComboBox;
    dbCEP2: TDBEdit;
    pnlTelefone: TPanel;
    lblTelefone1: TLabel;
    lblTelefone2: TLabel;
    lblFax: TLabel;
    lblCelular: TLabel;
    lblBIP: TLabel;
    lblFoneFax: TLabel;
    dbTelefone1: TDBEdit;
    dbTelefone2: TDBEdit;
    dbFax: TDBEdit;
    dbCelular: TDBEdit;
    dbBIP: TDBEdit;
    pnlInternet: TPanel;
    lblEmail: TLabel;
    lblHP: TLabel;
    dbHomePage: TDBEdit;
    dbEmail: TDBEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    dbFoneFax: TDBEdit;
    dbEnviar: TDBCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Configura( DataSource1: TDataSource;
      Bairro, Cidade, UF, Pais: TDataSet);
  end;

implementation

uses fdb;

{$R *.dfm}

procedure TFrameEndereco.Configura( DataSource1: TDataSource;
  Bairro, Cidade, UF, Pais: TDataSet);
var
  dsUF, dsPais: TDataSource;
begin

  kSQLSelectFrom( Bairro, 'BAIRRO');
  kSQLSelectFrom( Cidade, 'CIDADE');
  kSQLSelectFrom( UF, 'UF');
  kSQLSelectFrom( Pais, 'PAIS');

  dsUF := TDataSource.Create(Self);
  dsUF.DataSet := UF;

  dsPais := TDataSource.Create(Self);
  dsPais.DataSet := Pais;

  dbEndereco1.Font.Style := [fsBold];
  dbEndereco1.Font.Color := clBlack;

  dbEndereco1.DataSource := DataSource1;
  dbEndereco1.DataField  := 'ENDERECO';

  dbComplemento1.DataSource := DataSource1;
  dbComplemento1.DataField  := 'COMPLEMENTO';

  dbBairro1.DataSource := DataSource1;
  dbBairro1.DataField  := 'BAIRRO';

  dbCidade1.DataSource := DataSource1;
  dbCidade1.DataField  := 'CIDADE';

  with dbPais1 do
  begin
    DataSource := DataSource1;
    DataField  := 'IDPAIS';
    ListSource := dsPais;
    ListField  := 'IDPAIS';
    KeyField   := 'IDPAIS';
  end;

  with dbUF1 do
  begin
    DataSource := DataSource1;
    DataField  := 'IDUF';
    ListSource := dsUF;
    ListField  := 'IDUF';
    KeyField   := 'IDUF';
  end;

  dbCEP1.DataSource := DataSource1;
  dbCEP1.DataField  := 'CEP';

  // *******

  dbEndereco2.Font.Style := [fsBold];
  dbEndereco2.Font.Color := clRed;

  dbEndereco2.DataSource := DataSource1;
  dbEndereco2.DataField  := 'ENDERECO2';

  dbComplemento2.DataSource := DataSource1;
  dbComplemento2.DataField  := 'COMPLEMENTO2';

  dbBairro2.DataSource := DataSource1;
  dbBairro2.DataField  := 'BAIRRO2';

  dbCidade2.DataSource := DataSource1;
  dbCidade2.DataField  := 'CIDADE2';

  with dbPais2 do
  begin
    DataSource := DataSource1;
    DataField  := 'IDPAIS2';
    ListSource := dsPais;
    ListField  := 'IDPAIS';
    KeyField   := 'IDPAIS';
  end;

  with dbUF2 do
  begin
    DataSource := DataSource1;
    DataField  := 'IDUF2';
    ListSource := dsUF;
    ListField  := 'IDUF';
    KeyField   := 'IDUF';
  end;

  dbCEP2.DataSource := DataSource1;
  dbCEP2.DataField  := 'CEP2';

  // **************

  dbTelefone1.DataSource := DataSource1;
  dbTelefone1.DataField  := 'PRINCIPAL';

  dbTelefone2.DataSource := DataSource1;
  dbTelefone2.DataField  := 'COMPLEMENTAR';

  dbFax.DataSource := DataSource1;
  dbFax.DataField  := 'FAX';

  dbFoneFax.DataSource := DataSource1;
  dbFoneFax.DataField  := 'FONEFAX';

  dbCelular.DataSource := DataSource1;
  dbCelular.DataField  := 'CELULAR';

  dbBIP.DataSource := DataSource1;
  dbBIP.DataField  := 'BIP';

  // ********************
  dbEmail.DataSource := DataSource1;
  dbEmail.DataField  := 'EMAIL';

  dbHomePage.DataSource := DataSource1;
  dbHomePage.DataField  := 'HOMEPAGE';

  if Assigned(DataSource1.DataSet.FindField('ENVIAR_CORRESPONDENCIA_X')) then
  begin
    dbEnviar.DataSource := DataSource1;
    dbEnviar.DataField  := 'ENVIAR_CORRESPONDENCIA_X';
  end else
    dbEnviar.Visible := False;

end;  // Configura

end.
