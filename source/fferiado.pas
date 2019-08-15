{
Projeto FolhaLivre - Folha de Pagamento Livre
fferiado - Cadastro de Feriados

Copyright (c) 2006, Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br

= Historico das mudanças =

* 09/09/2006 - Nova interface usando TStringAlignGrid
* 01/09/2006 - Primeira versão
}

unit fferiado;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls,
  ToolWin, ExtCtrls, DBCtrls, Mask, Buttons,
  {$ENDIF}
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QComCtrls, QStdCtrls,
  QExtCtrls, QDBCtrls, QMask, QButtons,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, Math, Grids, DBGrids, Aligrid;

type
  TFrmFeriado = class(TForm)
  private
    { Private declarations }
    pnlTitulo: TPanel;
    pvYear: Word;
    c_1: TStringAlignGrid;
    c_2: TStringAlignGrid;
    c_3: TStringAlignGrid;
    c_4: TStringAlignGrid;
    c_5: TStringAlignGrid;
    c_6: TStringAlignGrid;
    c_7: TStringAlignGrid;
    c_8: TStringAlignGrid;
    c_9: TStringAlignGrid;
    c_10: TStringAlignGrid;
    c_11: TStringAlignGrid;
    c_12: TStringAlignGrid;
    procedure ClearCalendary(Calendary: TStringAlignGrid);
    procedure MontaCalendary(Calendary: TStringAlignGrid;
                             CalendaryPrev: TStringAlignGrid;
                             CalendaryTop: TStringAlignGrid);
    procedure MontaAno;
    procedure FecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure c_1Enter(Sender: TObject);
    procedure c_1Exit(Sender: TObject);
    procedure c_1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure CopiarFeriado(Sender: TObject);
    procedure YearNext(Sender: TObject);
    procedure YearPrior(Sender: TObject);
  protected
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

procedure CriaFeriado();

implementation

uses ftext, fdb, fdeposito, fsystem, fsuporte, cDateTime, DateUtils, fcolor;

procedure CriaFeriado();
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmFeriado) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmFeriado.CreateNew(Application) do
  try
    MontaAno();
    Show;
  except
    on E: Exception do
      kErro( E.Message, 'fferiado.pas', 'CriaFeriado()');
  end;

end;

procedure TFrmFeriado.FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFeriado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_PRIOR) then
    YearPrior(Sender)
  else if (Key = VK_NEXT) then
    YearNext(Sender)
  else
    kKeyDown( Self, Key, Shift);
end;

procedure TFrmFeriado.ClearCalendary(Calendary: TStringAlignGrid);
var
  l, c: Integer;
begin

  Calendary.RowCount := 7;
  Calendary.ColCount := 7;

  Calendary.FixedCols := 0;
  Calendary.FixedRows := 1;

  Calendary.Alignment := alCenter;

  // Coloca a primeira linha com a fonte em Negrito
  //Calendary.FixedRowFont[0].Style := [fsBold];

  // Seta o texto da primeira linha (cabeçalho)
  Calendary.Cells[0,0] := 'Dom';
  Calendary.Cells[1,0] := 'Seg';
  Calendary.Cells[2,0] := 'Ter';
  Calendary.Cells[3,0] := 'Qua';
  Calendary.Cells[4,0] := 'Qui';
  Calendary.Cells[5,0] := 'Sex';
  Calendary.Cells[6,0] := 'Sab';

  Calendary.Options := Calendary.Options - [goFixedVertLine];
  Calendary.Options := Calendary.Options + [goDrawFocusSelected];

  Calendary.DefaultColWidth  := 25;
  Calendary.DefaultRowHeight := 16;

  Calendary.ShowCellHints := True;

  Calendary.Height := (Calendary.DefaultRowHeight * Calendary.RowCount) + Calendary.RowCount + 2;
  Calendary.Width := (Calendary.DefaultColWidth * Calendary.ColCount) + Calendary.ColCount + 1;

  { Limpa todo o conteúdo do Grid (apenas da segunda linha para baixo)
    Colocando as cores, estilo de texto e hints zerados. }

  for l := 1 to Calendary.RowCount - 1 do
    for c := 0 to Calendary.ColCount -1 do
    begin
      Calendary.Cells[c,l] := '';
      Calendary.CellFont[c,l].Style := [];
      Calendary.CellFont[c,l].Color := clWindowText;
      Calendary.ColorCell[c,l] := clWindow;
      Calendary.HintCell[c,l] := '';
    end;

  Calendary.SelectedCellColor := clWhite;
  Calendary.SelectedFontColor := clNone;

  Calendary.OnEnter := c_1Enter;
  Calendary.OnExit := c_1Exit;

  Calendary.OnDblClick := c_1DblClick;

