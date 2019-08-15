
{$IFNDEF QAKPRINT}
unit AKPrint;
{$ENDIF}

{==========================================================================
Fecha: 24/2/1998
Versión: 0.91
Autor: Horacio Jamilis
E-Mail: jhoracio@cvtci.com.ar
==========================================================================
Documentado primero en Español y luego en Ingles.
Documented in Spanish first and next in English (or something like that).
==========================================================================
Este es un componente que permite utilizar la impresora con una impresión
rápida similar a DOS o con la mismo contenido imprimir utilizando un
driver de Windows.
-------------------------------------------------------------------------
Este componente es de libre distribución en tanto no se modifique.
Puede ser utilizado libremente en software freeware. Para poder ser utilizado
en otro tipo de software (shareware, comercial, etc.) debe ser registrado con
un valor de $ 15.-
De cualquier manera no existen garantías de que el componente funcione en todas
las circunstancias. Uselo a su cuenta y riesgo.
--------------------------------------------------------------------------
Comentarios, alabanzas y agradecimiento enterno,... serán bien recibidos.
--------------------------------------------------------------------------
Le tengo que pedir un favor. Necesito saber de donde consigue la gente este
conjunto de componentes. Por favor escribame a jhoracio@cvtci.com.ar para
informarme.
==========================================================================
Nuevo en esta version:
  - Se corrigieron errores de impresion con fuente comprimida en modo rapido.
  - Se corrigieron errores de preparacion de imagen con fuente comprimida para
    la presentacion preliminar.
  - Se corrigieron errores de impresion de fuente comprimida en modo Windows.
  - Se separo el print preview a un modulo diferente (TbPrintV) para lograr
    compatibilidad con C++ builder y facilitar la traduccion de la pantalla
    a los diferentes lenguajes.
  - Se agrego un componente: TAKCustomReport como interface para facilitar la
    creacion de impresiones personalizadas.
  - Se establecio como fuente para impresion y presentacion preliminar Courier
    en lugar de monospaced.
  - Se agrego un programa de demostracion de la mayoria de las cualidades.
  - Se termina de traducir esta ayuda al ingles.

==========================================================================
ENGLISH SECTION
==========================================================================
This component let's you use the printer like you did in DOS or send the same
information through the Windows driver.
--------------------------------------------------------------------------
This component could be freely distributed while not modified.
You could use it freely in any freeware software. To use it in any other type
of software (shareware, comercial, etc.) you should register it in u$s 15.-
Any way, there are not warranties about the way the component works in all the
cases. Use it at your own risk.
--------------------------------------------------------------------------
Comentaries, goodies and appreciation for ever,... will be wellcome.
--------------------------------------------------------------------------
I have to ask you a favor. I need to know where the people gets this component
set from. Please write me to jhoracio@cvtci.com.ar to inform me.
==========================================================================
New on this version:
 - Fixed some errors on printing with compressed font in fast printing mode.
 - Fixed some errors on preparation of image with comppresed font for print
   preview.
 - It was separated the print preview to a new module (TbPrintV) to get
   compatibility with C++ builder and make easy to translate the form to
   any other language.
 - It was added a new component: TAKCustomReport to make easy to create a
   new personal printing.
 - It was established as font to print in Windows mode and for print preview
   Courier in place of monospaced.
 - It was added a demostration program showing most of the posibilities.
 - It was completelly translated to english (or something like that).
==========================================================================}

interface

{$R *.res}

{$I AKLIB.inc}

{$IFNDEF TB_CLX}
  {$DEFINE TB_VCL}
{$ENDIF}

{$DEFINE TB_PREVIEW}

uses
  {$IFDEF MSWINDOWS}
  Windows, Messages,
  {$ENDIF}
  {$IFDEF LINUX}QTypes, Types,
  {$ENDIF}
  {$IFDEF TB_VCL}
  Forms, Graphics, Controls, Dialogs, Printers, ExtCtrls, StdCtrls, ComCtrls,
  Buttons, Spin,
  {$ENDIF}
  {$IFDEF TB_CLX}
  Qt, QForms, QGraphics, QControls, QDialogs, QPrinters, QConsts, QExtCtrls,
  QStdCtrls, QComCtrls, QButtons,
  {$ENDIF}
  {$IFDEF AK_D6}
  Variants,  // Introduzido a partir do Delphi 6
  {$ENDIF}
  SysUtils, Classes, DB;

const
  LINE_PAGE = 63;
  SEPARATOR_WIDTH = 5;
  SEPARATOR_HEIGTH = 10;

