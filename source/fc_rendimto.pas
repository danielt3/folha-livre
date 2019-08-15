{
Projeto FolhaLivre - Folha de Pagamento Livre
Configurador do Comprovante de Rendimentos

Copyright (c) 2007 Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Histórico
---------

* 13/10/2007 - Primeira versão

}

unit fc_rendimto;

{$I flivre.inc}

interface

uses
  {$IFDEF MSWINDOWS}Windows,{$ENDIF}
  {$IFDEF LINUX}Xlib,{$ENDIF}
  {$IFDEF VCL}Graphics, Controls, Forms, DBCtrls, DBGrids,
  Grids, ExtCtrls, Mask, StdCtrls,{$ENDIF}
  {$IFDEF CLX}QGraphics, QControls, QForms, QDBCtrls, QDBGrids,
  QGrids, QExtCtrls, QMask, QStdCtrls,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, Variants, DB, DBClient;

type
  Tfrmc_rendimento = class(TForm)
    pnlControle: TPanel;
    btnNovo: TButton;
    btnExcluir: TButton;
    btnPrevisao: TButton;
    btnFechar: TButton;
    DataSet1: TClientDataSet;
    DataSet1IDGE: TIntegerField;
    DataSet1GRUPO: TSmallintField;
    DataSet1SUBGRUPO: TSmallintField;
    DataSet1DESCRICAO: TStringField;
    DataSet1IDEVENTO: TStringField;
    DataSet1IDTOTALIZADOR: TStringField;
    btnGravar: TButton;
    Panel1: TPanel;
    lbGrupo: TLabel;
    dbGrupo: TDBEdit;
    lbSubGrupo: TLabel;
    lbDescricao: TLabel;
    dbSubGrupo: TDBEdit;
    dbDescricao: TDBEdit;
    lbEvento: TLabel;
    dbEvento: TDBEdit;
    dbEvento2: TDBEdit;
    lbTotalizador: TLabel;
    dbTotalizador: TDBEdit;
    dbTotalizador2: TDBEdit;
    dbGrid1: TDBGrid;
    DataSet1EVENTO: TStringField;
    DataSet1TOTALIZADOR: TStringField;
    Label1: TLabel;
    btnCancelar: TButton;
    btnEditar: TButton;
    pnlGrupo: TPanel;
    DataSource1: TDataSource;
    lbInforme: TLabel;
    dbGE: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure DataSet1NewRecord(DataSet: TDataSet);
    procedure DataSet1BeforePost(DataSet: TDataSet);
    procedure DataSource1StateChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure DataSet1AfterInsert(DataSet: TDataSet);
    procedure dbGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnCancelarClick(Sender: TObject);
    procedure DataSet1AfterEdit(DataSet: TDataSet);
    procedure DataSet1BeforeEdit(DataSet: TDataSet);
    procedure DataSet1AfterCancel(DataSet: TDataSet);
    procedure DataSet1AfterPost(DataSet: TDataSet);
    procedure btnEditarClick(Sender: TObject);
    procedure DataSet1BeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
    pvGE: Integer;
    pvGENome, pvTabela: String;
    procedure Iniciar();
    procedure GetData;
  public
    { Public declarations }
  end;

procedure ConfigRendimento();

implementation

uses futil, fdb, fsuporte, ftext, fevento, ftotalizador, fgrupo_empresa, fcolor;

{$R *.dfm}

procedure ConfigRendimento();
begin

  with Tfrmc_rendimento.Create(Application) do
    try
      Iniciar();
      ShowModal();
    finally
      Free;
    end;

end;

procedure Tfrmc_rendimento.GetData();
var
  SQL: TStringList;
begin

  dbGE.Text  := 'Grupo de Empresas: ' + IntToStr(pvGE) + ' - ' + pvGENome;

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT C.*, E.NOME EVENTO, T.NOME TOTALIZADOR');
    SQL.Add('FROM F_COMPROVANTE_RENDIMENTO C');
    SQL.Add('LEFT JOIN F_EVENTO E ON (C.IDEVENTO = E.IDEVENTO)');
    SQL.Add('LEFT JOIN F_TOTALIZADOR T ON (C.IDTOTALIZADOR = T.IDTOTAL)');
    SQL.Add('WHERE C.IDGE = :GE');
    SQL.Add('ORDER BY C.GRUPO, C.SUBGRUPO');
    SQL.EndUpdate;

    kOpenSQL( DataSet1, SQL.Text, [pvGE]);

  finally
    SQL.Free;
  end;