end;

procedure TFrmFeriado.MontaCalendary(Calendary: TStringAlignGrid;
  CalendaryPrev: TStringAlignGrid; CalendaryTop: TStringAlignGrid);
var
  cdFeriado: TClientDataSet;
  MonthLabel: TComponent;
  dFirstDay, dLastDay: TDateTime;
  iWeekDay, iLin, iMonth: Integer;
begin

  if Assigned(CalendaryPrev) then
  begin
    Calendary.Top := CalendaryPrev.Top;
    Calendary.Left := CalendaryPrev.Left + CalendaryPrev.Width + 10;
  end;

  if Assigned(CalendaryTop) then
  begin
    Calendary.Top := CalendaryTop.Top + CalendaryTop.Height + 25;
    Calendary.Left := CalendaryTop.Left;
  end;

  cdFeriado := TClientDataSet.Create(NIL);

  try

    iMonth := Calendary.Tag;

    // Obtém o mês para setar o label no alto do calendário

    dFirstDay := EncodeDate(pvYear, iMonth, 1);
    dLastDay := LastDayOfMonth(dFirstDay);

    if not kOpenSQL(cdFeriado, 'SELECT * FROM FERIADO'#13+
                    'WHERE DATA BETWEEN :DATA1 AND :DATA2',
                    [dFirstDay, dLastDay]) then
      Exit;

    // Realiza a configuração padrão do calendário
    ClearCalendary(Calendary);

    MonthLabel := FindComponent('lbl_'+IntToStr(iMonth));

    if not Assigned(MonthLabel) then
      MonthLabel := TLabel.Create(Self);

    with TLabel(MonthLabel) do
    begin
      Parent := Self;
      Caption := AnsiUpperCase(FormatDateTime('mmmm - yyyy', dFirstDay));
      Font.Size := Self.Font.Size + 1;
      Font.Style := Font.Style + [fsBold];
      Top := Calendary.Top - 15;
      Left := Calendary.Left;
    end;

    iLin := 1;

    while (dFirstDay <= dLastDay) do
    begin

      iWeekDay := DayOfWeek(dFirstDay);

      // Escreve o dia na celula
      Calendary.Cells[iWeekDay-1, iLin] := FormatFloat('00;00', DayOf(dFirstDay));

      // Se for o dia de hoje, coloco em negrito
      if (dFirstDay = Date) then
        Calendary.CellFont[iWeekDay-1, iLin].Style := [fsBold];

      // Se for domingo coloco em vermelho
      if (iWeekDay = 1) then
        Calendary.CellFont[iWeekDay-1, iLin].Color := clRed;

      // Se for feriado coloco em vermelho
      if cdFeriado.Locate('DATA', dFirstDay, []) then
      begin
        Calendary.CellFont[iWeekDay-1, iLin].Color := clRed;
        Calendary.ColorCell[iWeekDay-1, iLin] := clGradientActiveCaption;
        Calendary.HintCell[iWeekDay-1, iLin] := cdFeriado.FieldByName('DESCRICAO').AsString;
      end;

      // Proximo dia
      dFirstDay := AddDays(dFirstDay, 1);

      // Se o dia da semana encontrado for menor que o dia da semana
      // da data anterior é sinal que devemos mudar de linha...
      if DayOfWeek(dFirstDay) < iWeekDay then
        Inc(iLin);

    end;

  finally
    cdFeriado.Free;
  end;

end;

procedure TFrmFeriado.MontaAno;
begin

  c_1.Top := PnlTitulo.Top + PnlTitulo.Height + 25;
  c_1.Left := 10;
  MontaCalendary(c_1, NIL, NIL);
  MontaCalendary(c_2, c_1, NIL);
  MontaCalendary(c_3, c_2, NIL);
  MontaCalendary(c_4, c_3, NIL);
  MontaCalendary(c_5, NIL, c_1);
  MontaCalendary(c_6, c_5, NIL);
  MontaCalendary(c_7, c_6, NIL);
  MontaCalendary(c_8, c_7, NIL);
  MontaCalendary(c_9, NIL, c_5);
  MontaCalendary(c_10, c_9, NIL);
  MontaCalendary(c_11, c_10, NIL);
  MontaCalendary(c_12, c_11, NIL);

  ActiveControl := NIL;
  c_1.SetFocus;