type

  TStatus = (Lista,OffLine,SinPapel,Apagada,Desconocido);

  TModelo = (Cannon_F60,Cannon_Laser,Epson_FX,HP_Deskjet,HP_Laserjet,
             HP_Thinkjet,IBM_Color_Jet,IBM_PC_Graphics,IBM_Proprinter,
             NEC_3500,NEC_Pinwriter);

  TPrinterMode = ( pmFast, pmWindows);

  TTipoFuente = (Negrita,Italica,Subrayado,Comprimido);
  TFuente = Set of TTipoFuente;

  PPagina = ^TPagina;
  TPagina = record
    Escritura: TList;
    LineasImpresas: byte;
  end;

  PEscritura = ^TEscritura;
  TEscritura = record
    X: byte;
    Y: byte;
    Fuente: TFuente;
    Texto: string;
  end;

  EPrinterError = class(Exception);
  EReportError = class(Exception);

  TInitialZoom = ( zReal, zWidth, zHeight);

  TAKPrinter = class(TComponent)
  private
    { Private declarations }
    fOnPrinterError: TNotifyEvent;
    FDatosEmpresa: String; // INFORMACION QUE SE IMPRIME EN TODOS LOS REPORTES
    FDMargen: Byte;
    FModelo: TModelo;      // MODELO DE IMPRESORA
    FFastPuerto: String;   // PUERTO DE LA IMPRESORA
    FLineas: Byte;              // CANTIDAD DE LINEAS POR PAGINA
    FLineTotal: Boolean;  { Imprime linha se o total não for impresso }
    FColumnas: Byte;            // CANTIDAD DE COLUMNAS EN LA PAGINA
    FFuente: TFuente;           // TIPO DE LETRA
    FIMargen: Byte;
    FModo: TPrinterMode;        // MODO DE IMPRESION (NORMAL/MEJORADO)
    //FPaginaActual: Byte;        // PAGINA ACTUAL
    FPaginaActual: Word;        // PAGINA ACTUAL
    LasPaginas: TList;             // Almacenamiento de las páginas
    FCopias: Integer;
    PRNNormal: String;
    PRNBold: String;
    PRNItalics: String;
    PRNULineON: String;
    PRNULineOFF: String;
    PRNCompON: String;
    PRNCompOFF: String;
    PRNSetup: String;
    PRNReset: String;
    FPreview: Boolean;
    FZoom: TInitialZoom;
    FWinPrinter: String;        // NOMBRE DE LA IMPRESORA EN WINDOWS
    FWinPort: String;
    function GetModeloRealName(Model : TModelo) : String;
    procedure SetModelo(Nombre : TModelo);
    procedure SetFastPuerto(Puerto : string);
    function GetPaginas: Word;
    procedure Clear;
    procedure PreviewReal;           // MUESTRA LA IMPRESION EN PANTALLA
    function ImprimirPaginaFast(Numero:integer) : boolean;
    procedure ImprimirCodigo( var Impresora: TextFile; Codigo: string);
    procedure PrintFont(var Impresora: TextFile; Font: TFuente);

    procedure ImprimirLinea( var Impresora: TextFile; Page: PPagina;
      Font: TFuente; var LastEscritura: Integer; Line: Integer; Text: String);

    procedure GravarTudo;
    function GravarPagina( var Arquivo: TextFile; Numero:Integer): Boolean;
    procedure GravarLinha( var Arquivo: TextFile; Page: PPagina;
      {var LastEscrita: Integer;} Line: Integer{; Text: String});

    procedure MaxX(var Linea: string; X: byte);
    procedure ErrorDeImpresion( Status: TStatus);
    function Status: TStatus;
  protected
    { Protected declarations }
    FNumeraPaginas: Boolean;
    FMostraData: Boolean;
    FMostraHora: Boolean;
    FSeparacionColumnas: String;
    FLineaActual: Byte;
    FTitulo: string;
    FSubTitulo: string;
    FLineaTitulo : byte;
    FLineaSubTitulo : byte;
    FLineaPiePagina : byte;
    FColumnaTitulo: byte;
    FColumnaSubTitulo: byte;
    FColumnaPagina: byte;
    FPiePagina: String;
  public
    { Public declarations }
    PageWidth: Integer;         // ANCHO DE PAGINA EN PIXELS
    PageHeight: integer;  // ALTO DE PAGINA EN PIXELS
    PageWidthP: Double;       // ANCHO DE PAGINA EN PULGADAS
    PageHeightP: Double;  // ALTO DE PAGINA EN PULGADAS
    PageOrientation: TPrinterOrientation; // ORIENTACION DE LA PAGINA
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Comenzar;  // PARA COMENZAR UNA NUEVA IMPRESION
    procedure Finalizar; // ELIMINA LA INFORMACION DE LAS PAGINAS AL FINALIZAR
    procedure EscribirStd(X,Y : byte; Texto:string);
    procedure Escribir(X,Y : byte; Texto:string; Fnt : TFuente);
    procedure Imprimir;                   // MANDA LA IMPRESION A LA IMPRESORA
    procedure NuevaPagina;                 // CREA UNA NUEVA PAGINA
    procedure SetModeloName(Nombre : String);
    procedure GetModelos(Modelos : TStrings);
    function GetModeloName : String;
    {$IFDEF TB_PREVIEW}
    procedure HacerHoja(Numero : integer; Hoja: TMetaFile; ToPrint:boolean);
    {$ENDIF}
    function GetPrintingWidth : integer;
    function GetPrintingHeight : integer;
    property Lineas : byte read FLineas write FLineas default LINE_PAGE;
    property LineTotal: Boolean read FLineTotal write FLineTotal default True;
    function ImprimirPagina(Numero:integer) : boolean;
    procedure ImprimirTodo;              // MANDA LA IMPRESION A LA IMPRESORA
    property EscribirPaginas: boolean read FNumeraPaginas write FNumeraPaginas default True;
    property EscribirData: boolean read FMostraData write FMostraData default True;
    property EscribirHora: boolean read FMostraHora write FMostraHora default True;
    property SeparacionColumnas: String read FSeparacionColumnas write FSeparacionColumnas;
    property LineaActual: Byte read FLineaActual write FLineaActual;
    property PaginaActual: Word read GetPaginas;
  published
    { Published declarations }
    property FastPrinter: TModelo read FModelo Write SetModelo;
    property FastPort: string read FFastPuerto Write SetFastPuerto;
    property Mode: TPrinterMode read FModo write FModo default pmFast;
    property Columnas: byte read FColumnas write FColumnas default 80;
    property Paginas: Word read GetPaginas default 0;   // CANTIDAD DE PAGINAS
    property FastFont: TFuente read FFuente write FFuente;
    property CompanyData: string read FDatosEmpresa write FDatosEmpresa;
    property Zoom: TInitialZoom read FZoom write FZoom default zHeight;
    property Preview: Boolean read FPreview write FPreview default True;
    property Title: string read FTitulo write FTitulo;
    property WinPrinter: string read fWinPrinter write fWinPrinter;
    property WinPort: String read fWinPort write fWinPort;
    property Copies: Integer read fCopias write fCopias default 1;
    property OnPrinterError: TNotifyEvent read fOnPrinterError write fOnPrinterError;
    property PrintingWidth: Integer read GetPrintingWidth;
    property PrintingHeight: Integer read GetPrintingHeight;
    property MargenDerecho: Byte read FDMargen write FDMargen default 80;
    property MargenIzquierdo: Byte read FIMargen write FIMargen Default 1;
    property Titulo: String read FTitulo write FTitulo;
    property LineaTitulo: Byte read FLineaTitulo write FLineaTitulo default 4;
    property SubTitulo: String read FSubTitulo write FSubTitulo;
    property LineaSubTitulo: Byte read FLineaSubTitulo write FLineaSubTitulo default 6;
    property LineaPiePagina: Byte read FLineaPiePagina write FLineaPiePagina default LINE_PAGE;
    property ColumnaTitulo: Byte read FColumnaTitulo write FColumnaTitulo default 0;
    property ColumnaSubTitulo: Byte read FColumnaSubTitulo write FColumnaSubTitulo default 0;
    property ColumnaPieDePagina: Byte read FColumnaPagina write FColumnaPagina default 0;
    property PiePagina: String read FPiePagina write FPiePagina;
  end;  // TAKPrinter

  TTbEndQueryEvent = procedure(var EndReport : boolean) of object;

  TTbPreviewType = (pYes,pNo,pDefault);
  TTbPrinterMode = (rmFast,rmWindows,rmDefault);

  TAKCustomReport = class(TComponent)
  private
    FPrinter: TAKPrinter;
    FDataSet: TDataSet;
    FModo: TTbPrinterMode;
    FPreview: TTbPreviewType;
    FOnGenerate: TNotifyEvent;
    FOnHead: TNotifyEvent;
    FOnBeforeHead: TNotifyEvent;
    FOnAfterHead: TNotifyEvent;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Execute;
  published
    property DataSet: TDataSet read FDataSet write FDataSet;
    property Printer: TAKPrinter read FPrinter write FPrinter;
    property ModoImpresion: TTbPrinterMode read FModo write FModo default rmDefault;
    property Preview: TTbPreviewType read FPreview write FPreview default pDefault;
    property OnGenerate : TNotifyEvent read FOnGenerate write FOnGenerate;
    property OnHead: TNotifyEvent read FOnHead write FOnHead;
    property OnBeforeHead: TNotifyEvent read FOnBeforeHead write FOnBeforeHead;
    property OnAfterHead: TNotifyEvent read FOnAfterHead write FOnAfterHead;
  end;

  TTbGetTextEvent = procedure(var Text : string) of object;

  TPrintPreview = class(TForm)
  private
    PrinterPanel: TPanel;
    Scroller: TScrollBox;
    Shower: TPaintBox;
    ModoImpresion: TRadioGroup;
    ActualPrinter: TComboBox;
    LPrinter: TLabel;
    LCopias: TLabel;
    Copias: TSpinEdit;
    LTamanio: TLabel;
    LSize: TLabel;
    LPag: TLabel;
    LPagN: TLabel;
    LTotPag: TLabel;
    LZoom: TLabel;
    ZoomShower: TSpinEdit;
    btnPagPrimeira: TBitBtn;
    btnPagAnterior: TBitBtn;
    btnPagProxima: TBitBtn;
    btnPagUltima: TBitBtn;
    btnReal: TBitBtn;
    btnWidth: TBitBtn;
    btnCompleta: TBitBtn;
    btnImpAtual: TBitBtn;
    btnImpTodo: TBitBtn;
    btnPropriedades: TBitBtn;
    btnSalvar: TBitBtn;
    Rate: Double;
    RateHeigth: Double;
    procedure CopiasChange(Sender: TObject);
    procedure ZoomShowerChange(Sender: TObject);
    procedure ShowerPaint(Sender: TObject);
    procedure BtnRealClick(Sender: TObject);
    procedure BtnWidthClick(Sender: TObject);
    procedure BtnCompletaClick(Sender: TObject);
    procedure btnPagPrimeiraClick(Sender: TObject);
    procedure BtnPagAnteriorClick(Sender: TObject);
    procedure BtnPagProximaClick(Sender: TObject);
    procedure BtnPagUltimaClick(Sender: TObject);
    procedure BtnImpAtualClick(Sender: TObject);
    procedure BtnImpTodoClick(Sender: TObject);
    procedure BtnGravarTudoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ShowerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ModoImpresionClick(Sender: TObject);
    procedure ActualPrinterChange(Sender: TObject);
    procedure btnPropriedadesClick(Sender: TObject);
  private
    { Private declarations }
    FPagina : integer;
    FZoom : Double;
    TbPrinter: TComponent;
    procedure EscribirTamanioPapel;
    procedure SetZoom(Valor : integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    { Public declarations }
    Hoja: TMetaFile;
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    destructor Destroy; override;
  end;

  TTbPrinter = class(TAKPrinter);
  TTbCustomReport = class(TAKCustomReport);

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents( 'AK Lib', [TAKPrinter]);
  RegisterComponents( 'AK Lib', [TAKCustomReport]);
  RegisterComponents( 'AK Lib', [TTbPrinter]);
  RegisterComponents( 'AK Lib', [TTbCustomReport]);
end;

constructor TAKCustomReport.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPreview := pDefault;  // pNo, pYes, pDefault
  FModo := rmDefault;    // pFast, pWindows, pDefault
  FOnGenerate := nil;
end;

procedure TAKCustomReport.Execute;
var
  OldModo : TPrinterMode;
  OldPreview: Boolean;
begin

  if (FPrinter = nil) then
  begin
    MessageDlg( 'Debe enlazar el reporte con una impresora TAKPrinter.',
                mtError,[mbOk],0);
    Exit;
  end;

  if not Assigned(FOnGenerate) then
  begin
    MessageDlg( 'Debe asignar un procedimiento de generación del reporte.',
                mtError,[mbOk],0);
    Exit;
  end;

  OldModo := FPrinter.Mode;
  OldPreview := FPrinter.Preview;

  if (FModo = rmFast) then
    FPrinter.Mode := pmFast
  else if (FModo = rmWindows) then
    FPrinter.Mode := pmWindows;

  if (FPreview = pYes) then
    FPrinter.Preview := True
  else if (FPreview = pNo) then
    FPrinter.FPreview := False;

  if Assigned(FOnGenerate) then
    FOnGenerate(Self);

  FPrinter.Imprimir;

  FPrinter.Mode := OldModo;
  FPrinter.Preview := OldPreview;

end;

function Min(Val1,Val2 : integer):integer;
begin
  if Val1<Val2 then
    Min := Val1
  else
    Min := Val2;
end;

(* IMPRESORA *)

constructor TAKPrinter.Create(AOwner: TComponent);
var
  ADevice, ADriver, APort : array [0..255] of char;
  DeviceMode: THandle;
begin

  inherited Create(AOwner);

  SetModelo(EPSON_FX);
  SetFastPuerto('LPT1');
  FColumnas := 80;

  FCopias := 1;
  FZoom := zHeight;
  FFuente := [];
  LasPaginas := TList.Create;
  PageOrientation := Printer.Orientation;
  PageWidth := GetDeviceCaps( Printer.Handle, PHYSICALWIDTH);
  PageHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
  PageWidthP := PageWidth/GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  PageHeightP := PageHeight/GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  Lineas := Trunc(PageHeightP*6)-2;
  FLineTotal := True;
  Printer.GetPrinter( ADevice, ADriver, APort, DeviceMode);
  WinPort := APort;
  WinPrinter := ADevice;

  FNumeraPaginas := True;
  FMostraData := True;
  FMostraHora := True;
  FSeparacionColumnas := #32#32;

  FIMargen   := 1;
  FDMargen   := 80;
  FTitulo    := Name;
  FSubTitulo := '';

  FPaginaActual := 0;
  FPiePagina    := '';

  FLineaActual      := 0;
  FLineaTitulo      := 3;
  FLineaSubTitulo   := 4;
  FLineaPiePagina   := LINE_PAGE;
  FColumnaTitulo    := 0;
  FColumnaSubTitulo := 0;
  FColumnaPagina    := 0;

  FPreview := True;    // 20-01-2004
  FModo    := pmFast;  // 20-01-2004

end;

destructor TAKPrinter.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TAKPrinter.Clear;
var
  Pag : PPagina;
  Esc : PEscritura;
begin

  while LasPaginas.Count > 0 do
  begin

    Pag := LasPaginas.Items[0];

    While Pag.Escritura.Count > 0 do
    begin
      Esc := Pag.Escritura.Items[0];
      Dispose(Esc);
      Pag.Escritura.Delete(0);
      Pag.Escritura.Pack;
    end;

    Pag.Escritura.Free;

    Dispose(Pag);
    LasPaginas.Delete(0);
    LasPaginas.Pack;

  end;

end;

procedure TAKPrinter.SetModelo(Nombre : TModelo);
begin
  FModelo := Nombre;
  case Nombre of
    Cannon_F60 :
      begin
        PRNNormal := '27 70 27 54 00';
        PRNBold := '27 69';
        PRNItalics := '27 54 01';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    Cannon_Laser :
      begin
        PRNNormal := '27 38';
        PRNBold := '27 79';
        PRNItalics := '';
        PRNULineON := '27 69';
        PRNULineOFF := '27 82';
        PRNCompON := '27 31 09';
        PRNCompOFF := '27 31 13';
        PRNSetup := '';
        PRNReset := '';
      end;
    HP_Deskjet :
      begin
        PRNNormal := '27 40 115 48 66 27 40 115 48 83';
        PRNBold := '27 40 115 51 66';
        PRNItalics := '27 40 115 49 83';
        PRNULineON := '27 38 100 48 68';
        PRNULineOFF := '27 38 100 64';
        PRNCompON := '27 40 115 49 54 46 54 72';
        PRNCompOFF := '27 40 115 49 48 72';
        PRNSetup := '';
        PRNReset := '';
      end;
    HP_Laserjet :
      begin
        PRNNormal := '27 40 115 48 66 27 40 115 48 83';
        PRNBold := '27 40 115 53 66';
        PRNItalics := '27 40 115 49 83';
        PRNULineON := '27 38 100 68';
        PRNULineOFF := '27 38 100 64';
        PRNCompON := '27 40 115 49 54 46 54 72';
        PRNCompOFF := '27 40 115 49 48 72';
        PRNSetup := '';
        PRNReset := '12';
      end;
    HP_Thinkjet :
      begin
        PRNNormal := '27 70';
        PRNBold := '27 69';
        PRNItalics := '';
        PRNULineON := '27 45 49';
        PRNULineOFF := '27 45 48';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    IBM_Color_Jet :
      begin
        PRNNormal := '27 72';
        PRNBold := '27 71';
        PRNItalics := '';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    IBM_PC_Graphics :
      begin
        PRNNormal := '27 70 27 55';
        PRNBold := '27 69';
        PRNItalics := '27 54';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    IBM_Proprinter :
      begin
        PRNNormal := '27 70';
        PRNBold := '27 69';
        PRNItalics := '';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    NEC_3500:
      begin
        PRNNormal := '27 72';
        PRNBold := '27 71';
        PRNItalics := '';
        PRNULineON := '27 45';
        PRNULineOFF := '27 39';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    NEC_Pinwriter:
      begin
        PRNNormal := '27 70 27 53';
        PRNBold := '27 69';
        PRNItalics := '27 52';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '';
      end;
    else
//  Epson_FX :
      begin
        PRNNormal := '27 70 27 53';
        PRNBold := '27 69';
        PRNItalics := '27 52';
        PRNULineON := '27 45 01';
        PRNULineOFF := '27 45 00';
        PRNCompON := '15';
        PRNCompOFF := '18';
        PRNSetup := '';
        PRNReset := '27 64';
      end;
  end;
end;

procedure TAKPrinter.SetFastPuerto(Puerto : string);
begin
  if (Puerto <> fFastPuerto) then
    FFastPuerto := Puerto;
end;

function TAKPrinter.GetPaginas: Word;
begin
  GetPaginas := LasPaginas.Count;
end;

procedure TAKPrinter.Comenzar;  // PARA COMENZAR UNA NUEVA IMPRESION
begin
  Clear;
  NuevaPagina;
end;

// ELIMINA LA INFORMACION DE LAS PAGINAS AL FINALIZAR
procedure TAKPrinter.Finalizar;
begin
  Clear;
end;

procedure TAKPrinter.Escribir( X,Y : byte; Texto:string; Fnt : TFuente);
var
  Txt: PEscritura;
  Pag: PPagina;
  P: integer;
begin

  if LasPaginas.Count > 0 then
  begin

    Pag := LasPaginas.Items[FPaginaActual];
    P := 0;

    if Pag.Escritura.Count > 0 then
    begin

      Txt := Pag.Escritura.Items[0];
      while (P < Pag.Escritura.Count) and
            ( (Txt^.Y < Y) or ( (Txt^.Y = Y) and (Txt^.X<=X) ) ) do
      begin
        Inc(P);
        if P<Pag.Escritura.Count then
          Txt := Pag.Escritura.Items[P];

      end;

    end;

    New(Txt);
    Pag.Escritura.Insert(P,Txt);
    Txt^.X := X;
    Txt^.Y := Y;
    Txt^.Texto := Texto;
    Txt^.Fuente := Fnt;

    if Y > Pag.LineasImpresas then
      Pag.LineasImpresas := Y;

  end;

end;

procedure TAKPrinter.EscribirStd(X,Y : byte; Texto:string);
begin
  Escribir( X, Y, Texto, FFuente);
end;

procedure TAKPrinter.PreviewReal;    // MUESTRA LA IMPRESION EN PANTALLA
begin
  with TPrintPreview.CreateNew(Self) do
  begin
    ShowModal;
    Free;
  end;
end;

procedure TAKPrinter.Imprimir;
begin
  if FPreview then
    PreviewReal
  else
    ImprimirTodo;
end;

procedure TAKPrinter.HacerHoja( Numero: integer; Hoja: TMetaFile;
  ToPrint:boolean);
var
  EA : integer; // LINEA ACTUAL
  Pagina : PPagina;
  Escritura : PEscritura;
  Texto: TMetafile;
  Ancho, Alto : Integer;
  MargenIzquierdo, MargenSuperior : integer;
  AltoDeLinea, AnchoDeColumna : double;
  CantColumnas: integer;
begin

  if Comprimido in FastFont then
  begin
    if PageOrientation = poLandscape then
      CantColumnas := 217+5
    else
      CantColumnas := 132+5;
  end else
  begin
    if PageOrientation = poLandscape then
      CantColumnas := 132+3
    else
     CantColumnas := 80+3;
  end;

  if ToPrint then
  begin

    with TMetaFileCanvas.Create( Hoja,0) do
    begin
      try

        Brush.Color := clWhite;
        Hoja.Width := PrintingWidth{PageWidth} div 4; // 640;
        Hoja.Height := PrintingHeight{PageHeight} div 4; // 1056;
        AnchoDeColumna := (Hoja.Width)/CantColumnas;
        AltoDeLinea := (Hoja.Height)/Lineas;
        Font.Name := 'Courrier';
        Font.Size := 10;
        Font.Pitch := fpFixed;
        Ancho := TextWidth('X');
        Alto := TextHeight('X');
        FillRect(Rect(0,0,(Hoja.Width)-1,(Hoja.Height-1)));//80*(Ancho),66*Alto
        Pagina := LasPaginas.Items[Numero-1];

        for EA := 0 to Pagina.Escritura.Count-1 do
        begin
          Escritura := Pagina.Escritura.Items[EA];

          if Escritura^.Y <= Lineas then
          begin
            Texto := TMetaFile.Create;
            Texto.Width := Ancho*Length(Escritura^.Texto);
            Texto.Height := Alto;
            with TMetaFileCanvas.Create( Texto, 0) do
            begin
              try

                Font.Name := 'Courrier';
                Font.Size := 10;
                Font.Pitch := fpFixed;

                if Negrita in Escritura^.Fuente then
                  Font.Style := Font.Style + [fsBold]
                else
                  Font.Style := Font.Style - [fsBold];

                if Italica in Escritura^.Fuente then
                  Font.Style := Font.Style + [fsItalic]
                else
                  Font.Style := Font.Style - [fsItalic];

                if Subrayado in Escritura^.Fuente then
                  Font.Style := Font.Style + [fsUnderline]
                else
                  Font.Style := Font.Style - [fsUnderline];

                TextOut(0,0,Escritura^.Texto);

              finally
                Free
              end;

            end;  //  with TMetaFileCanvas.Create( Texto, 0) do begin

            if (Comprimido in Escritura^.Fuente) and
               not(Comprimido in FastFont) then
              StretchDraw( Rect( Round(AnchoDeColumna*(Escritura^.X-1)),
                                 Round(AltoDeLinea*(Escritura^.Y-1)),
                                 Round(AnchoDeColumna*
                                      (Escritura^.X-1)+
                                      Length(Escritura^.Texto)*
                                      Hoja.Width/140 ),
                                 Round(AltoDeLinea*(Escritura^.Y)) ),
                            Texto)
            else
              StretchDraw( Rect( Round(AnchoDeColumna*(Escritura^.X-1)),
                                 Round(AltoDeLinea*(Escritura^.Y-1)),
                                 Round(AnchoDeColumna*
                                       (Escritura^.X+
                                        Length(Escritura^.Texto)-1) ),
                                 Round(AltoDeLinea*(Escritura^.Y))),
                           Texto);
            Texto.Free;

          end  // if

        end;

      finally
        Free;
      end;

    end; //   with TMetaFileCanvas.Create( Hoja,0) do begin

  end else
  begin

    with TMetaFileCanvas.Create( Hoja, 0) do
    begin
      try
        Brush.Color := clWhite;
        MargenIzquierdo := Round(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETX)/
                                 GetDeviceCaps(Printer.Handle,LOGPIXELSX)*80);
        MargenSuperior := Round(GetDeviceCaps(Printer.Handle,PHYSICALOFFSETY)/
                                GetDeviceCaps(Printer.Handle,LOGPIXELSY)*80);
        Hoja.Width := Round(GetDeviceCaps(Printer.Handle,PHYSICALWIDTH)/
                            GetDeviceCaps(Printer.Handle,LOGPIXELSX)*80);
        Hoja.Height := Round(GetDeviceCaps(Printer.Handle,PHYSICALHEIGHT)/
                             GetDeviceCaps(Printer.Handle,LOGPIXELSY)*80);
        AnchoDeColumna := (Hoja.Width-(2*MargenIzquierdo))/CantColumnas;
        AltoDeLinea := (Hoja.Height-(2*MargenSuperior))/Lineas;
        Font.Name := 'Courrier';
        Font.Size := 10;
        Font.Pitch := fpFixed;
        Ancho := TextWidth('X');
        Alto := TextHeight('X');   //80*(Ancho),66*Alto));
        FillRect(Rect(0,0,(Hoja.Width)-1,(Hoja.Height)-1));
        Pen.Color := clSilver;
        Pen.Style := psDot;

        if (MargenIzquierdo > 2) and (MargenSuperior > 2) then
          Rectangle( MargenIzquierdo-2,
                     MargenSuperior-2,
                     Round(MargenIzquierdo+CantColumnas*AnchoDeColumna)+2,
                     Round(MargenSuperior+Lineas*AltoDeLinea)+2)
        else
          Rectangle( MargenIzquierdo,
                     MargenSuperior,
                     Round(MargenIzquierdo+CantColumnas*AnchoDeColumna),
                     Round(MargenSuperior+Lineas*AltoDeLinea));

        Pen.Style := psSolid;
        Pen.Color := clBlack;
        Pagina := LasPaginas.Items[Numero-1];

        for EA := 0 to Pagina.Escritura.Count-1 do
        begin

          Escritura := Pagina.Escritura.Items[EA];

          if Escritura^.Y <= Lineas then
          begin
            Texto := TMetaFile.Create;
            Texto.Width := Ancho*Length(Escritura^.Texto);
            Texto.Height := Alto;
            with TMetaFileCanvas.Create(Texto,0) do
              try
                Font.Name := 'Courrier';
                Font.Size := 10;
                Font.Pitch := fpFixed;

                if Negrita in Escritura^.Fuente then
                  Font.Style := Font.Style + [fsBold]
                else
                  Font.Style := Font.Style - [fsBold];

                 if Italica in Escritura^.Fuente then
                   Font.Style := Font.Style + [fsItalic]
                 else
                   Font.Style := Font.Style - [fsItalic];

                 if Subrayado in Escritura^.Fuente then
                   Font.Style := Font.Style + [fsUnderline]
                 else
                   Font.Style := Font.Style - [fsUnderline];

                 TextOut(0,0,Escritura^.Texto);

               finally
                 Free
               end;

             if (Comprimido in Escritura^.Fuente) and
                not(Comprimido in FastFont) then
               StretchDraw( Rect( Round( MargenIzquierdo+
                                        AnchoDeColumna*(Escritura^.X)),
                               Round( MargenSuperior+
                                      AltoDeLinea*(Escritura^.Y-1)),
                               Round( MargenIzquierdo+
                                      AnchoDeColumna*(Escritura^.X)+
                                      Length(Escritura^.Texto)*Hoja.Width/140),
                               Round( MargenSuperior+
                                      AltoDeLinea*(Escritura^.Y))),
                            Texto)
             else
               StretchDraw( Rect( Round( MargenIzquierdo+
                                       AnchoDeColumna*(Escritura^.X)),
                                Round( MargenSuperior+
                                       AltoDeLinea*(Escritura^.Y-1)),
                                Round( MargenIzquierdo+
                                       AnchoDeColumna*
                                      (Escritura^.X+Length(Escritura^.Texto))),
                                Round( MargenSuperior+
                                       AltoDeLinea*(Escritura^.Y))),
                            Texto);
                Texto.Free;
          end
        end;

      finally
        Free;
      end;

    end; // with TMetaFileCanvas.Create( Hoja,0) do begin

  end;  // if ToPrint

