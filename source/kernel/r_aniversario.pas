unit r_aniversario;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}Qt, QGraphics, QControls, QForms, QStdCtrls, QExtCtrls,{$ENDIF}
  {$IFDEF VCL}Windows, Graphics, Controls, Forms, StdCtrls, ExtCtrls,{$ENDIF}
  SysUtils, Classes, DB, DBClient, MidasLib;

type
  TFrmAniversario = class(TForm)
  protected
    { Private declarations }
    Label1: TLabel;
    cbMes: TComboBox;
    btnImprimir: TButton;
    btnVisualizar: TButton;
    btnFechar: TButton;
    dbEnviar: TCheckBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  public
    { Public declarations }
    constructor CreateNew( AOwner: TComponent; Dummy: Integer = 0); override;
  end;

procedure CriaAniversario;
function PrintAniversario( Ano, Mes: Word; Tipo, RespeitarEnviar, Imprimir: Boolean):Boolean;

implementation

uses fdb, fdata, fdepvar, fprint, ftext, fsuporte, DateUtils;

procedure CriaAniversario;
var
  i: Integer;
  bEnviar, bImprimir: Boolean;
  Form: TFrmAniversario;
begin

  Form := TFrmAniversario.CreateNew(Application);

  with Form do
  try

    i := ShowModal;

    if (i <> idCancel) then
    begin
      bEnviar := False;
      bImprimir := ( i = idOK);
      if Assigned(dbEnviar) then bEnviar := dbEnviar.Checked;
      PrintAniversario( YearOf(Date), cbMes.ItemIndex+1, True, bEnviar, bImprimir);
    end;
  finally
    Free;
  end;

end;

function PrintAniversario( Ano, Mes: Word; Tipo, RespeitarEnviar, Imprimir: Boolean):Boolean;
var
  sTitulo, sSubTitulo: String;
  i: Integer;
  Dep: TDeposito;
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  Result  := True;
  sTitulo := 'ANIVERSARIANTES DE '+FormatDateTime( 'MMMM', EncodeDate( Ano, Mes, 1));

  Dep := TDeposito.Create;
  SQL := TStringList.Create;

  DataSet1 := TClientDataSet.Create(NIL);

  try try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  EXTRACT( DAY FROM P.NASCIMENTO), P.IDPESSOA, P.NOME,');
    SQL.Add('  P.NASCIMENTO, P.IDPESSOA AS IDADE,');
    SQL.Add('  P.PRINCIPAL, P.CELULAR, P.EMAIL');
    if Tipo then
      SQL.Add(' ,T.NOME TIPO');
    SQL.Add('FROM');
    SQL.Add('  PESSOA P');
    if Tipo then
      SQL.Add(' , PESSOA_TIPO T');
    SQL.Add('WHERE');
    SQL.Add('  EXTRACT( MONTH FROM P.NASCIMENTO) = :MES');
    if RespeitarEnviar and kIsField( 'PESSOA', 'ENVIAR_CORRESPONDENCIA_X') then
      SQL.Add('  AND P.ENVIAR_CORRESPONDENCIA_X = 1');
    if Tipo then
      SQL.Add('  AND T.IDTIPO = P.IDTIPO');
    SQL.Add('ORDER BY');
    SQL.Add('  1, 3');
    SQL.EndUpdate;

    kOpenSQL( DataSet1, SQL.Text, [Mes]);

    with DataSet1 do
    begin

      First;
      while not Eof do
      begin
        Edit;
        if FieldByName('PRINCIPAL').AsString = '' then
          FieldByName('PRINCIPAL').AsString := FieldByName('CELULAR').AsString;
        FieldByName('IDADE').AsInteger := kIdade( FieldByName('NASCIMENTO').AsDateTime, Date);
        Post;
        Next;
      end;

      for i := 1 to Fields.Count - 1 do
      begin

        Fields[i].Tag := 1;

        if (Fields[i].FieldName = 'IDPESSOA') then
        begin
          Fields[i].DisplayLabel := 'CODIGO;';
          Fields[i].DisplayWidth := 10;

        end else if (Fields[i].FieldName = 'NOME') then
        begin
          Fields[i].DisplayLabel := 'NOME DA PESSOA;TOTAL DE PESSOAS -> %s';
          Fields[i].DisplayWidth := 40;

        end else if (Fields[i].FieldName = 'NASCIMENTO') then
        begin
          Fields[i].DisplayLabel := 'NASCIMENTO;';
          Fields[i].DisplayWidth := 10;

        end else if (Fields[i].FieldName = 'IDADE') then
        begin
          Fields[i].DisplayWidth := Length( Fields[i].DisplayLabel);
          Fields[i].DisplayLabel := Fields[i].DisplayLabel+';';

        end else if (Fields[i].FieldName = 'PRINCIPAL') then
        begin
          Fields[i].DisplayLabel := 'TELEFONE;';
          Fields[i].DisplayWidth := 15;
        end else if (Fields[i].FieldName = 'EMAIL') then
        begin
          Fields[i].DisplayLabel := 'EMAIL;';
          Fields[i].DisplayWidth := 30;
        end else if (Fields[i].FieldName = 'TIPO') then
        begin
          Fields[i].DisplayLabel := 'TIPO;';
          Fields[i].DisplayWidth := 6;
        end else
          Fields[i].Tag := 0;
      end;

    end;

    Dep.SetDeposito('TITULO', AnsiUpperCase(sTitulo));
    Dep.SetDeposito('SUBTITULO', sSubTitulo);
    Dep.SetDeposito('MARGEM_DIREITA', 132);
    Dep.SetDeposito('COMPRIMIDO', True);

    kPrint( DataSet1, Imprimir, Dep);

  except
    on E:Exception do
    begin
      kErro( E.Message, '.', 'PrintAniversario()');
      Result := False;
    end;
  end;
  finally
    SQL.Free;
    Dep.Free;
    DataSet1.Free;
  end;