end;

procedure TFrmFeriado.c_1Enter(Sender: TObject);
var i: Integer;
begin
  TStringAlignGrid(Sender).SelectedCellColor := clYellow;
  TStringAlignGrid(Sender).Row := 1;
  for i := 0 to TStringAlignGrid(Sender).ColCount - 1 do
    if TStringAlignGrid(Sender).Cells[i,1] <> '' then
    begin
      TStringAlignGrid(Sender).Col := i;
      Break;
    end;
end;

procedure TFrmFeriado.c_1Exit(Sender: TObject);
begin
  TStringAlignGrid(Sender).SelectedCellColor := clWhite;
  { Alteras Row e Col faz com que a celula (de onde se saiu) seja
    redesenhada com as cores originais }
  TStringAlignGrid(Sender).Row := TStringAlignGrid(Sender).RowCount - 1;
  TStringAlignGrid(Sender).Col := TStringAlignGrid(Sender).ColCount - 1;
end;

procedure TFrmFeriado.c_1DblClick(Sender: TObject);
var
  sValue: String;
  bFeriado: Boolean;
  dData: TDateTime;
begin

  with TStringAlignGrid(Sender) do
  begin

    if (Cells[Col, Row] = '') then
      Exit;

    sValue := HintCell[Col, Row];
    bFeriado := (sValue <> '');

    if not InputQuery('Cadastro de Feriado', 'Informe uma descrição ou "vazio" para excluir', sValue) then
      Exit;

    dData := EncodeDate(pvYear, TStringAlignGrid(Sender).Tag, StrToInt(Cells[Col, Row]));

    if bFeriado and (sValue = '') then  // Excluir feriado
      kExecSQL('DELETE FROM FERIADO WHERE DATA = :DATA', [dData])

    else if bFeriado and (sValue <> '') then
      kExecSQL('UPDATE FERIADO SET DESCRICAO = :NOME WHERE DATA = :DATA', [sValue, dData])

    else if (not bFeriado) and (sValue <> '') then
      kExecSQL('INSERT INTO FERIADO (DATA, DESCRICAO) VALUES (:DATA, :NOME)', [dData, sValue]);

    ClearCalendary(TStringAlignGrid(Sender));
    MontaCalendary(TStringAlignGrid(Sender), NIL, NIL);

    OnEnter(Sender);

  end;

end;