end;

function TAKPrinter.GetPrintingWidth : integer;
begin
  result := Printer.PageWidth;
end;

function TAKPrinter.GetPrintingHeight : integer;
begin
  result := Printer.PageHeight;
end;

function TAKPrinter.ImprimirPagina(Numero:integer): boolean;
var
  Copias : integer;
  Imagen : TMetaFile;
begin

  if FModo = pmWindows then
  begin
    try
      Printer.Title := Title + ' (Página no. '+IntToStr(Numero)+')';
      Printer.Copies := fCopias;
      Printer.BeginDoc;
      Imagen := TMetaFile.Create;
      Imagen.Width := PrintingWidth{PageWidth} div 4; // 640;
      Imagen.Height := PrintingHeight{PageHeight} div 4; // 1056;
      try
        HacerHoja( Numero, Imagen, True);
        Printer.Canvas.StretchDraw( Rect( 0, 0,
                            Printer.PageWidth,
                            Printer.PageHeight),Imagen);
        Printer.EndDoc;
      except
      end;

      Imagen.Free;
      result := True;

    except
      result := False;
    end;

  end else
  begin

    result := True;
    for Copias := 1 to fCopias do
      if result then
        result := ImprimirPaginaFast(Numero);

  end;

end;

procedure TAKPrinter.ImprimirCodigo( var Impresora: TextFile; Codigo:string);
var
  Sub : string;
  Cod : byte;
  P : byte;