end;

procedure Tfrmc_rendimento.Iniciar();
begin
  GetData();
end;

procedure Tfrmc_rendimento.FormCreate(Sender: TObject);
var
  i: Integer;
begin

   pvGE := kGrupoEmpresa();
   pvGENome := kGetFieldTable('F_GRUPO_EMPRESA', 'NOME', 'IDGE = '+IntToStr(pvGE));

   pvTabela := 'F_COMPROVANTE_RENDIMENTO';
   Ctl3D := False;
   Color := kGetColor();

   pnlGrupo.Color := $007B9FC4;

   with Label1 do
   begin
     Alignment := taCenter;
     Font.Color := clRed;
     Font.Style := [fsBold];
   end;

   with dbGrid1 do
   begin
     ParentColor := True;
     DataSource := DataSource1;
     Columns.BeginUpdate;
     with Columns.Add do
     begin
       FieldName := 'GRUPO';
       Alignment := taCenter;
       Title.Caption := 'Grupo';
       Title.Alignment := taCenter;
       Width := 60;
     end;
     with Columns.Add do
     begin
       FieldName := 'SUBGRUPO';
       Alignment := taCenter;
       Title.Caption := 'SubGrupo';
       Title.Alignment := taCenter;
       Width := 60;
     end;
     with Columns.Add do
     begin
       FieldName := 'DESCRICAO';
       Title.Caption := 'Descrição do Item';
       Title.Alignment := taCenter;
       Width := 250;
     end;
     with Columns.Add do
     begin
       FieldName := 'IDEVENTO';
       Alignment := taRightJustify;
       Title.Caption := 'Evento';
       Title.Alignment := taCenter;
       Width := 60;
     end;
     with Columns.Add do
     begin
       FieldName := 'IDTOTALIZADOR';
       Alignment := taRightJustify;
       Title.Caption := 'Totalizador';
       Title.Alignment := taCenter;
       Width := 60;
     end;
     Options := [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect];
     OnDrawColumnCell := dbGrid1DrawColumnCell;
     Tag := 1;
   end;

   i := kMaxWidthColumn( dbGrid1.Columns, Canvas.TextWidth('W') / 11);

   dbGrid1.Columns[2].Width := dbGrid1.Columns[2].Width + (Self.ClientWidth-i);

   Panel1.ParentColor := True;

   dbGE.Color := Color;
   dbGE.Font.Size := dbGE.Font.Size*2;
   dbGE.Font.Color := clBlue;
   dbGE.Font.Style := [fsBold];
   dbGE.Width := pnlGrupo.ClientWidth - (dbGE.Left*2);

   lbInforme.Font.Style := [fsBold];

end;

procedure Tfrmc_rendimento.DataSet1NewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDGE').AsInteger := pvGE;
    FieldByName('IDEVENTO').AsInteger := 0;
    FieldByName('IDTOTALIZADOR').AsInteger := 0;
  end;
end;

procedure Tfrmc_rendimento.DataSet1BeforePost(DataSet: TDataSet);
begin

  with DataSet do
  begin

    if (FieldByName('GRUPO').AsInteger = 0) then
      raise Exception.Create('O Grupo não pode ser 0 (zero). Informe outro valor.');

    if (FieldByName('SUBGRUPO').IsNull) then
      FieldByName('SUBRUPO').AsInteger := 0;

    if (FieldByName('SUBGRUPO').AsInteger = 0) then
    begin
      FieldByName('IDEVENTO').AsInteger := 0;
      FieldByName('IDTOTALIZADOR').AsInteger := 0;
    end;

    if (FieldByName('IDEVENTO').AsInteger <> 0) and
       (FieldByName('IDTOTALIZADOR').AsInteger <> 0) then
    begin
      FieldByName('IDTOTALIZADOR').AsInteger := 0;
      FieldByName('TOTALIZADOR').AsString    := '';
    end;

  end;

  if not kSQLCache( DataSet, pvTabela, DataSet.Fields) then
    SysUtils.Abort;

