unit SEFIP_Resumo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, QuickRpt, Db, kbmMemTable, Qrctrls;

type
  TFrmSEFIP_Resumo = class(TForm)
    QuickRep1: TQuickRep;
    PageHeaderBand1: TQRBand;
    QRLabel7: TQRLabel;
    QRLabel8: TQRLabel;
    kbmMemTable1: TkbmMemTable;
    kbmMemTable1QTDE: TIntegerField;
    kbmMemTable1BASE: TCurrencyField;
    kbmMemTable1FGTS: TCurrencyField;
    kbmMemTable1BASE13: TCurrencyField;
    kbmMemTable1FGTS13: TCurrencyField;
    DetailBand1: TQRBand;
    QRLabel1: TQRLabel;
    QRDBText1: TQRDBText;
    QRLabel2: TQRLabel;
    QRDBText2: TQRDBText;
    QRLabel3: TQRLabel;
    QRDBText3: TQRDBText;
    QRLabel6: TQRLabel;
    QRDBText4: TQRDBText;
    QRLabel5: TQRLabel;
    QRLabel4: TQRLabel;
    QRDBText5: TQRDBText;
    QRDBText6: TQRDBText;
    kbmMemTable1GERAL: TCurrencyField;
    QRDBImage1: TQRDBImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ProcessaSEFIP_Resumo( NomeEmpresa: String; Ano, Mes, Qtde: SmallInt;
                        Base, FGTS, Base13, FGTS13: Currency ):Boolean;

implementation

{$R *.DFM}

function ProcessaSEFIP_Resumo( NomeEmpresa: String; Ano, Mes, Qtde: SmallInt;
                        Base, FGTS, Base13, FGTS13: Currency ):Boolean;
var
  Frm: TFrmSEFIP_Resumo;
begin

  Frm := TFrmSEFIP_Resumo.Create(Application);

  Screen.Cursor := crDefault;

  try
    with Frm do begin
      with kbmMemTable1 do begin
        Close;
        kbmMemTable1.Open;
        Append;
        FieldByName('QTDE').AsInteger    := Qtde;
        FieldByName('BASE').AsCurrency   := Base;
        FieldByName('FGTS').AsCurrency   := FGTS;
        FieldByName('BASE13').AsCurrency := Base13;
        FieldByName('FGTS13').AsCurrency := FGTS13;
        FieldByName('GERAL').AsCurrency  := (FGTS+FGTS13);
        Post;
      end;
      QRLabel8.Caption := 'RESUMO DO FGTS DO MES/ANO: '+FormatFloat('00', Mes)+'/'+
                                                        IntToStr(Ano) ;
      QuickRep1.Preview;
      kbmMemTable1.Close;
    end; // with Frm
  finally
    Frm.Free;
  end;

end;  // function

end.