begin

  Sub := Codigo;

  while Length(Sub) > 0 do
  begin
      P := Pos(#32,Sub);
      if P = 0 then
      begin  // ES EL ULTIMO CODIGO
         try
          Cod := StrToInt(Sub);
          Write(Impresora,chr(Cod));
          Sub := '';
         except
         end;
      end else
      begin // HAY MAS CODIGOS
         try
          Cod := StrToInt(Copy(Sub,1,P-1));
          Write(Impresora,chr(Cod));
          Sub := Copy(Sub,P+1,Length(Sub)-3);
         except
         end;
      end;
  end;  // while
end;

procedure TAKPrinter.PrintFont( var Impresora: TextFile; Font: TFuente);
begin

  ImprimirCodigo( Impresora, PRNNormal);

  if Negrita in Font then
    ImprimirCodigo( Impresora, PRNBold);

  if Italica in Font then
    ImprimirCodigo( Impresora, PRNItalics);

  if Comprimido in Font then
    ImprimirCodigo( Impresora, PRNCompON)
  else
    ImprimirCodigo( Impresora, PRNCompOFF);

  if Subrayado in Font then
    ImprimirCodigo( Impresora, PRNULineON)
  else
    ImprimirCodigo( Impresora, PRNULineOFF);

end; // PrintFont

procedure TAKPrinter.MaxX( var Linea: string; X : byte);
begin
  while Length(Linea) < X do
    Linea := Linea + ' ';
end;

procedure TAKPrinter.ImprimirLinea( var Impresora: TextFile; Page: PPagina;
  Font: TFuente; var LastEscritura: Integer; Line: Integer; Text: String);
var
  Escritura : PEscritura;
  i,Contador : integer;
  Columna : byte;
  ImprimioLinea : boolean;
begin

  if (Page.Escritura.Count = LastEscritura) then
  begin

    if Font <> FFuente then  // PONEMOS LA FUENTE POR DEFAULT
    begin
      Font := FFuente;
      PrintFont( Impresora, Font);
    end;
    Writeln( Impresora, Text);

  end else
  begin

    ImprimioLinea := False;
    Contador := LastEscritura;
    Columna := 1;
    Escritura := Page.Escritura.Items[Contador];

    while (Contador < Page.Escritura.Count) and (Escritura^.Y <= Line) do
    begin

      if Escritura^.Y = Line then
      begin

        ImprimioLinea := True;
        LastEscritura := Contador;
        MaxX( Text, Escritura^.X+Length(Escritura^.Texto));

        while Columna < Escritura^.X do
        begin
          // PONEMOS LA FUENTE POR DEFAULT
          if (Text[Columna] <> #32) and (Font <> FFuente) then
          begin
            Font := FFuente;
            PrintFont( Impresora, Font);
          end;
          Write( Impresora, Text[Columna]);
          Inc(Columna);
        end;

        if Escritura^.Fuente <> Font then
        begin
          Font := Escritura^.Fuente;
          PrintFont( Impresora, Font);
        end;

        Write( Impresora, Escritura^.Texto);

        if (Comprimido in Font) and not(Comprimido in FastFont) then
        begin

          for i := 1 to Length(Escritura^.Texto) do
            Write(Impresora,#8);

          if (Length(Escritura^.Texto)*6) mod 10 = 0 then
            i := Columna + (Length(Escritura^.Texto) *6) div 10
          else
            i := Columna + (Length(Escritura^.Texto) *6) div 10;

          Font := Font - [Comprimido];
          PrintFont( Impresora, Font);

          while Columna <= i do
          begin
            Write(Impresora,#32);
            Inc(Columna);
          end;

        end else
          Columna := Columna + Length(Escritura^.Texto);

      end;

      Inc(Contador);

      if Contador < Page.Escritura.Count then
        Escritura := Page.Escritura.Items[Contador];

    end;  // while

    if ImprimioLinea then
    begin

      if Font <> FFuente then     // PONEMOS LA FUENTE POR DEFAULT
      begin
        Font := FFuente;
        PrintFont( Impresora, Font);
      end;

      while Columna <= Length(Text) do
      begin
        Write( Impresora, Text[Columna]);
        Inc(Columna);
      end;
      WriteLn(Impresora);

    end else
    begin
      if Font <> FFuente then   // PONEMOS LA FUENTE POR DEFAULT
      begin
        Font := FFuente;
        PrintFont( Impresora, Font);
      end;
      Writeln( Impresora, Text);
    end;
  end;

end;

procedure TAKPrinter.GravarTudo;
var
  Arquivo: TextFile;
  sFileName: String;
  i: integer;
  Bien: boolean;
  Copias: integer;
  dlgSave: TSaveDialog;
begin // IMPRIMIR

  dlgSave  := TSaveDialog.Create(Self);

  try

    dlgSave.DefaultExt := 'txt';
    dlgSave.Filter := 'Arquivo Texto (*.txt)|*.txt|Todos os arquivos (*.*)|*.*';
    dlgSave.FilterIndex := 1;
    dlgSave.InitialDir := ExtractFilePath(ParamStr(0));

    if dlgSave.Execute then
    begin

      sFileName := dlgSave.FileName;
      AssignFile( Arquivo, sFileName);
      Rewrite( Arquivo);

      Bien := True;

      for Copias := 1 to FCopias do
        for i := 1 to LasPaginas.Count do
          if Bien then
            Bien := Bien and GravarPagina( Arquivo, i);

    end;

  finally
    if (sFileName <> '') then
      CloseFile(Arquivo);
    dlgSave.Free;
  end;

end; // GRAVAR

function TAKPrinter.GravarPagina( var Arquivo: TextFile; Numero:Integer): Boolean;
var
  LA: integer;  // LA - Line Actual
  Pagina : PPagina;
begin

  try

    Result := True;
    Pagina := LasPaginas.Items[Numero-1];

    // SE IMPRIMEN TODAS LAS LINEAS
    for LA := 1 to Min( Pagina.LineasImpresas, Lineas) do
    begin
      Writeln(Arquivo);
      GravarLinha( Arquivo, Pagina, LA);
    end;

    Write( Arquivo, #12);

  except
    Result := False;

  end;

end;


procedure TAKPrinter.GravarLinha( var Arquivo: TextFile; Page: PPagina; Line: Integer);
var
  Escritura: PEscritura;
  Contador : integer;
  Columna : byte;
  Text: String;
begin

    Contador   := 0; //LastEscrita;
    Columna    := 1;
    Escritura  := Page.Escritura.Items[Contador];

    while (Contador < Page.Escritura.Count) and (Escritura^.Y <= Line) do
    begin

      if Escritura^.Y = Line then
      begin

        MaxX( Text, Escritura^.X + Length(Escritura^.Texto));

        while Columna < Escritura^.X do
        begin
          Write( Arquivo, Text[Columna]);
          Inc(Columna);
        end;

        Write( Arquivo, Escritura^.Texto);
        Columna := Columna + Length(Escritura^.Texto);

      end; // if Escritura^.Y = Line

      Inc(Contador);

      if Contador < Page.Escritura.Count then
        Escritura := Page.Escritura.Items[Contador];

    end;  // while

end;

procedure TAKPrinter.ErrorDeImpresion( Status: TStatus);
begin

  if Assigned(fOnPrinterError) then
    fOnPrinterError(Self) // EJECUTA OnPrinterError
  else
  begin
    if Status = OffLine then
      raise EPrinterError.Create(
           'La impresora esta fuera de linea. '+
           'Pongala en estado en linea antes de volver a intentar' )
    else if Status = SinPapel then
      raise EPrinterError.Create( 'La impresora se ha quedado sin papel. '+
            'Agregue papel antes de volver a intentar' )
    else if Status = Apagada then
      raise EPrinterError.Create( 'La impresora está apagada o desenchufada. '+
            'Enciendala antes de volver a intentar' )
    else
      raise EPrinterError.Create(
            'Ha ocurrido un error desconocido en la impresora. '+
            'Solucionelo antes de volver a intentar' );
  end;
end;

function TAKPrinter.Status : TStatus;
var
  Buff: array[0..255] of Char;
  Pto : Word;
  Rdo : byte;
  Confirmado : boolean;
  TextoError : string;
  Estado : TStatus;
  Len : longint;
begin

  try

    StrPCopy(Buff, '\SOFTWARE\Microsoft\Windows NT');

    Len := 255;

    if (RegQueryValue(HKEY_LOCAL_MACHINE, Buff, Buff, Len) <> ERROR_SUCCESS)
       and (UpperCase(Copy(FFastPuerto,1,3))='LPT') then   // ES WINDOWS 95
    begin

      Estado     := Desconocido;
      Confirmado := False;

      while (Estado <> Lista) and (not Confirmado) do
      begin

        try
          Pto := StrToInt(FFastPuerto[Length(FFastPuerto)]) - 1;
        finally
        end;

        asm
          MOV  DX,Pto
          MOV  AX,$0200  {AH := $02 : Leer el estado de la impresora}
          INT  $17
          MOV  Rdo,AH     {Guarda el estado en AL}
        end;

        if Rdo = 144 then
          Estado := Lista

        else if Rdo = 24 then
        begin
          Estado := OffLine;
          TextoError := 'La impresora se encuentra fuera de linea. '+
                        'Solucione el problema y reintente.';
        end else if Rdo = 56 then
        begin
          Estado := SinPapel;
          TextoError := 'La impresora se encuentra sin papel. '+
                        'Solucione el problema y reintente.';
        end else if Rdo = 32 then
        begin
          Estado := Apagada;
          TextoError := 'La impresora se encuentra apagada. '+
                        'Solucione el problema y reintente.';
        end else
        begin
            Estado := Desconocido;
            TextoError := 'La impresora tiene un problema desconocido. '+
                          'Solucione el problema y reintente.';
        end;

        if Estado <> Lista then
        begin
          if MessageDlg(TextoError,mtError,[mbRetry,mbCancel],0) = mrCancel then
            Confirmado := True;
        end;

      end;  // while

      Status := Estado;

    end else   // ESTAMOS EN WINDOWS NT
    begin
      Status := Lista; // aunque puede no estar lista :-(
    end;

  finally
  end;

end;

// MANDA UNA PAGINA A LA IMPRESORA
function TAKPrinter.ImprimirPaginaFast(Numero:integer): Boolean;
var
  Impresora: TextFile; // Impresora
  LA: integer;  // LA - Line Actual
  LinePrint: String;
  Pagina : PPagina;
  Fuente : TFuente;
  LastEscritura: Integer;
  EstadoImpresora : TStatus;
begin

  try

    result := True;
    EstadoImpresora := Status;

    if EstadoImpresora <> Lista then
    begin
      Result := False;
      Exit;
    end;

    AssignFile(Impresora,FFastPuerto);
    ReWrite(Impresora);
    ImprimirCodigo( Impresora, PRNReset);
    ImprimirCodigo( Impresora, PRNSetup);

    Fuente := FFuente;
    PrintFont( Impresora, Fuente);

    EstadoImpresora := Status;

    if EstadoImpresora <> Lista then
      raise EPrinterError.Create( 'Se ha cancelado la impresión' );

    LastEscritura := 0;

    Pagina := LasPaginas.Items[Numero-1];

    // SE IMPRIMEN TODAS LAS LINEAS
    for LA := 1 to Min( Pagina.LineasImpresas, Lineas) do
    begin
      LinePrint := '';
      ImprimirLinea( Impresora, Pagina, Fuente, LastEscritura, LA, LinePrint);
    end;

    Write(Impresora,#12);

  except
    ErrorDeImpresion(Status);    // si hay un error durante la impresion...
    result := False;
  end;

  {$I-}
  CloseFile(Impresora);
  {$I+}

end;

procedure TAKPrinter.ImprimirTodo; // MANDA LA IMPRESION A LA IMPRESORA
var
  Imagen: TMetaFile;
  i: integer;
  Bien: boolean;
  Copias: integer;
begin // IMPRIMIR

  if (FModo = pmWindows) then
  begin

    Printer.Title := Title;
    Printer.Copies := FCopias;
    Printer.BeginDoc;
    Imagen := TMetaFile.Create;
    Imagen.Width := PrintingWidth{PageWidth} div 4; // 640;
    Imagen.Height := PrintingHeight{PageHeight} div 4; // 1056;
    HacerHoja(1, Imagen, True);
    Printer.Canvas.StretchDraw( Rect( 0, 0,
                                     Printer.PageWidth,
                                     Printer.PageHeight),Imagen);
    if (LasPaginas.Count > 1) then
      for i := 2 to LasPaginas.Count do
      begin
        Printer.NewPage;
        HacerHoja( i, Imagen, True);
        Printer.Canvas.StretchDraw( Rect( 0, 0,
                                          Printer.PageWidth,
                                          Printer.PageHeight), Imagen);
      end;

    Printer.EndDoc;
    Imagen.Free;

  end else
  begin
    Bien := True;
    for Copias := 1 to FCopias do
      for i := 1 to LasPaginas.Count do
        if Bien then
          Bien := Bien and ImprimirPaginaFast(i);
  end;

end; // IMPRIMIR

procedure TAKPrinter.NuevaPagina;   // CREA UNA NUEVA PAGINA
var
  Pag : PPagina;
begin
  New(Pag);
  LasPaginas.Add(Pag);
  Pag^.Escritura := TList.Create;
  Pag^.LineasImpresas := 0;
  FPaginaActual := LasPaginas.IndexOf(Pag);
end;

procedure TAKPrinter.SetModeloName(Nombre : String);
begin
  if Nombre = 'CANNON F-60' then          SetModelo(Cannon_F60)
  else if Nombre = 'CANNON LASER' then    SetModelo(Cannon_Laser)
  else if Nombre = 'EPSON FX/LX/LQ' then  SetModelo(Epson_FX)
  else if Nombre = 'HP DESKJET' then      SetModelo(HP_Deskjet)
  else if Nombre = 'HP LASERJET' then     SetModelo(HP_Laserjet)
  else if Nombre = 'HP THINKJET' then     SetModelo(HP_Thinkjet)
  else if Nombre = 'IBM COLOR JET' then   SetModelo(IBM_Color_Jet)
  else if Nombre = 'IBM PC GRAPHICS' then SetModelo(IBM_PC_Graphics)
  else if Nombre = 'IBM PROPRINTER' then  SetModelo(IBM_Proprinter)
  else if Nombre = 'NEC 3500' then        SetModelo(NEC_3500)
  else if Nombre = 'NEC PINWRITER' then   SetModelo(NEC_Pinwriter);
end;

function TAKPrinter.GetModeloRealName(Model : TModelo) : String;
begin
  Case Model of
    Cannon_F60 : GetModeloRealName := 'CANNON F-60';
    Cannon_Laser : GetModeloRealName := 'CANNON LASER';
    Epson_FX : GetModeloRealName := 'EPSON FX/LX/LQ';
    HP_Deskjet : GetModeloRealName := 'HP DESKJET';
    HP_Laserjet : GetModeloRealName := 'HP LASERJET';
    HP_Thinkjet : GetModeloRealName := 'HP THINKJET';
    IBM_Color_Jet : GetModeloRealName := 'IBM COLOR JET';
    IBM_PC_Graphics : GetModeloRealName := 'IBM PC GRAPHICS';
    IBM_Proprinter : GetModeloRealName := 'IBM PROPRINTER';
    NEC_3500 : GetModeloRealName := 'NEC 3500';
    NEC_Pinwriter : GetModeloRealName := 'NEC PINWRITER';
  end;
end;

function TAKPrinter.GetModeloName : String;
begin
  GetModeloName := GetModeloRealName(FModelo);
end;

procedure TAKPrinter.GetModelos(Modelos : TStrings);
var
  i : integer;
begin
  Modelos.Clear;
  for i := Ord(Low(TModelo)) to Ord(High(TModelo)) do
    Modelos.Add(GetModeloRealName(TModelo(i)));
end;

// TAKPrintPreview

destructor TPrintPreview.Destroy;
begin
  Hoja.Free;
  inherited Destroy;
end;

procedure TPrintPreview.SetZoom(Valor : integer);
begin
  FZoom := Valor;
  ZoomShower.Value := Valor;
end;

procedure TPrintPreview.EscribirTamanioPapel;
var
  PAncho, PAlto, Tmp : Double;
begin

  PAncho := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH)/
            GetDeviceCaps(Printer.Handle, LOGPIXELSX);

  PAlto := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT)/
           GetDeviceCaps(Printer.Handle, LOGPIXELSY);

  if PAncho > PAlto then
  begin
    Tmp := PAncho;
    PAncho := PAlto;
    PAlto := Tmp;
  end;

  if (PANCHO = 8.5) and (PALTO = 14) then
    LSize.Caption := 'Oficio (8,5" x 14")'
  else if (PANCHO = 8.5) and (PALTO = 11) then
    LSize.Caption := 'Carta (8,5" x 11")'
  else if (PANCHO = 7.25) and (PALTO = 10.5) then
    LSize.Caption := 'Executivo (7,25" x 10,5")'
  else if (Round(PANCHO*100) = 433) and (Round(PALTO*100) = 866) then
    LSize.Caption := 'Sobre europeo (4,33" x 8,66")'
  else if (Round(PANCHO*100) = 827) and (Round(PALTO*100) >= 1167) and
                                        (Round(PALTO*100) <= 1169) then
    LSize.Caption := 'A4 (8,27" x 11,68")'
  else if (Round(PANCHO*100) = 413) and (Round(PALTO*10) = 95) then
    LSize.Caption := 'Sobre americano (4,13" x 9,5")'
  else
    LSize.Caption := 'Outro ('+FormatFloat('.00',PAncho)+
                     '" x '+FormatFloat('.00',PAlto)+'")'

end;

procedure TPrintPreview.CopiasChange(Sender: TObject);
begin
  TAKPrinter(TbPrinter).Copies := Copias.Value;
end;

procedure TPrintPreview.ZoomShowerChange(Sender: TObject);
begin
  FZoom := ZoomShower.Value;
  ShowerPaint(self);
end;

procedure TPrintPreview.ShowerPaint(Sender: TObject);
var
  Rect : TRect;
begin
  if (FZoom = 100) then
  begin
    Shower.Width := Hoja.Width+20;
    Shower.Height := Hoja.Height+20;
    Shower.Canvas.Draw(10,10,Hoja);
  end else
  begin
    Rect.Left := 10;
    Rect.Top := 10;
    Rect.Right := Round(Hoja.Width*FZoom/100);
    Rect.Bottom := Round(Hoja.Height*FZoom/100);
    Shower.Width := Round(Hoja.Width*FZoom/100)+10;
    Shower.Height := Round(Hoja.Height*FZoom/100)+10;
    Shower.Canvas.StretchDraw(Rect,Hoja);
  end;
end;

procedure TPrintPreview.BtnRealClick(Sender: TObject);
begin
  if Screen.Width = 640 then
    ZoomShower.Value := 88
  else if Screen.Width = 800 then
    ZoomShower.Value := 110
  else if Screen.Width = 1024 then
    ZoomShower.Value := 138
  else
    ZoomShower.Value := 154;
end;

procedure TPrintPreview.BtnWidthClick(Sender: TObject);
begin
  ZoomShower.Value := Round((Scroller.Width-36)*100/(Hoja.Width));
end;

procedure TPrintPreview.BtnCompletaClick(Sender: TObject);
var
  ZoomAncho, ZoomAlto : Double;
begin
  ZoomAncho := (Scroller.ClientWidth-15)*100/(Hoja.Width);
  ZoomAlto   := (Scroller.ClientHeight-15)*100/(Hoja.Height);
  if ZoomAncho < ZoomAlto then
    ZoomShower.Value := Round(ZoomAncho)
  else
    ZoomShower.Value := Round(ZoomAlto);
end;

procedure TPrintPreview.btnPagPrimeiraClick(Sender: TObject);
begin
  if FPagina > 1 then
  begin
    FPagina := 1;
    TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);
    LPagN.Caption := FormatFloat('00',FPagina);
    ShowerPaint(self);
    BtnPagPrimeira.Enabled := False;
    BtnPagAnterior.Enabled := False;
    if TAKPrinter(TbPrinter).Paginas > FPagina then
    begin
      BtnPagProxima.Enabled := True;
      BtnPagUltima.Enabled := True;
    end;
  end;
end;

procedure TPrintPreview.BtnPagAnteriorClick(Sender: TObject);
begin
  if FPagina > 1 then
  begin
    Dec(FPagina);
    TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);
    LPagN.Caption := FormatFloat('00',FPagina);
    ShowerPaint(self);
    if FPagina = 1 then
    begin
      BtnPagPrimeira.Enabled := False;
      BtnPagAnterior.Enabled := False;
    end;
    if TAKPrinter(TbPrinter).Paginas > FPagina then
    begin
      BtnPagProxima.Enabled := True;
      BtnPagUltima.Enabled := True;
    end;
  end;
end;

procedure TPrintPreview.BtnPagProximaClick(Sender: TObject);
begin

  if FPagina < TAKPrinter(TbPrinter).Paginas then
  begin

    Inc(FPagina);
    TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);
    LPagN.Caption := FormatFloat('00',FPagina);
    ShowerPaint(self);

    if FPagina = TAKPrinter(TbPrinter).Paginas then
    begin
      BtnPagProxima.Enabled := False;
      BtnPagUltima.Enabled := False;
    end;

    if FPagina > 1 then
    begin
      BtnPagAnterior.Enabled := True;
      BtnPagPrimeira.Enabled := True;
    end;

  end;

end;

procedure TPrintPreview.BtnPagUltimaClick(Sender: TObject);
begin
  if FPagina < TAKPrinter(TbPrinter).Paginas then
  begin
    BtnPagProxima.Enabled := False;
    BtnPagUltima.Enabled := False;
    FPagina := TAKPrinter(TbPrinter).Paginas;
    TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);
    LPagN.Caption := FormatFloat('00',FPagina);
    ShowerPaint(self);
    if FPagina > 1 then
    begin
      BtnPagAnterior.Enabled := True;
      BtnPagPrimeira.Enabled := True;
    end;
  end;