end;

procedure Tfrmc_rendimento.DataSource1StateChange(Sender: TObject);
begin
  kControlDataSet(Self, DataSet1);
end;

procedure Tfrmc_rendimento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_F4) and (Shift = []) and
     (DataSet1.State = dsBrowse) and FindGrupoEmpresa('*', pvGE, pvGENome) then
  begin
    Key := 0;
    GetData();

  end else if (Key = VK_RETURN) and (ActiveControl = dbEvento) and
     (DataSet1.State in [dsInsert,dsEdit]) and (dbEvento.Text = '0') then
    DataSet1.FieldByName('EVENTO').AsString := ''

  else if (Key = VK_RETURN) and (ActiveControl = dbEvento) and
     (DataSet1.State in [dsInsert,dsEdit]) then
    FindEvento( dbEvento.Text, DataSet1, Key)

  else if (Key = VK_F12) and (ActiveControl = dbEvento) and
     (DataSet1.State in [dsInsert,dsEdit]) then
    FindEvento( '', DataSet1, Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbTotalizador) and
     (DataSet1.State in [dsInsert,dsEdit]) and (dbTotalizador.Text = '0') then
    DataSet1.FieldByName('TOTALIZADOR').AsString := ''

  else if (Key = VK_RETURN) and (ActiveControl = dbTotalizador) and
     (DataSet1.State in [dsInsert,dsEdit]) then
    FindTotalizador( dbTotalizador.Text, DataSet1, Key)

  else if (Key = VK_F12) and (ActiveControl = dbTotalizador) and
     (DataSet1.State in [dsInsert,dsEdit]) then
    FindTotalizador( '', DataSet1, Key);

  kKeyDown(Self, Key, Shift);

end;

procedure Tfrmc_rendimento.btnNovoClick(Sender: TObject);
begin
  DataSet1.Append;
end;

procedure Tfrmc_rendimento.btnGravarClick(Sender: TObject);
begin
  DataSet1.Post;
end;

procedure Tfrmc_rendimento.btnExcluirClick(Sender: TObject);
begin
  DataSet1.Delete;
end;

procedure Tfrmc_rendimento.DataSet1AfterInsert(DataSet: TDataSet);
begin
  dbGrupo.SetFocus;
end;

procedure Tfrmc_rendimento.dbGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column,
                   State, TWinControl(Sender).Focused);
  if Column.Field.DataSet.FieldByName('SUBGRUPO').AsInteger = 0 then
    TDBGrid(Sender).Canvas.Font.Color := clRed;  
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

procedure Tfrmc_rendimento.btnCancelarClick(Sender: TObject);
begin
  DataSet1.Cancel;
end;

procedure Tfrmc_rendimento.DataSet1AfterEdit(DataSet: TDataSet);
begin
  dbDescricao.SetFocus;
end;

procedure Tfrmc_rendimento.DataSet1BeforeEdit(DataSet: TDataSet);
begin
  lbGrupo.Enabled := False;
  dbGrupo.Enabled := False;
  lbSubGrupo.Enabled := False;
  dbSubGrupo.Enabled := False;
end;

procedure Tfrmc_rendimento.DataSet1AfterCancel(DataSet: TDataSet);
begin
  lbGrupo.Enabled := True;
  dbGrupo.Enabled := True;
  lbSubGrupo.Enabled := True;
  dbSubGrupo.Enabled := True;
end;

procedure Tfrmc_rendimento.DataSet1AfterPost(DataSet: TDataSet);
begin
  DataSet.AfterCancel(DataSet);
end;

procedure Tfrmc_rendimento.btnEditarClick(Sender: TObject);
begin
  DataSet1.Edit;
end;

procedure Tfrmc_rendimento.DataSet1BeforeDelete(DataSet: TDataSet);
begin

  if not kConfirme('Excluir o item "'+
                   DataSet.FieldByName('DESCRICAO').AsString+' ?') then
    SysUtils.Abort;

  if not kSQLDelete( DataSet, pvTabela, DataSet.Fields) then
    SysUtils.Abort;

end;

end.