procedure TFrmFeriado.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmFeriado.FormResize(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

constructor TFrmFeriado.CreateNew(AOwner: TComponent; Dummy: Integer);
var
  Panel: TPanel;
  iLeft: Integer;
begin

  inherited;

  OnActivate := FormResize;
  OnResize := FormResize;
  OnKeyDown := FormKeyDown;
  OnClose := FormClose;

  BorderIcons := [biMaximize];
  FormStyle := fsMDIChild;
  KeyPreview := True;
  Color := kGetColor();
  ShowHint := True;

  {$IFDEF VCL}
  Ctl3d := False;
  {$ENDIF}

  pvYear := YearOf(Date);

  pnlTitulo := TPanel.Create(Self);
  pnlTitulo.Parent := Self;
  pnlTitulo.Color := clBlack;
  pnlTitulo.Height := 30;
  pnlTitulo.Align := alTop;
  pnlTitulo.BevelInner := bvNone;
  pnlTitulo.BevelOuter := bvNone;
  pnlTitulo.BorderStyle := bsNone;
  pnlTitulo.Alignment := taLeftJustify;
  pnlTitulo.Caption := ' · Cadastro de Feriados';
  pnlTitulo.Font.Size := 14;
  pnlTitulo.Font.Color := clWhite;
  pnlTitulo.Font.Style := [fsBold];

  Panel := TPanel.Create(Self);

  with Panel do
  begin
    Parent := pnlTitulo;
    Width := 40;
    ParentColor := True;
    Align := TAlign(4);
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent := Panel;
    Caption := 'Anterior';
    Top := 5;
    Left := 12;
    Width := 80;
    Height := 20;
    Font.Size := 6;
    Hint := 'Vai para o ano anterior';
    Transparent := True;
    Flat := True;
    onClick := YearPrior;
    iLeft := Left + Width;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent := Panel;
    Caption := 'Próximo';
    Top := 5;
    Left := iLeft+5;
    Width := 80;
    Height := 20;
    Font.Size := 6;
    Hint := 'Vai para o ano anterior';
    Transparent := True;
    Flat := True;
    onClick := YearNext;
    iLeft := Left + Width;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent := Panel;
    Caption := 'Copiar...';
    Top := 5;
    Left := iLeft+5;
    Width := 80;
    Height := 20;
    Font.Size := 6;
    Hint := 'Copia os feriados do ano anterior';
    Transparent := True;
    Flat := True;
    OnClick := CopiarFeriado;
    iLeft := Left + Width;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent := Panel;
    Caption := 'X';
    Top := 5;
    Left := iLeft + 5;
    Width := 20;
    Height := 20;
    Font.Size := 6;
    Hint := 'Fechar';
    Transparent := True;
    Flat := True;
    OnClick := FecharClick;
    iLeft := Left + Width;
  end;

  Panel.Width := iLeft + 10;

  c_1 := TStringAlignGrid.Create(Self);
  c_1.Parent := Self;
  c_1.Tag := 1;

  c_2 := TStringAlignGrid.Create(Self);
  c_2.Parent := Self;
  c_2.Tag := 2;

  c_3 := TStringAlignGrid.Create(Self);
  c_3.Parent := Self;
  c_3.Tag := 3;

  c_4 := TStringAlignGrid.Create(Self);
  c_4.Parent := Self;
  c_4.Tag := 4;

  c_5 := TStringAlignGrid.Create(Self);
  c_5.Parent := Self;
  c_5.Tag := 5;

  c_6 := TStringAlignGrid.Create(Self);
  c_6.Parent := Self;
  c_6.Tag := 6;

  c_7 := TStringAlignGrid.Create(Self);
  c_7.Parent := Self;
  c_7.Tag := 7;

  c_8 := TStringAlignGrid.Create(Self);
  c_8.Parent := Self;
  c_8.Tag := 8;

  c_9 := TStringAlignGrid.Create(Self);
  c_9.Parent := Self;
  c_9.Tag := 9;

  c_10 := TStringAlignGrid.Create(Self);
  c_10.Parent := Self;
  c_10.Tag := 10;

  c_11 := TStringAlignGrid.Create(Self);
  c_11.Parent := Self;
  c_11.Tag := 11;

  c_12 := TStringAlignGrid.Create(Self);
  c_12.Parent := Self;
  c_12.Tag := 12;

end;

procedure TFrmFeriado.CopiarFeriado(Sender: TObject);
var
  d1, d2: TDateTime;
  sNome: String;
  cdFeriado: TClientDataSet;
begin

  if not kConfirme('Deseja copiar os feriados do ano anterior para o ano atual?') then
    Exit;

  d1 := StartOfTheYear( EncodeDate(pvYear-1, 1, 1));
  d2 := EndOfTheYear(d1);

  cdFeriado := TClientDataSet.Create(NIL);

  try

    if not kOpenSQL(cdFeriado, 'SELECT * FROM FERIADO'#13+
                               'WHERE DATA BETWEEN :D1 AND :D2', [d1, d2]) then
      Exit;

    if (cdFeriado.RecordCount = 0) then
      raise Exception.Create('Não há feriados a serem copiados. Verifique');

    cdFeriado.First;

    while not cdFeriado.Eof do
    begin

      d1 := cdFeriado.FieldByName('DATA').AsDateTime;
      d1 := EncodeDate(pvYear, MonthOf(d1), DayOf(d1));
      sNome := cdFeriado.FieldByName('DESCRICAO').AsString;

      if not kExecSQL('INSERT INTO FERIADO (DATA, DESCRICAO)'#13+
                      'VALUES (:DATA, :NOME)', [d1, sNome]) then
         Exit;

      cdFeriado.Next;

    end;

    kAviso('Os feriados foram copiados com sucesso !!!');

  finally
    cdFeriado.Free;
  end;

  MontaAno();

end;

procedure TFrmFeriado.YearNext(Sender: TObject);
begin
  Inc(pvYear);
  MontaAno();
end;

procedure TFrmFeriado.YearPrior(Sender: TObject);
begin
  Dec(pvYear);
  MontaAno();
end;

end.