end;

procedure TPrintPreview.BtnImpAtualClick(Sender: TObject);
begin
  TAKPrinter(TbPrinter).ImprimirPagina(FPagina);
end;

procedure TPrintPreview.BtnImpTodoClick(Sender: TObject);
begin
  TAKPrinter(TbPrinter).ImprimirTodo;
  Close;
end;

procedure TPrintPreview.BtnGravarTudoClick(Sender: TObject);
begin
  TAKPrinter(TbPrinter).GravarTudo;
end;

procedure TPrintPreview.FormShow(Sender: TObject);
var
  ZoomAncho,ZoomAlto : double;
begin

  FPagina := 1;

  if TAKPrinter(TbPrinter).Paginas = 1 then
  begin
    BtnPagPrimeira.Enabled := False;
    BtnPagAnterior.Enabled := False;
    BtnPagProxima.Enabled  := False;
    BtnPagUltima.Enabled   := False;
    BtnImpAtual.Enabled    := False;
  end else
  begin
    BtnPagPrimeira.Enabled := False;
    BtnPagAnterior.Enabled := False;
  end;

  LTotPag.Caption := '/ '+FormatFloat('00',TAKPrinter(TbPrinter).Paginas);
  TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);

  if TAKPrinter(TbPrinter).Zoom = zReal then
    BtnRealClick(Sender)
  else if TAKPrinter(TbPrinter).Zoom = zWidth then
    ZoomShower.Value := Round( (Screen.Width-PrinterPanel.Width-36)*100/
                                       (Hoja.Width))
  else  // a lo alto
  begin
    ZoomAncho := (Screen.Width-PrinterPanel.Width)*100/(Hoja.Width);
    ZoomAlto := (Scroller.Height-10)*100/(Hoja.Height);
    if ZoomAncho < ZoomAlto then
      ZoomShower.Value := Round(ZoomAncho)
    else
      ZoomShower.Value := Round(ZoomAlto);
  end;

  Copias.Value := TAKPrinter(TbPrinter).Copies;
  BtnImpTodo.SetFocus;