end;

constructor TFrmAniversario.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited;

  BorderStyle := bsDialog;
  Caption := 'Relação de aniversariantes';
  Color := clBtnFace;
  KeyPreview := True;
  Position := poScreenCenter;
  OnKeyDown := FormKeyDown;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Self;
    Left    := 15;
    Top     := 10;
    Caption := 'Escolha um mês'
  end;

  cbMes := TComboBox.Create(Self);

  with cbMes do
  begin
   Parent := Self;
   Left   := Label1.Left;
   Top    := Label1.Top + Label1.Height + 5;
   Width  := 100;
   Style := csDropDownList;
   Items.Add('Janeiro');
   Items.Add('Fevereiro');
   Items.Add('Março');
   Items.Add('Abril');
   Items.Add('Maio');
   Items.Add('Junho');
   Items.Add('Julho');
   Items.Add('Agosto');
   Items.Add('Setembro');
   Items.Add('Outubro');
   Items.Add('Novembro');
   Items.Add('Dezembro');
   ItemIndex := 0;
  end;

  if kIsField('PESSOA', 'ENVIAR_CORRESPONDENCIA_X') then
  begin
    dbEnviar := TCheckBox.Create(Self);
    with dbEnviar do
    begin
      Parent   := Self;
      Caption  := 'Respeitar "Enviar Correspondência"';
      Width    := 250;
      Left     := cbMes.Left + cbMes.Width + 10;
      Top      := cbMes.Top;
    end;
  end;

  btnImprimir := TButton.Create(Self);

  with btnImprimir do
  begin
    Parent      := Self;
    Left        := Label1.Left;
    Top         := cbMes.Top + cbMes.Height + 25;
    Width       := 100;
    Caption     := '&Imprimir';
    ModalResult := mrOk;
  end;

  btnVisualizar := TButton.Create(Self);

  with btnVisualizar do
  begin
    Parent := Self;
    Top := btnImprimir.Top;
    Left := btnImprimir.Left + btnImprimir.Width + 15;
    Width := btnImprimir.Width;
    Caption := '&Visualizar';
    ModalResult := mrNo;
  end;

  btnFechar := TButton.Create(Self);

  with btnFechar do
  begin
    Parent := Self;
    Top := btnVisualizar.Top;
    Left := btnVisualizar.Left + btnVisualizar.Width + 15;
    Width := btnVisualizar.Width;
    Caption := '&Fechar';
    ModalResult := mrCancel;
  end;

  ClientHeight := btnFechar.Top + btnFechar.Height + 10;
  ClientWidth  := btnFechar.Left + btnFechar.Width + 10;
  
end;

procedure TFrmAniversario.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  kKeyDown(Self, Key, Shift);
end;

end.
