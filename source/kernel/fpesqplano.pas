unit fpesqplano;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, DBGrids, DB, Mask, dbClient, MidasLib;

type
  TFrmPesqPlano = class(TForm)
    dbgPlano: TDBGrid;
    dts: TDataSource;
    mt: TClientDataSet;
    mtIDPLANO: TIntegerField;
    mtNOME: TStringField;
    mtCODIGO: TStringField;
    mtTIPO: TStringField;
    mtCODIGO2: TStringField;
    mtNOME2: TStringField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure mtCalcFields(DataSet: TDataSet);
    procedure dbgPlanoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgPlanoTitleClick(Column: TColumn);
  private
    { Private declarations }
    pvConfirmado: Boolean;
    pvSintetico: Boolean;
    pvNeutro: Boolean;
    pvPesquisa: String;
    pvEmpresa: Integer;
    procedure PesquisaConta( Primeiro: Boolean);
  public
    { Public declarations }
  end;

function kFindPlano(Empresa: Integer; const Pesquisa: String; var Plano: Integer;
  var Codigo, Nome, Tipo: String; Sintetico: Boolean = False;
  Neutro: Boolean = False):Boolean;

procedure kPesquisaPlano(Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word;
  const Sintetico: Boolean = False; const Neutro: Boolean = False);

implementation

uses fdb, fsuporte, ftext;

{$R *.DFM}

procedure kPesquisaPlano(Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word;
  const Sintetico: Boolean = False; const Neutro: Boolean = False);
var
  iCodigo: Integer;
  sNome, sClasse, sTipo: String;
begin

  if kFindPlano( Empresa, Pesquisa, iCodigo, sClasse, sNome, sTipo,
                 Sintetico, Neutro) then
  begin
    if (DataSet.State in [dsInsert,dsEdit]) then
    begin
      if Assigned(DataSet.FindField('IDPLANO')) then
        DataSet.FieldByName('IDPLANO').AsInteger := iCodigo;
      if Assigned(DataSet.FindField('PLANO')) then
        DataSet.FieldByName('PLANO').AsString := sNome;
    end;
  end else
  begin
    kErro('Conta não encontrada. Tente novamente !!!');
    Key := 0;
  end;

end;

function kFindPlano( Empresa: Integer; const Pesquisa: String;
  var Plano: Integer; var Codigo, Nome, Tipo: String;
  Sintetico: Boolean = False; Neutro: Boolean = False):Boolean;
var
  Frm: TFrmPesqPlano;
  iQtde: Integer;
  sTipo, sPesq: String;
begin

  Plano  := 0;
  Codigo := '';
  Nome   := '';
  sPesq  := Pesquisa;
  Result := False;

  if (Length(sPesq) = 0) then
  begin
    sPesq := '*';
    if not InputQuery( 'Pesquisa Contas do Plano',
                       'Informe um texto para pesquisar', sPesq) then Exit;
  end;

  if (Length(sPesq) = 0) then
    Exit;

  Frm := TFrmPesqPlano.Create(Application);

  try

    with Frm do
    begin

      pvEmpresa := Empresa;
      pvPesquisa := UpperCase(sPesq);
      pvConfirmado := False;
      pvSintetico := Sintetico;
      pvNeutro := Neutro;

      PesquisaConta(True);

      iQtde := mt.RecordCount;
      sTipo := mt.FieldByName('TIPO').AsString;

      if (iQtde = 1) then
      begin
        if (sTipo = 'S') then
          pvConfirmado := Sintetico {aceita sintetico}
        else if (sTipo = 'A') then
          pvConfirmado := True;
      end else if (iQtde > 1) then
      begin
        PesquisaConta(False);
        ShowModal;
      end;

      if pvConfirmado then
      begin
        Plano  := mt.FieldByName('IDPLANO').AsInteger;
        Codigo := mt.FieldByName('CODIGO').AsString;
        Nome   := mt.FieldByName('NOME').AsString;
        Tipo   := mt.FieldByName('TIPO').AsString;
      end;

      Result := pvConfirmado;

    end;

  finally
    Frm.Free;
  end;

end;

procedure TFrmPesqPlano.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and
     ( (mt.FieldByName('TIPO').AsString  = 'A') or pvSintetico) then
  begin
    pvConfirmado := True;
    Close;
  end else if (Key = VK_ESCAPE) then
    Close;
end;

procedure TFrmPesqPlano.FormCreate(Sender: TObject);
begin
  Ctl3D := False;
  Color := $00E0E9EF;
end;

procedure TFrmPesqPlano.PesquisaConta(Primeiro: Boolean);
var
  sWhere: String;
  SQL: TStringList;
begin

  pvPesquisa := kSubstitui( pvPesquisa, '*', '%');

  if kNumerico(pvPesquisa) then
    sWhere := 'IDPLANO = '+pvPesquisa
  else
    sWhere := 'NOME LIKE '+QuotedStr(pvPesquisa+'%');

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT * FROM PLANO_CONTA');
    SQL.Add('WHERE IDEMPRESA = '+IntToStr(pvEmpresa)+' AND');

    if not pvNeutro then
      SQL.Add(' IDPLANO > 0 AND');

    if Primeiro then
      SQL.Add(sWhere)
    else
      SQL.Add('  (TIPO = '+QuotedStr('S')+' OR '+sWhere+')');
    SQL.Add('ORDER BY CODIGO');
    SQL.EndUpdate;

    kOpenSQL( mt, SQL.Text);

    mt.Locate('TIPO', 'A', []);

  finally
    SQL.Free;
  end;

end;

procedure TFrmPesqPlano.mtCalcFields(DataSet: TDataSet);
var
  Texto: String;
  nPos: Integer;
begin

  with DataSet do
  begin

    FieldByName('NOME2').AsString :=
      StringOfChar( #32, Length(FieldByName('CODIGO').AsString)*2)+
        FieldByName('NOME').AsString;

    Texto := FieldByName('CODIGO').DisplayText;
    nPos  := Pos( #32, Texto);

    if (nPos > 0) then
      Texto := Copy( Texto, 1, nPos-1);

    if (Length(Texto) > 0) and (Texto[Length(Texto)] = '.') then
      Texto := Copy( Texto, 1, Length(Texto)-1);

    FieldByName('CODIGO2').AsString := Texto;

  end;  // with DataSet do begin

end;

procedure TFrmPesqPlano.dbgPlanoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  with TDBGrid(Sender) do
  begin
    if Length( Column.Field.DataSet.FieldByName('CODIGO').AsString) = 1 then
      Canvas.Font.Style := Canvas.Font.Style + [fsBold];
    if Column.Field.DataSet.FieldByName('TIPO').AsString = 'S' then
       Canvas.Font.Color := clRed
    else
       Canvas.Font.Color := clBlack;
  end;  // with
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmPesqPlano.dbgPlanoTitleClick(Column: TColumn);
begin
  kTitleClick( Column.Grid, Column, NIL);
end;

end.