end;

procedure TPrintPreview.ShowerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  RealPositionH : integer;
  RealPositionV : integer;
  Muestra : integer;
begin

  RealPositionH := {Scroller.HorzScrollBar.ScrollPos +} X;
  RealPositionV := {Scroller.VertScrollBar.Position +} Y;

  if (Button = mbLeft) and (fZoom+40 <= ZoomShower.MaxValue) then
    SetZoom(Round(fZoom) + 40)
  else if (Button = mbLeft) and (fZoom < ZoomShower.MaxValue) then
    SetZoom(ZoomShower.MaxValue)
  else if (Button = mbRight)and (fZoom-40 >= ZoomShower.MinValue) then
    SetZoom(Round(fZoom) - 40)
  else if (Button = mbRight)and (fZoom > ZoomShower.MinValue) then
    SetZoom(ZoomShower.MinValue);

  if Scroller.HorzScrollBar.Visible then  // HAY MOVIMIENTO HORIZONTAL
  begin
    Muestra := Scroller.Width;
    if Shower.Width < Muestra then
      Muestra := Shower.Width;
    if RealPositionH < (Muestra * 0.5) then
      Scroller.HorzScrollBar.Position := 0
    else
      Scroller.HorzScrollBar.Position := RealPositionH - (Muestra div 2);
  end;

  if Scroller.VertScrollBar.Visible then // HAY MOVIMIENTO VERTICAL
  begin
    Muestra := Scroller.Height;
    if Shower.Height < Muestra then
      Muestra := Shower.Height;
    if RealPositionV < (Muestra * 0.5) then
      Scroller.VertScrollBar.Position := 0
    else
      Scroller.VertScrollBar.Position := RealPositionV - (Muestra div 2);
  end;

