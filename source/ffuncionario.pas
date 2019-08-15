{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Funcionarios

Copyright (c) 2002-2007 Allan Lima, Belém-Pará-Brasil.

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
@file-name: ffuncionario.pas
@file-title: Cadastro de Funcionários
}

{$IFNDEF QFLIVRE}
unit ffuncionario;
{$ENDIF}

{$I flivre.inc}

interface

uses
  Classes, SysUtils,
  {$IFDEF CLX}
  Qt, QStdCtrls, QDBCtrls, QMask, QExtCtrls, QGrids, QDBGrids, QComCtrls,
  QControls, QButtons, QForms, QGraphics, QDialogs,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, StdCtrls, DBCtrls, Mask, ExtCtrls, Grids, DBGrids, ComCtrls,
  Controls, Buttons, Forms, Graphics, Dialogs,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, MaskUtils, fcadastro, Math;

type
  TFrmFuncionario = class(TFrmCadastro)
    pnlPessoa: TPanel;
    lbCodigo: TLabel;
    lblNome: TLabel;
    lblApelido: TLabel;
    dbCodigo: TDBEdit;
    dbApelido: TDBEdit;
    dbNome: TDBEdit;
    pgFuncionario: TPageControl;
    TabPessoal: TTabSheet;
    pnlNascimento: TPanel;
    Bevel2: TBevel;
    lblNascimento: TLabel;
    lblNacionalidade: TLabel;
    lblNaturalidade: TLabel;
    pnlFiliacao: TPanel;
    Bevel3: TBevel;
    lblPai: TLabel;
    lblMae: TLabel;
    dbMae: TDBEdit;
    dbPai: TDBEdit;
    TabEndereco: TTabSheet;
    TabObservacao: TTabSheet;
    dbObservacao: TDBMemo;
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroIDFUNCIONARIO: TIntegerField;
    mtRegistroIDPESSOA: TIntegerField;
    mtRegistroIDADMISSAO: TStringField;
    mtRegistroIDRACA: TStringField;
    mtRegistroIDSABADO: TStringField;
    mtRegistroIDSALARIO: TStringField;
    mtRegistroIDSITUACAO: TStringField;
    mtRegistroIDTIPO: TStringField;
    mtRegistroIDVINCULO: TStringField;
    mtRegistroIDFGTS: TStringField;
    mtRegistroIDCAGED_ADMISSAO: TStringField;
    mtRegistroIDCAGED_DEMISSAO: TStringField;
    mtRegistroADMISSAO: TDateField;
    mtRegistroCARGA_HORARIA: TSmallintField;
    mtRegistroIDRESCISAO: TStringField;
    mtRegistroIDINSTRUCAO: TStringField;
    mtRegistroCARGO_NIVEL: TSmallintField;
    mtRegistroCTPS: TStringField;
    mtRegistroPIS_IPASEP: TStringField;
    mtRegistroDEMISSAO: TDateField;
    mtRegistroANO_CHEGADA: TSmallintField;
    mtRegistroOPTANTE_X: TSmallintField;
    mtRegistroFGTS_X: TSmallintField;
    mtRegistroFGTS_OPCAO: TDateField;
    mtRegistroFGTS_RETRATACAO: TDateField;
    mtRegistroDEFICIENTE_X: TSmallintField;
    mtRegistroIDRECURSO: TStringField;
    mtRegistroIDSINDICATO: TIntegerField;
    mtRegistroNOME: TStringField;
    mtRegistroAPELIDO: TStringField;
    mtRegistroCODIGO: TStringField;
    mtRegistroPESSOA: TStringField;
    mtRegistroCPF_CGC: TStringField;
    mtRegistroRG: TStringField;
    mtRegistroSEXO: TStringField;
    mtRegistroPAI: TStringField;
    mtRegistroMAE: TStringField;
    mtRegistroIDNACIONALIDADE: TStringField;
    mtRegistroIDNATURALIDADE: TStringField;
    mtRegistroIDESTADO_CIVIL: TStringField;
    mtRegistroENDERECO: TStringField;
    mtRegistroCOMPLEMENTO: TStringField;
    mtRegistroBAIRRO: TStringField;
    mtRegistroCIDADE: TStringField;
    mtRegistroIDPAIS: TStringField;
    mtRegistroIDUF: TStringField;
    mtRegistroCEP: TStringField;
    mtRegistroENDERECO2: TStringField;
    mtRegistroCOMPLEMENTO2: TStringField;
    mtRegistroBAIRRO2: TStringField;
    mtRegistroCIDADE2: TStringField;
    mtRegistroIDPAIS2: TStringField;
    mtRegistroIDUF2: TStringField;
    mtRegistroCEP2: TStringField;
    mtRegistroCELULAR: TStringField;
    mtRegistroBIP: TStringField;
    mtRegistroFAX: TStringField;
    mtRegistroPRINCIPAL: TStringField;
    mtRegistroCOMPLEMENTAR: TStringField;
    mtRegistroFONEFAX: TStringField;
    mtRegistroEMAIL: TStringField;
    mtRegistroHOMEPAGE: TStringField;
    mtRegistroOBSERVACAO: TStringField;
    mtRegistroCADASTRO: TSQLTimeStampField;
    mtRegistroATUALIZACAO: TSQLTimeStampField;
    mtRegistroNASCIMENTO: TDateField;
    TabFuncional: TTabSheet;
    pnlSalario: TPanel;
    Bevel5: TBevel;
    lbAdmissao: TLabel;
    cdFuncionario: TClientDataSet;
    cdFuncionarioIDEMPRESA: TIntegerField;
    cdFuncionarioIDFUNCIONARIO: TIntegerField;
    cdFuncionarioIDPESSOA: TIntegerField;
    cdFuncionarioIDADMISSAO: TStringField;
    cdFuncionarioIDRACA: TStringField;
    cdFuncionarioIDSABADO: TStringField;
    cdFuncionarioIDSALARIO: TStringField;
    cdFuncionarioIDSITUACAO: TStringField;
    cdFuncionarioIDTIPO: TStringField;
    cdFuncionarioIDVINCULO: TStringField;
    cdFuncionarioIDFGTS: TStringField;
    cdFuncionarioIDCAGED_ADMISSAO: TStringField;
    cdFuncionarioADMISSAO: TDateField;
    cdFuncionarioCARGA_HORARIA: TSmallintField;
    cdFuncionarioIDRESCISAO: TStringField;
    cdFuncionarioIDINSTRUCAO: TStringField;
    cdFuncionarioIDCARGO: TIntegerField;
    cdFuncionarioCARGO_NIVEL: TSmallintField;
    cdFuncionarioCTPS: TStringField;
    cdFuncionarioCTPS_SERIE: TStringField;
    cdFuncionarioPIS_IPASEP: TStringField;
    cdFuncionarioDEMISSAO: TDateField;
    cdFuncionarioANO_CHEGADA: TSmallintField;
    cdFuncionarioOPTANTE: TSmallintField;
    cdFuncionarioFGTS_X: TSmallintField;
    cdFuncionarioFGTS_OPCAO: TDateField;
    cdFuncionarioFGTS_RETRATACAO: TDateField;
    cdFuncionarioDEFICIENTE_X: TSmallintField;
    cdFuncionarioIDRECURSO: TStringField;
    cdFuncionarioIDSINDICATO: TIntegerField;
    cdPessoa: TClientDataSet;
    cdPessoaIDEMPRESA: TIntegerField;
    cdPessoaIDPESSOA: TIntegerField;
    cdPessoaNOME: TStringField;
    cdPessoaAPELIDO: TStringField;
    cdPessoaPESSOA: TStringField;
    cdPessoaCPF_CGC: TStringField;
    cdPessoaRG: TStringField;
    cdPessoaSEXO: TStringField;
    cdPessoaPAI: TStringField;
    cdPessoaMAE: TStringField;
    cdPessoaIDNACIONALIDADE: TStringField;
    cdPessoaIDNATURALIDADE: TStringField;
    cdPessoaIDESTADO_CIVIL: TStringField;
    cdPessoaENDERECO: TStringField;
    cdPessoaCOMPLEMENTO: TStringField;
    cdPessoaBAIRRO: TStringField;
    cdPessoaCIDADE: TStringField;
    cdPessoaIDPAIS: TStringField;
    cdPessoaIDUF: TStringField;
    cdPessoaCEP: TStringField;
    cdPessoaENDERECO2: TStringField;
    cdPessoaCOMPLEMENTO2: TStringField;
    cdPessoaBAIRRO2: TStringField;
    cdPessoaCIDADE2: TStringField;
    cdPessoaIDPAIS2: TStringField;
    cdPessoaIDUF2: TStringField;
    cdPessoaCEP2: TStringField;
    cdPessoaCELULAR: TStringField;
    cdPessoaBIP: TStringField;
    cdPessoaFAX: TStringField;
    cdPessoaPRINCIPAL: TStringField;
    cdPessoaCOMPLEMENTAR: TStringField;
    cdPessoaFONEFAX: TStringField;
    cdPessoaEMAIL: TStringField;
    cdPessoaHOMEPAGE: TStringField;
    cdPessoaOBSERVACAO: TStringField;
    cdPessoaCADASTRO: TSQLTimeStampField;
    cdPessoaATUALIZACAO: TSQLTimeStampField;
    cdPessoaNASCIMENTO: TDateField;
    lbSalario: TLabel;
    dbCarga: TDBEdit;
    Label1: TLabel;
    mtRegistroSALARIO: TCurrencyField;
    cdFuncionarioSALARIO: TCurrencyField;
    dbNascimento: TDBEdit;
    dbAdmissao: TDBEdit;
    dbSalario: TDBEdit;
    pnlCivil: TPanel;
    Bevel6: TBevel;
    lbInstrucao: TLabel;
    lblEstadoCivil: TLabel;
    lblSexo: TLabel;
    dbChegada: TDBEdit;
    lbChegada: TLabel;
    pnlDoc: TPanel;
    Bevel4: TBevel;
    lblCPF: TLabel;
    lbPIS: TLabel;
    lbCTPS: TLabel;
    lbRG: TLabel;
    dbCPF: TDBEdit;
    dbPIS: TDBEdit;
    dbCTPS: TDBEdit;
    dbRG: TDBEdit;
    pnlRecurso: TPanel;
    cdFuncionarioIDLOTACAO: TIntegerField;
    dbDeficiente: TDBCheckBox;
    mtRegistroIDGP: TStringField;
    cdFuncionarioIDGP: TIntegerField;
    lbLotacao: TLabel;
    dbLotacao2: TDBEdit;
    mtRegistroLOTACAO: TStringField;
    mtRegistroIDLOTACAO: TStringField;
    mtRegistroIDCARGO: TStringField;
    mtRegistroCARGO: TStringField;
    dbSexo: TDBLookupComboBox;
    dbEstadoCivil: TDBLookupComboBox;
    dbLotacao: TAKDBEdit;
    dbNaturalidade: TDBLookupComboBox;
    dbNacionalidade: TDBLookupComboBox;
    dbInstrucao: TDBLookupComboBox;
    pnlFGTS: TPanel;
    lbOpcao: TLabel;
    dbOpcao: TDBEdit;
    lbRetratacao: TLabel;
    dbRetratacao: TDBEdit;
    dbFGTS: TDBCheckBox;
    dbOptante: TDBCheckBox;
    Bevel7: TBevel;
    Bevel8: TBevel;
    mtRegistroIDBANCO: TStringField;
    mtRegistroBANCO: TStringField;
    mtRegistroIDAGENCIA: TStringField;
    mtRegistroAGENCIA: TStringField;
    cdFuncionarioIDBANCO: TStringField;
    cdFuncionarioIDAGENCIA: TStringField;
    mtRegistroCONTA_BANCARIA: TStringField;
    cdFuncionarioCONTA_BANCARIA: TStringField;
    cdFuncionarioIMPOSTO_SINDICAL_X: TSmallintField;
    mtRegistroIMPOSTO_SINDICAL_X: TSmallintField;
    cdFuncionarioADIANTAMENTO_X: TSmallintField;
    cdFuncionarioADIANTAMENTO: TCurrencyField;
    mtRegistroADIANTAMENTO_X: TSmallintField;
    mtRegistroADIANTAMENTO: TFloatField;
    TabAdicional: TTabSheet;
    pnlBanco: TPanel;
    lbAgencia: TLabel;
    lbBanco: TLabel;
    lbContaBancaria: TLabel;
    dbBanco2: TDBEdit;
    dbAgencia2: TDBEdit;
    dbBanco: TDBEdit;
    dbAgencia: TDBEdit;
    dbContaBancaria: TDBEdit;
    Bevel9: TBevel;
    pnlAdiantamento: TPanel;
    dbAdiantamento_x: TDBCheckBox;
    dbAdiantamento: TDBEdit;
    Bevel1: TBevel;
    pnlSindicato: TPanel;
    Bevel10: TBevel;
    lbSindicato: TLabel;
    dbSindicato: TDBLookupComboBox;
    lbCargo: TLabel;
    dbCargo: TAKDBEdit;
    dbCargo2: TDBEdit;
    dbNivel: TDBEdit;
    lbNivel: TLabel;
    dbTipoSalario: TDBLookupComboBox;
    lbTipoSalario: TLabel;
    mtRegistroSALARIO_MENSAL: TCurrencyField;
    lblSalarioMensal: TLabel;
    dbSalarioMensal: TDBEdit;
    dbAssociado: TDBCheckBox;
    mtRegistroASSOCIADO_X: TSmallintField;
    cdFuncionarioCTPS_ORGAO: TStringField;
    lblRGOrgao: TLabel;
    dbRGOrgao: TDBEdit;
    lbRGEmissao: TLabel;
    dbRGEmissao: TDBEdit;
    mtRegistroRG_ORGAO: TStringField;
    mtRegistroRG_EMISSAO: TDateField;
    lblCTPSSerie: TLabel;
    dbCTPSSerie: TDBEdit;
    dbCTPSOrgao: TDBEdit;
    Label3: TLabel;
    lblCTPSEmissao: TLabel;
    dbCTPSEmissao: TDBEdit;
    mtRegistroCTPS_SERIE: TStringField;
    mtRegistroCTPS_ORGAO: TStringField;
    mtRegistroCTPS_EMISSAO: TDateField;
    cdFuncionarioCTPS_EMISSAO: TDateField;
    cdPessoaRG_ORGAO: TStringField;
    cdPessoaRG_EMISSAO: TDateField;
    pnlEndereco1: TPanel;
    Bevel11: TBevel;
    LblEndereco1: TLabel;
    lblComplemento1: TLabel;
    dbEndereco1: TDBEdit;
    dbComplemento1: TDBEdit;
    dbBairro1: TDBEdit;
    dbCidade1: TDBEdit;
    dbPais1: TDBLookupComboBox;
    dbUF1: TDBLookupComboBox;
    dbCEP1: TDBEdit;
    pnlTelefone: TPanel;
    Bevel13: TBevel;
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
    dbFoneFax: TDBEdit;
    pnlInternet: TPanel;
    Bevel14: TBevel;
    lblEmail: TLabel;
    lblHP: TLabel;
    dbHomePage: TDBEdit;
    dbEmail: TDBEdit;
    pnlEndereco2: TPanel;
    Bevel12: TBevel;
    lblEndereco2: TLabel;
    lblComplemento2: TLabel;
    dbEndereco2: TDBEdit;
    dbBairro2: TDBEdit;
    dbCidade2: TDBEdit;
    dbPais2: TDBLookupComboBox;
    dbComplemento2: TDBEdit;
    dbUF2: TDBLookupComboBox;
    dbCEP2: TDBEdit;
    dbImpostoSindical: TDBCheckBox;
    pnlStatus: TPanel;
    lblCadastro: TLabel;
    lblAtualizacao: TLabel;
    dbCadastro: TDBEdit;
    dbAtualizacao: TDBEdit;
    pnlPagamento: TPanel;
    Bevel15: TBevel;
    lbGP: TLabel;
    dbGP: TDBLookupComboBox;
    lbRecurso: TLabel;
    dbRecurso: TDBLookupComboBox;
    lbNaturezaRendimento: TLabel;
    dbNaturezaRendimento: TDBLookupComboBox;
    mtRegistroIDNATUREZA: TStringField;
    cdFuncionarioIDNATUREZA: TStringField;
    TabVinculo: TTabSheet;
    dbVinculo: TDBRadioGroup;
    dbIDFGTS: TDBRadioGroup;
    TabRAIS: TTabSheet;
    dbIDAdmissao: TDBRadioGroup;
    dbRegime: TDBRadioGroup;
    dbSituacao: TDBRadioGroup;
    dbSabado: TDBRadioGroup;
    dbRaca: TDBRadioGroup;
    dbCAGED: TDBRadioGroup;
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mtRegistroCPF_CGCGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure dbCPFExit(Sender: TObject);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure PageControl1Change(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure dbLotacaoButtonClick(Sender: TObject);
    procedure mtRegistroCONTA_BANCARIAGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure pgFuncionarioChange(Sender: TObject);
    procedure dtsRegistroStateChange(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtRegistroCalcFields(DataSet: TDataSet);
    procedure mtRegistroPIS_IPASEPGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure mtRegistroIDAGENCIAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  protected
    { Protected declarations }
    TabDependente: TTabSheet;
    dbgDependente: TDBGrid;
    cdDependente: TClientDataSet;
    dsDependente: TDataSource;
  private
    { Private declarations }
    function GetFuncionario: Integer;
    procedure LerDependentes;
    function SalarioMensal(DataSet: TDataSet): Double;
    procedure Configura(DataSource1: TDataSource; Bairro, Cidade, UF,
      Pais: TDataSet);
    procedure ConfigRAIS( RadioControl: TDBRadioGroup;
                          TableName, FieldName: String; Where: String = '');
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
    procedure Iniciar; override;
  end;

procedure CriaFuncionario();

implementation

uses
  {$IFDEF FLIVRE}fbanco,{$ENDIF}
  ftext, fdb, fsuporte, flotacao, fcargo, ffind, futil, fbase;

{$R *.dfm}

procedure CriaFuncionario();
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmFuncionario) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmFuncionario.Create(Application) do
  try
    pvTabela := 'FUNCIONARIO';
    pvDataSetList[0] := cdFuncionario;
    AddTable( cdPessoa, 'PESSOA');
    Iniciar();
    Show;
  except
    on E: Exception do
      kErro( E.Message, 'ffuncionario.pas', 'CriaFuncionario()');
  end; // try

end;

constructor TFrmFuncionario.Create( AOwner: TComponent);
begin

  inherited;

  if kExistTable('F_DEPENDENTE') then
  begin

    cdDependente := TClientDataSet.Create(Self);

    with cdDependente do
    begin
      FieldDefs.Add( 'NOME', ftString, 50);
      FieldDefs.Add( 'NASCIMENTO', ftDate);
      FieldDefs.Add( 'SEXO', ftString, 1);
      FieldDefs.Add( 'TIPO', ftString, 10);
      FieldDefs.Add( 'INVALIDO_X', ftSmallint);
      CreateDataSet;
    end;

    dsDependente := TDataSource.Create(Self);

    with dsDependente do
    begin
      DataSet := cdDependente;
    end;

    TabDependente := TTabSheet.Create(Self);

    with TabDependente do
    begin
      PageControl := pgFuncionario;
      Caption     := 'Dependente&s';
    end;

    with TLabel.Create(Self) do
    begin
      Parent  := TabDependente;
      Align := alTop;
      Alignment := taCenter;
      Caption := 'Relação de Dependentes';
      Color := RxTitulo.Color;
      Font.Assign(RxTitulo.Font);
      Height := RxTitulo.Height;
      Layout := tlCenter;
    end;

    dbgDependente := TDBGrid.Create(Self);

    with dbgDependente do
    begin
      Parent := TabDependente;
      Align  := alClient;
      ParentColor := True;
      DataSource := dsDependente;
      Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
      Options := Options - [dgColumnResize];
      ReadOnly := True;
      OnDrawColumnCell := dbgRegistro.OnDrawColumnCell;
      OnTitleClick     := dbgRegistro.OnTitleClick;
    end;

    with dbgDependente.Columns.Add do
    begin
      FieldName := 'NOME';
      Title.Caption := 'Nome do Dependente';
      Width := 350;
    end;

    with dbgDependente.Columns.Add do
    begin
      FieldName := 'SEXO';
      Title.Caption := 'Sexo';
      Width := 50;
    end;

    with dbgDependente.Columns.Add do
    begin
      FieldName := 'NASCIMENTO';
      Title.Caption := 'Nascimento';
      Width := 100;
    end;

    with dbgDependente.Columns.Add do
    begin
      FieldName := 'TIPO';
      Title.Caption := 'Tipo(s)';
      Width := 100;
    end;

  end;  // F_DEPENDENTE

end;

procedure TFrmFuncionario.Iniciar;
var
  i: Integer;
  sCodigo, sNome: String;
  DataSet1, mtCivil, mtSexo, mtNatureza, mtUF, mtPais, mtBairro, mtCidade,
  mtSalario,  mtSindicato, mtInstrucao, cdGP, cdRecurso, cdNatureza: TClientDataSet;
  dsCivil, dsSexo, dsPais, dsUF, dsInstrucao, dsSindicato, dsSalario, dsGP,
  dsRecurso, dsNatureza: TDataSource;
begin

  pvSELECT :=
    'SELECT F.IDFUNCIONARIO, P.NOME, P.CPF_CGC,'+#13#10+
    'P.RG, P.NASCIMENTO, F.IDEMPRESA, L.NOME LOTACAO, C.NOME CARGO,'+#13#10+
    'B.NOME BANCO, A.NOME AGENCIA'#13#10+
    'FROM FUNCIONARIO F'+#13#10+
    'LEFT JOIN PESSOA P ON (P.IDEMPRESA = F.IDEMPRESA AND P.IDPESSOA = F.IDPESSOA)'#13#10+
    'LEFT JOIN F_LOTACAO L ON (L.IDEMPRESA = F.IDEMPRESA AND L.IDLOTACAO = F.IDLOTACAO)'#13#10+
    'LEFT JOIN F_CARGO C ON (C.IDEMPRESA = F.IDEMPRESA AND C.IDCARGO = F.IDCARGO)'#13#10+
    'LEFT JOIN BANCO B ON (B.IDBANCO = F.IDBANCO)'#13#10+
    'LEFT JOIN AGENCIA A ON (A.IDBANCO = F.IDBANCO AND A.IDAGENCIA = F.IDAGENCIA)';

  pvSELECT_NULL := 'WHERE (F.IDEMPRESA = #EMPRESA)';

  pvSELECT_COUNT := 'SELECT COUNT(*) FROM FUNCIONARIO'#13+
                    'WHERE IDEMPRESA = :EMPRESA';

  kNovaPesquisa( mtPesquisa, 'CODIGO',  'WHERE (F.IDEMPRESA = #EMPRESA) AND (F.IDFUNCIONARIO = #)');
  kNovaPesquisa( mtPesquisa, 'CPF/CGC', 'WHERE (F.IDEMPRESA = #EMPRESA) AND P.CPF_CGC LIKE '+QuotedStr('#%'));
  kNovaPesquisa( mtPesquisa, 'NOME',    'WHERE (F.IDEMPRESA = #EMPRESA) AND P.NOME LIKE '+QuotedStr('#%'));
  kNovaPesquisa( mtPesquisa, 'RG',      'WHERE (F.IDPESSOA = #EMPRESA) AND P.RG LIKE '+QuotedStr('#%'));

  kNovaPesquisa( mtPesquisa, 'TELEFONES',
    '(F.IDEMPRESA = #EMPRESA) AND ('#13#10+
    '(P.CELULAR LIKE '+QuotedStr('%#%')+') OR '+
    '(P.BIP LIKE '+QuotedStr('%#%')+') OR '+
    '(P.FAX LIKE '+QuotedStr('%#%')+') OR '+
    '(P.PRINCIPAL LIKE '+QuotedStr('%#%')+') OR '+
    '(P.COMPLEMENTAR LIKE '+QuotedStr('%#%')+') OR '+
    '(P.FONEFAX LIKE '+QuotedStr('%#%')+') )');

  kNovaColuna( mtColuna,  60,  6, 'ID');
  kNovaColuna( mtColuna, 300, 40, 'Nome do Funcionario');
  kNovaColuna( mtColuna,  90, 11, 'CPF');
  kNovaColuna( mtColuna,  90, 10, 'RG');
  kNovaColuna( mtColuna,  70, 10, 'Nascimto');

  // ** ESTADO CIVIL **

  mtCivil := TClientDataSet.Create(Self);
  dsCivil := TDataSource.Create(Self);
  dsCivil.DataSet := mtCivil;

  kSQLSelectFrom( mtCivil, 'ESTADO_CIVIL');

  mtCivil.IndexFieldNames := 'NOME';
  dbEstadoCivil.ListSource := dsCivil;
  dbEstadoCivil.KeyField := 'IDESTADO_CIVIL';
  dbEstadoCivil.ListField := 'NOME';
  dbEstadoCivil.DropDownRows := mtCivil.RecordCount;

  // ** SEXO **

  mtSexo := TClientDataSet.Create(Self);
  dsSexo := TDataSource.Create(Self);

  mtSexo.FieldDefs.Add('SEXO', ftString, 1);
  mtSexo.FieldDefs.Add('NOME', ftString, 15);
  mtSexo.CreateDataSet;

  mtSexo.AppendRecord( ['M', 'Masculino']);
  mtSexo.AppendRecord( ['F', 'Feminino']);

  dsSexo.DataSet := mtSexo;

  dbSexo.ListSource := dsSexo;
  dbSexo.KeyField := 'SEXO';
  dbSexo.ListField := 'NOME';

  mtNatureza := TClientDataSet.Create(Self);
  with mtNatureza do
  begin
    FieldDefs.Add('PESSOA', ftString, 1);
    FieldDefs.Add('NOME', ftString, 15);
    CreateDataSet;
    AppendRecord( ['F', 'Física']);
    AppendRecord( ['J', 'Jurídica']);
  end;

  mtBairro := TClientDataSet.Create(Self);
  mtCidade := TClientDataSet.Create(Self);

  mtPais := TClientDataSet.Create(Self);
  dsPais := TDataSource.Create(Self);
  dsPais.DataSet := mtPais;

  mtUF := TClientDataSet.Create(Self);
  dsUF := TDataSource.Create(Self);
  dsUF.DataSet := mtUF;

  Configura( dtsRegistro, mtBairro, mtCidade, mtUF, mtPais);

  mtUF.IndexFieldNames := 'NOME';
  mtPais.IndexFieldNames := 'NOME';

  with dbNaturalidade do
  begin
    ListSource := dsUF;
    ListField  := 'NOME';
    KeyField   := 'IDUF';
    DropDownRows := Min( mtUF.RecordCount, 10);
  end;

  with dbNacionalidade do
  begin
    ListSource := dsPais;
    ListField  := 'NOME';
    KeyField   := 'IDPAIS';
    DropDownRows := Min( mtUF.RecordCount, 10);
  end;

  // ******* INSTRUCAO ****************

  mtInstrucao := TClientDataSet.Create(Self);
  kSQLSelectFrom( mtInstrucao, 'F_INSTRUCAO');
  dsInstrucao := TDataSource.Create(Self);
  dsInstrucao.DataSet := mtInstrucao;

  with mtInstrucao do
  begin
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('NOME').AsString := FieldByName('IDINSTRUCAO').AsString+' - '+
                                      FieldByName('NOME').AsString;
      Post; Next;
    end;
  end;  // with

  with dbInstrucao do
  begin
    ListSource   := dsInstrucao;
    ListField    := 'NOME';
    KeyField     := 'IDINSTRUCAO';
    DropDownRows := mtInstrucao.RecordCount;
  end;

  // ******* SINDICATO ****************

  mtSindicato := TClientDataSet.Create(Self);
  mtSindicato.FieldDefs.Add('IDSINDICATO', ftString, 3);
  mtSindicato.FieldDefs.Add('NOME', ftString, 50);
  kSQLSelectFrom( mtSindicato, 'F_SINDICATO');

  with mtSindicato do
  begin
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('NOME').AsString := FieldByName('IDSINDICATO').AsString+' - '+
                                      FieldByName('NOME').AsString;
      Post; Next;
    end;
  end;  // with

  dsSindicato := TDataSource.Create(Self);
  dsSindicato.DataSet := mtSindicato;

  with dbSindicato do
  begin
    ListSource := dsSindicato;
    ListField  := 'NOME';
    KeyField   := 'IDSINDICATO';
    DropDownRows  := mtSindicato.RecordCount;
  end;

  // ******* SALARIO ****************

  mtSalario := TClientDataSet.Create(Self);
  kSQLSelectFrom( mtSalario, 'F_SALARIO');

  with mtSalario do
  begin
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('NOME').AsString := FieldByName('IDSALARIO').AsString+' - '+
                                      FieldByName('NOME').AsString;
      Post; Next;
    end;
  end;  // with

  dsSalario := TDataSource.Create(Self);
  dsSalario.DataSet := mtSalario;

  with dbTipoSalario do
  begin
    ListSource := dsSalario;
    ListField  := 'NOME';
    KeyField   := 'IDSALARIO';
    DropDownRows := mtSalario.RecordCount;
  end;

  // ********** GRUPO DE PAGAMENTO ********

  cdGP := TClientDataSet.Create(Self);
  cdGP.FieldDefs.Add('IDGP', ftString, 10);
  cdGP.FieldDefs.Add('NOME', ftString, 30);
  kSQLSelectFrom( cdGP, 'F_GRUPO_PAGAMENTO', -1, 'IDGE = '+IntToStr(pvGE));
  dsGP := TDataSource.Create(Self);
  dsGP.DataSet := cdGP;

  with dbGP do
  begin
    ListSource   := dsGP;
    ListField    := 'NOME';
    KeyField     := 'IDGP';
    DropDownRows := cdGP.RecordCount;
  end;

  if (dbGP.DropDownRows = 1) then
  begin
    lbGP.Enabled := False;
    dbGP.ParentColor := True;
    dbGP.Enabled := False;
  end;

  // ********** RECURSO ********

  cdRecurso := TClientDataSet.Create(Self);
  kOpenTable( cdRecurso, 'F_RECURSO');
  dsRecurso := TDataSource.Create(Self);
  dsRecurso.DataSet := cdRecurso;

  with dbRecurso do
  begin
    ListSource   := dsRecurso;
    ListField    := 'NOME';
    KeyField     := 'IDRECURSO';
    DropDownRows := cdRecurso.RecordCount;
    if (DropDownRows = 1) then
    begin
      lbRecurso.Enabled := False;
      ParentColor := True;
      Enabled := False;
    end;
  end;

  // ********** NATUREZA ********

  cdNatureza := TClientDataSet.Create(Self);
  kOpenTable( cdNatureza, 'F_NATUREZA_RENDIMENTO');
  dsNatureza := TDataSource.Create(Self);
  dsNatureza.DataSet := cdNatureza;

  with dbNaturezaRendimento do
  begin
    ListSource   := dsNatureza;
    ListField    := 'NATUREZA';
    KeyField     := 'IDNATUREZA';
    DropDownRows := cdNatureza.RecordCount;
    if (DropDownRows = 1) then
    begin
      lbNaturezaRendimento.Enabled := False;
      ParentColor := True;
      Enabled := False;
    end;
  end;

  ConfigRAIS( dbIDAdmissao, 'F_ADMISSAO', 'IDADMISSAO');
  ConfigRAIS( dbCAGED, 'F_CAGED', 'IDCAGED', 'TIPO = '+QuotedStr('A'));
  ConfigRAIS( dbRaca, 'F_RACA', 'IDRACA');
  ConfigRAIS( dbSituacao,'F_SITUACAO', 'IDSITUACAO');
  ConfigRAIS( dbRegime, 'F_REGIME', 'IDREGIME');
  ConfigRAIS( dbSabado, 'F_SABADO', 'IDSABADO');

  dbCAGED.Top := dbIDAdmissao.Top + dbIDAdmissao.Height + 5;

  i := dbCAGED.Top + dbCAGED.Height;

  dbRaca.Top    := dbCAGED.Top;
  dbRaca.Height := dbCAGED.Height;

  dbSituacao.Height := i - dbSituacao.Top;

  if (TabRAIS.ClientWidth > (dbSabado.Left + dbSabado.Width + 8) ) then
    dbSabado.Width := TabRAIS.ClientWidth - (dbSabado.Left + 8);

  dbRegime.Top := dbSabado.Top + dbSabado.Height + 5;
  dbRegime.Height := i - dbRegime.Top;
  dbRegime.Width  := dbSabado.Width;

  ConfigRAIS( dbVinculo, 'F_VINCULO', 'IDVINCULO');
  ConfigRAIS( dbIDFGTS, 'F_FGTS', 'IDFGTS');

  i := TabVinculo.ClientWidth;

  dbVinculo.Width := Trunc((i - 25) / 2);
  dbIDFGTS.Left := dbVinculo.Left + dbVinculo.Width + 5;
  dbIDFGTS.Width := dbVinculo.Width;

  dbVinculo.Height := TabVinculo.ClientHeight - dbVinculo.Left*2;
  dbIDFGTS.Height  := dbVinculo.Height;

  inherited Iniciar;

end;  // procedure Iniciar

procedure TFrmFuncionario.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('IDFUNCIONARIO').AsInteger  := 0;
    FieldByName('IDPESSOA').AsInteger       := 0;
    FieldByName('PESSOA').AsString          := 'F';   // Fisica
    FieldByName('IDESTADO_CIVIL').AsString  := '06';  // Outros
    FieldByName('SEXO').AsString            := 'M';
    FieldByName('IDNATURALIDADE').AsString  := 'PA';
    FieldByName('IDNACIONALIDADE').AsString := 'BRA';
    FieldByName('ADMISSAO').AsDateTime      := Date();
    FieldByName('IDADMISSAO').AsString      := '01';
    FieldByName('IDRACA').AsString          := '01';
    FieldByName('IDSABADO').AsString        := '01';
    FieldByName('IDSALARIO').AsString       := '01';  // Mensal
    FieldByName('IDSITUACAO').AsString      := '01';  // Normal
    FieldByName('IDTIPO').AsString          := '01';  // RJU
    FieldByName('IDVINCULO').AsString       := '10';  // TRABALHADOR URBANO
    FieldByName('IDFGTS').AsString          := '01';  // TRABALHADOR
    FieldByName('IDCAGED_ADMISSAO').AsString:= '10';  // PRIMEIRO EMPREGO
    FieldByName('IDINSTRUCAO').AsString     := '01';  // ANALFABETO
    FieldByName('IDRECURSO').AsString       := '00';  // PROPRIO
    FieldByName('IDGP').AsInteger           := dbGP.ListSource.DataSet.FieldByName('IDGP').AsInteger;
    FieldByName('IDNATUREZA').AsString      :=
      dbNaturezaRendimento.ListSource.DataSet.FieldByName('IDNATUREZA').AsString;    
  end;
end;

procedure TFrmFuncionario.FormCreate(Sender: TObject);
begin
  inherited;
  lbCodigo.Font.Style := [fsBold];
  dbCodigo.Font.Style := [fsBold];
  dbNome.Font.Color   := clBlue;
  dbNome.Font.Style   := [fsBold];
end;

procedure TFrmFuncionario.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  if pvAutoNumeracao then
  begin
    dbNome.SetFocus;
    lbCodigo.Enabled := False;
    dbCodigo.Enabled := False;
  end;
  if dbCodigo.Enabled then
    dbCodigo.SetFocus
  else
    dbNome.SetFocus;
end;

procedure TFrmFuncionario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando, bInserindo: Boolean;
  sText: String;
begin

  bEditando  := (pvDataSet.State in [dsInsert, dsEdit]);
  bInserindo := (pvDataSet.State in [dsInsert]);

  if (Key = VK_RETURN) and (ActiveControl = dbLotacao) and bEditando then
    PesquisaLotacao( dbLotacao.Text, pvEmpresa, pvDataSet, Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbCargo) and bEditando then
    PesquisaCargo( dbCargo.Text, pvEmpresa, pvDataSet, Key)

  // Request ID: 1730916 - Verificar código do novo funcionário; Close Data: 06-06-2006
  else if (Key = VK_RETURN) and (ActiveControl = dbCodigo) and
           bInserindo and (StrToInt(dbCodigo.Text) <> 0) then
  begin

    if ExisteFuncionario( pvEmpresa, StrToInt(dbCodigo.Text)) then
    begin
      kAviso('O código informado já existe. Informe um outro.');
      Key := 0;
    end;

  end

  {$IFDEF FLIVRE}
  else if (Key = VK_RETURN) and (ActiveControl = dbBanco) and bEditando then
    PesquisaBanco( dbBanco.Text, pvDataSet, Key)

  else if (Key = VK_F12) and (ActiveControl = dbBanco) then
    PesquisaBanco( '', pvDataSet, Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbAgencia) and bEditando then
    PesquisaAgencia( dbAgencia.Text, pvDataSet, Key)

  else if (Key = VK_F12) and (ActiveControl = dbAgencia) then
    PesquisaAgencia( '', pvDataSet, Key)

  else if bEditando and (Key = VK_RETURN) and
         ( (ActiveControl = dbMae) or
           (ActiveControl = dbNaturezaRendimento) or
           (ActiveControl = dbContaBancaria) or
           (ActiveControl = dbHomePage) or
           (ActiveControl = dbCAGED) or
           (ActiveControl.Parent = dbRegime) or
           (ActiveControl.Parent = dbIDFGTS) ) then
  begin
    Key := 0;
    pgFuncionario.SelectNextPage(True);

  end else if bEditando and (Key = VK_RETURN) and
              (ActiveControl.Parent = pnlPagamento) and
              (ActiveControl = kGetLastTabOrder(pnlPagamento)) then
  begin
    Key := 0;
    pgFuncionario.SelectNextPage(True);

  end else if (Key = VK_RETURN) and (ActiveControl = dbContaBancaria) and bEditando then
  begin

    sText := dbContaBancaria.Text;

    if (sText <> '') and (not kChecaConta( dbContaBancaria.Text)) then
      kErro('O número da conta bancária está inválida. Verifique !!!')
    else
      pgFuncionario.SelectNextPage(True);

    Key := 0;

  end else if (Key = VK_RETURN) and (ActiveControl = dbAdmissao) and bInserindo then
  begin

    ActiveControl := NIL;

    if not pvDataSet.FieldByName('ADMISSAO').IsNull and
           pvDataSet.FieldByName('FGTS_OPCAO').IsNull then
      pvDataSet.FieldByName('FGTS_OPCAO').AsDateTime := pvDataSet.FieldByName('ADMISSAO').AsDateTime;

    ActiveControl := dbAdmissao;

  end else if (Key = VK_RETURN) and (ActiveControl = dbOpcao) and bInserindo then
  begin

    ActiveControl := NIL;

    if not pvDataSet.FieldByName('FGTS_OPCAO').IsNull then
    begin
      pvDataSet.FieldByName('FGTS_X').AsInteger := 1;
      pvDataSet.FieldByName('OPTANTE_X').AsInteger := 1;
    end;

    ActiveControl := dbOpcao;

  end
  {$ENDIF};

  inherited;

end;

procedure TFrmFuncionario.mtRegistroCPF_CGCGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatCPF(Text);
end;

procedure TFrmFuncionario.dbCPFExit(Sender: TObject);
begin

  if (TDBEdit(Sender).DataSource.DataSet.State in [dsInsert,dsEdit]) and
     (not kChecaCPFCGC( TDBEdit(Sender).Text, False)) then
  begin
    TDBEdit(Sender).SelectAll;
    TDBEdit(Sender).SetFocus;
  end;

end;

procedure TFrmFuncionario.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if dbCodigo.Focused then
    dbNome.SetFocus;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
end;

procedure TFrmFuncionario.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
end;

procedure TFrmFuncionario.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
end;

procedure TFrmFuncionario.mtRegistroBeforePost(DataSet: TDataSet);
var
  iPessoa: Integer;
  sNome: String;
begin

  sNome := kRetira( Trim(DataSet.FieldByName('NOME').AsString), #32#32);

  if not kConfirme('Gravar o Funcionário '+QuotedStr(sNome)+' ?') then
  begin
    SysUtils.Abort;
    Exit;
  end;

  if (DataSet.FieldByName('IDFUNCIONARIO').AsInteger = 0) then
  begin
    iPessoa := kMaxCodigo( 'PESSOA', 'IDPESSOA', pvEmpresa);
    DataSet.FieldByName('IDFUNCIONARIO').AsInteger := iPessoa;
    DataSet.FieldByName('IDPESSOA').AsInteger      := iPessoa;
  end;

  DataSet.FieldByName('NOME').AsString := sNome;

  if (DataSet.FieldByName('IDBANCO').AsString = '000') then
    DataSet.FieldByName('IDAGENCIA').AsString := '00000';

  if (DataSet.FieldByName('IDAGENCIA').AsString = '00000') then
    DataSet.FieldByName('IDBANCO').AsString := '000';

  if (DataSet.FieldByName('IDAGENCIA').AsString = '00000') then
    DataSet.FieldByName('CONTA_BANCARIA').AsString := '';

  inherited;

end;

procedure TFrmFuncionario.PageControl1Change(Sender: TObject);
begin
  inherited;
  if (TPageControl(Sender).ActivePageIndex <> 0) then
    pgFuncionario.ActivePage := TabPessoal;
end;

procedure TFrmFuncionario.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Excluir o Funcionário '+
                   QuotedStr(DataSet.FieldByName('NOME').AsString)+' ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmFuncionario.dbLotacaoButtonClick(Sender: TObject);
{$IFDEF FLIVRE}
var
  Key: Word;
{$ENDIF}
begin
  {$IFDEF FLIVRE}
  if (Sender = dbLotacao) then
    PesquisaLotacao( '', pvEmpresa, pvDataSet, Key)
  else if (Sender = dbCargo) then
    PesquisaCargo( '', pvEmpresa, pvDataSet, Key);
  {$ENDIF}
end;

procedure TFrmFuncionario.mtRegistroCONTA_BANCARIAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
  begin
    if (Length(Text) < Sender.Size) then
      Text := PadLeftChar( Text, Sender.Size);
    Text := FormatMaskText( '999\.999\.999\-9;0', Text);
    while (Length(Text) > 0) and (Text[1] in [#32,'.','-']) do
      Text := Copy( Text, 2, Length(Text));

  end;
end;

procedure TFrmFuncionario.pgFuncionarioChange(Sender: TObject);
begin
  inherited;
  if Assigned(TabDependente) then
  begin
    if (TPageControl(Sender).ActivePage = TabDependente) then
      LerDependentes()
    else
      cdDependente.Close;
  end;
end;

function TFrmFuncionario.GetFuncionario: Integer;
begin
  Result := pvDataSet.FieldByName('IDFUNCIONARIO').AsInteger;
end;

procedure TFrmFuncionario.LerDependentes;
begin
  kOpenSQL( cdDependente, 'F_DEPENDENTE',
            'IDEMPRESA = :EMPRESA AND IDFUNCIONARIO = :FUNCIONARIO',
            [pvEmpresa, GetFuncionario]);
end;

procedure TFrmFuncionario.dtsRegistroStateChange(Sender: TObject);
var
  bEditando: Boolean;
begin
  inherited;
  bEditando := (TDataSource(Sender).DataSet.State in [dsInsert,dsEdit]);
  if Assigned(TabDependente) then
  begin
    if (TabDependente.PageControl.ActivePage = TabDependente) then
      TabDependente.PageControl.ActivePageIndex := 0;
    TabDependente.TabVisible := not bEditando;
  end;
end;

procedure TFrmFuncionario.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if Assigned(Column.Field.DataSet.FindField('INVALIDO_X')) and
     (Column.Field.DataSet.FindField('INVALIDO_X').AsInteger = 1) then
  begin
    TDBGrid(Sender).Canvas.Font.Color := clRed;
    TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
  end;
end;

function TFrmFuncionario.SalarioMensal(DataSet: TDataSet):Double;
var
  sTipoSalario: String;
  cSalario: Currency;
  iCargaHoraria: Integer;
begin

  cSalario := DataSet.FieldByName('SALARIO').AsCurrency;
  sTipoSalario := DataSet.FieldByName('IDSALARIO').AsString;
  iCargaHoraria := DataSet.FieldByName('CARGA_HORARIA').AsInteger;

  if sTipoSalario = '02' then  // Quizenalista
    cSalario := cSalario * 2

  else if sTipoSalario = '03' then  // Semanalista
    cSalario := cSalario * 4.286  { 30 / 7 = 4,286 }

  else if sTipoSalario = '04' then // Diarista
    cSalario := cSalario * 30

  else if sTipoSalario = '05' then // Horista
    cSalario := cSalario * iCargaHoraria;

  Result := RoundTo( cSalario, -2);

end;


procedure TFrmFuncionario.mtRegistroCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('SALARIO_MENSAL').AsCurrency := SalarioMensal(DataSet);
end;

procedure TFrmFuncionario.mtRegistroPIS_IPASEPGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatPIS(Text)
end;

procedure TFrmFuncionario.mtRegistroIDAGENCIAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatAgencia(Text);
end;

procedure TFrmFuncionario.Configura( DataSource1: TDataSource;
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

end;  // Configura

{08/05/2008 - allan-kardek }
procedure TFrmFuncionario.ConfigRAIS( RadioControl: TDBRadioGroup;
  TableName, FieldName: String; Where: String = '');
var
  DataSet1: TClientDataSet;
  sCodigo, sNome: String;
begin

  DataSet1 := TClientDataSet.Create(Self);

  try

    RadioControl.Items.Clear;
    RadioControl.Values.Clear;

    kOpenTable( DataSet1, TableName, Where);

    with DataSet1 do
    begin
      First;
      while not Eof do
      begin

        sCodigo := FieldByName(FieldName).AsString;
        sNome   := FieldByName('NOME').AsString;
        if Length(sNome) > 4 then
        begin
          sNome := AnsiLowerCase(sNome);
          sNome := UpperCase(sNome[1])+Copy(sNome, 2, MaxInt);
        end;

        RadioControl.Items.Add(sCodigo+' - '+sNome);
        RadioControl.Values.Add(sCodigo);

        Next;

      end;

      RadioControl.Height := (RecordCount * 30);

    end;

  finally
    DataSet1.Free;
  end;

end;

end.