end;

procedure TPrintPreview.ModoImpresionClick(Sender: TObject);
begin

  if ModoImpresion.ItemIndex = 0 then
    TAKPrinter(TbPrinter).Mode := pmFast
  else
    TAKPrinter(TbPrinter).Mode := pmWindows;

  if TAKPrinter(TbPrinter).Mode = pmWindows then
  begin
    ActualPrinter.Items := Printer.Printers;
    ActualPrinter.ItemIndex := Printer.PrinterIndex;
  end else
  begin
    TAKPrinter(TbPrinter).GetModelos(ActualPrinter.Items);
    ActualPrinter.ItemIndex := Ord(TAKPrinter(TbPrinter).FastPrinter);
  end;

end;

procedure TPrintPreview.ActualPrinterChange(Sender: TObject);
var
  ADevice, ADriver, APort : array [0..255] of char;
  DeviceMode : THandle;
  ImpresoraAnterior : integer;
begin

  with TAKPrinter(TbPrinter) do
  begin
  
    if TAKPrinter(TbPrinter).Mode = pmWindows then
    begin
      ImpresoraAnterior := Printer.PrinterIndex;
      try
        Printer.PrinterIndex := ActualPrinter.ItemIndex;
        WinPrinter := ActualPrinter.Items[ActualPrinter.ItemIndex];
        PageOrientation := Printer.Orientation;
        PageWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
        PageHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
        PageWidthP := PageWidth/GetDeviceCaps(Printer.Handle, LOGPIXELSX);
        PageHeightP :=PageHeight/GetDeviceCaps(Printer.Handle, LOGPIXELSY);
        Lineas := Trunc( PageHeightP*6)-2;
        Printer.GetPrinter(ADevice, ADriver, APort, DeviceMode);
        WinPort := APort;
        WinPrinter := ADevice;
        EscribirTamanioPapel;
      except
        MessageDlg(
          'O controlador da impresora seleccionada nao funciona adequadamente.',
          mtError,[mbOk],0);
        ActualPrinter.ItemIndex := ImpresoraAnterior;
        Printer.PrinterIndex := ImpresoraAnterior;
        WinPrinter := ActualPrinter.Items[ImpresoraAnterior];
      end;
    end else
      SetModeloName(ActualPrinter.Items[ActualPrinter.ItemIndex]);

    HacerHoja(FPagina,Hoja,False);

  end;

end;

procedure TPrintPreview.btnPropriedadesClick(Sender: TObject);
var
  ADevice, ADriver, APort : array [0..255] of char;
  DeviceMode: THandle;
  PrnSet: TPrinterSetupDialog;
begin

  PrnSet := TPrinterSetupDialog.Create(self);
  PrnSet.Execute;
  PrnSet.Free;

  if TAKPrinter(TbPrinter).Mode = pmWindows then
    ActualPrinter.ItemIndex := Printer.PrinterIndex;

  try

    with TAKPrinter(TbPrinter) do
    begin
      PageOrientation := Printer.Orientation;
      PageWidth := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
      PageHeight := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
      PageWidthP := PageWidth/GetDeviceCaps(Printer.Handle, LOGPIXELSX);
      PageHeightP := PageHeight/GetDeviceCaps(Printer.Handle, LOGPIXELSY);

      Printer.GetPrinter(ADevice, ADriver, APort, DeviceMode);

      WinPort := APort;
      WinPrinter := ADevice;

      EscribirTamanioPapel;

      if Lineas <> Trunc(PageHeightP*6)-2 then
        Lineas := Trunc(PageHeightP*6)-2;

    end;

  except
  end;

  Hoja.Free;
  Hoja := TMetaFile.Create;
  Hoja.Width := Round(TAKPrinter(TbPrinter).PageWidthP * 80);
  Hoja.Height := Round(TAKPrinter(TbPrinter).PageHeightP * 80);
  TAKPrinter(TbPrinter).HacerHoja(FPagina,Hoja,False);
  Shower.Invalidate;

end;

procedure TPrintPreview.FormKeyPress(Sender: TObject; var Key: Char);
begin

   if (Key = '+') then
     ZoomShower.Value :=  ZoomShower.Value + ZoomShower.Increment
   else if (Key = '-') then
     ZoomShower.Value :=  ZoomShower.Value - ZoomShower.Increment
   else if (Key = '=') then
     btnWidth.Click;

  inherited;

end;

procedure TPrintPreview.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_NEXT) and btnPagProxima.Enabled then
    btnPagProxima.Click
  else if (Key = VK_PRIOR) and btnPagAnterior.Enabled then
    btnPagAnterior.Click
  else if (Key = VK_DOWN) then
  begin
    Scroller.VertScrollBar.Position := Scroller.VertScrollBar.Position + 2;
    Key := 0;
  end else if (Key = VK_UP) then
  begin
    Scroller.VertScrollBar.Position := Scroller.VertScrollBar.Position - 2;
    Key := 0;
  end;

  inherited;
end;

constructor TPrintPreview.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  KeyPreview := True;
  OnKeyDown  := FormKeyDown;
  OnKeyPress := FormKeyPress;

  Left := 0;
  Top := 0;
  Width := Screen.Width - 30;
  Height := Screen.Height - 30;
  Caption := 'Prévia de Impressão';
  Color := clWindow;
  Ctl3D := False;
  Font.Charset := DEFAULT_CHARSET;
  Font.Color := clWindowText;
  Font.Height := -11;
  Font.Name := 'MS Sans Serif';
  Font.Style := [];

  OldCreateOrder := True;
  Position := poScreenCenter;
  WindowState := wsMaximized;
  OnShow := FormShow;
  PixelsPerInch := 96;

  Rate := Canvas.TextWidth('W') / 11;
  RateHeigth := Canvas.TextHeight('W') / 11;

  PrinterPanel := TPanel.Create(Self);
  with PrinterPanel do
  begin
    Parent := Self;
    Left := 0;
    Top := 0;
    Width := 790;
    Height := Round(Rate * 90);
    Align := alTop;
    BevelInner := bvSpace;
    BevelOuter := bvLowered;
  end;

  ModoImpresion := TRadioGroup.Create(PrinterPanel);
  with ModoImpresion do
  begin
    Parent := PrinterPanel;
    Left := Round( Rate * 5);
    Top := Round( Rate * 5);
    Width := Round( Rate * 150);
    Height := Round( Rate * 40);
    Caption := ' Modo de Impressão ';
    Columns := 2;
    Items.Append('Fast');
    Items.Append('Windows');
    OnClick := ModoImpresionClick;
  end;

  LPrinter := TLabel.Create(PrinterPanel);
  with LPrinter do
  begin
    Parent := PrinterPanel;
    Caption := 'Impressora selecionada';
    Left := ModoImpresion.Left+ModoImpresion.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := 8;
    AutoSize := True;
    Height := 13;
  end;

  ActualPrinter := TComboBox.Create(PrinterPanel);
  with ActualPrinter do
  begin
    Parent := PrinterPanel;
    Left := LPrinter.Left;
    Top := 23;
    Width := Round( Rate * 190);
    Height := 21;
    Style := csDropDownList;
    ItemHeight := 13;
    OnChange := ActualPrinterChange;
  end;

  LCopias := TLabel.Create(PrinterPanel);
  with LCopias do
  begin
    Parent := PrinterPanel;
    Left := ActualPrinter.Left+ActualPrinter.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := 7;
    Height := 13;
    Caption := 'Cópias:';
    AutoSize := True;
  end;

  Copias := TSpinEdit.Create(PrinterPanel);
  with Copias do
  begin
    Parent := PrinterPanel;
    Left := LCopias.Left;
    Top := 22;
    Width := Round( Rate * 50);
    Height := 22;
    MaxValue := 500;
    MinValue := 1;
    Value := 1;
    OnChange := CopiasChange;
  end;

  LTamanio := TLabel.Create(PrinterPanel);
  with LTamanio do
  begin
    Parent := PrinterPanel;
    Left := Copias.Left + Copias.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := 27;
    Height := 13;
    Caption := 'Papel:';
    AutoSize := True;
  end;

  LSize := TLabel.Create(PrinterPanel);
  with LSize do
  begin
    Parent := PrinterPanel;
    Left := LTamanio.Left + LTamanio.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := 25;
    Width := Round( Rate * 106);
    Height := 16;
    Caption := 'Actual Paper Size';
    Font.Color := clBlue;
  end;

  LPag := TLabel.Create(PrinterPanel);
  with LPag do
  begin
    Parent := PrinterPanel;
    Left := Round( Rate * 5);
    Top := 61;
    Caption := 'Página:';
    AutoSize := True;
  end;

  LPagN := TLabel.Create(PrinterPanel);
  with LPagN do
  begin
    Parent := PrinterPanel;
    Left := LPag.Left + LPag.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := LPag.Top;
    Caption := '01';
    Font.Color := clBlue;
    AutoSize := True;
  end;

  LTotPag := TLabel.Create(PrinterPanel);
  with LTotPag do
  begin
    Parent := PrinterPanel;
    Left := LPagN.Left + LPagN.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := LPagN.Top;
    Caption := ' / 01';
    Font.Color := clBlue;
    AutoSize := True;
  end;

  LZoom := TLabel.Create(PrinterPanel);
  with LZoom do
  begin
    Parent := PrinterPanel;
    Left := LTotPag.Left + LTotPag.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := LTotPag.Top;
    Caption := 'Zoom:';
    AutoSize := True;
  end;

  ZoomShower := TSpinEdit.Create(PrinterPanel);
  with ZoomShower do
  begin
    Parent := PrinterPanel;
    Left := LZoom.Left + LZoom.Width + Round( Rate * SEPARATOR_WIDTH);
    Top := ModoImpresion.Top + ModoImpresion.Height + Round( RateHeigth * SEPARATOR_HEIGTH);
    Width := Round( Rate * 45);
    Height := 22;
    Increment := 5;
    MaxValue := 400;
    MinValue := 20;
    Value := 20;
    OnChange := ZoomShowerChange;
  end;

  btnPagPrimeira := TBitBtn.Create(PrinterPanel);
  with btnPagPrimeira do
  begin
    Caption := 'Primeira';
    Parent := PrinterPanel;
    Left := ZoomShower.Left + ZoomShower.Width + Round( Rate*SEPARATOR_WIDTH*2);
    Top := ZoomShower.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := 25;
    Hint := 'Vai para Primeira Página';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := btnPagPrimeiraClick;
    NumGlyphs := 2;
  end;

  btnPagAnterior := TBitBtn.Create(PrinterPanel);
  with btnPagAnterior do
  begin
    Caption := 'Anterior';
    Parent := PrinterPanel;
    Left := btnPagPrimeira.Left+btnPagPrimeira.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnPagPrimeira.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnPagPrimeira.Height;
    Hint := 'Vai para Página Anterior';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnPagAnteriorClick;
    NumGlyphs := 2;
  end;

  btnPagProxima := TBitBtn.Create(PrinterPanel);
  with btnPagProxima do
  begin
    Caption := 'Próxima';
    Parent := PrinterPanel;
    Left := btnPagAnterior.Left+btnPagAnterior.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnPagAnterior.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnPagAnterior.Height;
    Hint := 'Vai para Próxima Página';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnPagProximaClick;
    NumGlyphs := 2;
  end;

  btnPagUltima := TBitBtn.Create(PrinterPanel);
  with btnPagUltima do
  begin
    Caption := 'Ultima';
    Parent := PrinterPanel;
    Left := btnPagProxima.Left+btnPagProxima.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnPagProxima.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnPagProxima.Height;
    Hint := 'Vai para Última Página';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnPagUltimaClick;
    NumGlyphs := 2;
  end;

  // Botoes de Redimensionamento da Visualizacao

  btnReal := TBitBtn.Create(PrinterPanel);
  with btnReal do
  begin
    Caption := 'Real';
    Parent := PrinterPanel;
    Left := btnPagUltima.Left+btnPagUltima.Width+Round( Rate * SEPARATOR_WIDTH * 2);
    Top := btnPagUltima.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnPagUltima.Height;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnRealClick;
    NumGlyphs := 2;
  end;

  btnWidth := TBitBtn.Create(PrinterPanel);
  with btnWidth do
  begin
    Caption := 'Width';
    Parent := PrinterPanel;
    Left := btnReal.Left+btnReal.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnReal.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnReal.Height;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnWidthClick;
    NumGlyphs := 2;
  end;

  btnCompleta := TBitBtn.Create(PrinterPanel);
  with btnCompleta do
  begin
    Caption := 'Full';
    Parent := PrinterPanel;
    Left := btnWidth.Left+btnWidth.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnWidth.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnWidth.Height;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnCompletaClick;
    NumGlyphs := 2;
  end;

  // Botoes de Impressao

  btnImpAtual := TBitBtn.Create(PrinterPanel);
  with btnImpAtual do
  begin
    Caption := 'Imp. Atual';
    Parent := PrinterPanel;
    Left := btnCompleta.Left+btnCompleta.Width+Round( Rate * SEPARATOR_WIDTH * 2);
    Top := btnCompleta.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnCompleta.Height;
    Hint := 'Imprime a Página Atual';
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnImpAtualClick;
    NumGlyphs := 2;
  end;

  btnImpTodo := TBitBtn.Create(PrinterPanel);
  with btnImpTodo do
  begin
    Caption := 'Imp. Tudo';
    Parent := PrinterPanel;
    Left := btnImpAtual.Left+btnImpAtual.Width+Round( Rate * SEPARATOR_WIDTH);
    Top := btnImpAtual.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnImpAtual.Height;
    OnClick := BtnImpTodoClick;
    NumGlyphs := 2;
  end;

  // Botao de Configuracao de Impressao

  btnPropriedades := TBitBtn.Create(PrinterPanel);
  with btnPropriedades do
  begin
    Caption := 'Propriedades';
    Parent := PrinterPanel;
    Left := btnImpTodo.Left+btnImpTodo.Width + Round( Rate * SEPARATOR_WIDTH * 2);
    Top := btnImpTodo.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnImpTodo.Height;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := btnPropriedadesClick;
    NumGlyphs := 2;
  end;

  btnSalvar := TBitBtn.Create(PrinterPanel);
  with btnSalvar do
  begin
    Caption := '&Gravar';
    Parent := PrinterPanel;
    Left := btnPropriedades.Left+btnPropriedades.Width + Round( Rate * SEPARATOR_WIDTH * 2);
    Top := btnPropriedades.Top;
    Width := Canvas.TextWidth(Caption) + Round( Rate * SEPARATOR_WIDTH * 3);
    Height := btnPropriedades.Height;
    ParentShowHint := False;
    ShowHint := True;
    OnClick := BtnGravarTudoClick;
    NumGlyphs := 2;
  end;

  Scroller := TScrollBox.Create(Self);
  with Scroller do
  begin
    Parent := Self;
    Align := alClient;;
    BorderStyle := bsNone;
  end;

  Shower := TPaintBox.Create(Scroller);
  with Shower do
  begin
    Parent := Scroller;
    Left := 0;
    Top := 0;
    Width := 332;
    Height := 427;
    Cursor := 1;
    Font.Charset := DEFAULT_CHARSET;
    Font.Color := clWindowText;
    Font.Height := -13;
    Font.Name := 'Courier';
    Font.Pitch := fpFixed;
    Font.Style := []    ;
    ParentFont := False;
    OnMouseDown := ShowerMouseDown;
    OnPaint := ShowerPaint;
  end;

  Screen.Cursors[1] := LoadCursor( hInstance, 'AKZOOM');
  TbPrinter := Owner;
  FPagina := 1;

  Hoja := TMetaFile.Create;
  Hoja.Width  := Round(TAKPrinter(TbPrinter).PageWidthP * 80); //div 4;//640;
  Hoja.Height := Round(TAKPrinter(TbPrinter).PageHeightP * 80); //div 4;//1056;

  if (TAKPrinter(TbPrinter).Mode = pmWindows) then
  begin
    ModoImpresion.ItemIndex := 1;
    ActualPrinter.Items := Printer.Printers;
    ActualPrinter.ItemIndex := Printer.PrinterIndex;
  end else
  begin
    ModoImpresion.ItemIndex := 0;
    TAKPrinter(TbPrinter).GetModelos(ActualPrinter.Items);
    ActualPrinter.ItemIndex := Ord(TAKPrinter(TbPrinter).FastPrinter);
  end;

  EscribirTamanioPapel;

  //Shower.Width := Shower.Canvas.TextWidth('X')*80+20;
  //Shower.Height := Shower.Canvas.TextHeight('X')*66+20;

  Shower.Width  := Shower.Canvas.TextWidth('X')*
                   TAKPrinter(TbPrinter).Columnas+20;
  Shower.Height := Shower.Canvas.TextHeight('X')*
                   TAKPrinter(TbPrinter).LineaPiePagina+20;

end; // constructor Create

end.
