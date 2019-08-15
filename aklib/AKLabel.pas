{*
* TakLabel - Copyright 1999, 2000 by Allan Kardek Nepomuceno Lima
*  (allan_kardek@yahoo.com.br)
*  GNU GPL - General Public Lisence
*  Bugs, Sugestoes, Correcoes contacte-me por email

  TakLabel descendente de TLabel

  Propriedades adicionadas

  AttachTo: TAlignAttach - Acompanha/Aclopa no componente FocusControl
  Frame: TFrameBorder - Controla as bordas (Top, Left, rigth, bottom) do Label, varios estilos.
                  Frame.Enabled precisa esta True para usar o recurso de frame

  MouseEnter: TMouseEffect
     Controle a interface quando o mouse entra sobre o label.
     Para ativar o recurso MouseEnter.Enabled precisa esta True;

  MouseLeave: TMouseEffect - Controle a interface quando o mouse sai de sobre o label.
                             MouseLeave.Enabled precisa esta True;
  Blink: TBlink - Controla a cor da fonte do label.
         BLink.Style = blHiLo faz com que a cor alterne cfe intervalo (BLink.Interval)
         BLink.Style = blLink faz com que o label pisca cfe intervalo (BLink.Interval)
         Se BLink.Style estiver como blNone esse recurso fica desativado

 Eventos adicionados

 FOnMouseEnter: TNotifyEvent - Chama quando o mouse passa sobre o label
 FOnMouseLeave: TNotifyEvent - Chama quando o mouse sai de sobre o label

 ********************
 Historico
 ********************
 Versao 1.01 - Setembro/2002
    Propriedades adicionadas
    FAttachDistance: Word - Determina a distante do Label em relacao ao control Attached
    TMouseEffect.Font: TFont - Substitui a propriedade FontColor
    FURL: String - Endereco internet para ser executado quando o Label for clicado
}

{$IFNDEF QAKLIB}
unit AKLabel;
{$ENDIF}

{$I AKLib.inc}

interface

uses
  {$IFDEF LINUX}Libc,{$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, ShellAPI, Graphics, Controls, Forms, Dialogs, Menus,
  StdCtrls, ExtCtrls, Buttons, Mask, DBCtrls, ToolWin,
  {$ENDIF}
  {$IFDEF CLX}
  Qt, QStdCtrls, QControls, QExtCtrls, QGraphics, QForms, QButtons, QMenus, QDBCtrls,
  {$ENDIF}
  {$IFDEF AK_D6}
  Types,
  {$ENDIF}
  SysUtils, Classes, DB;

const
  {$IFDEF VCL}scAltDown = scAlt + vk_Down;{$ENDIF}
  {$IFDEF CLX}scAltDown = scAlt;{$ENDIF}

type

  TFrameStyle = (fsFrameBox, fsFrameSunken, fsFrameRaised,
                 fsFrameEtched, fsFrameBump, fsFrameSingle);

  TFrameBorder = Class(TPersistent)
  private
    FControl: TControl;
    FEnabled: Boolean;
    FBorder: TEdgeBorders;
    FStyle: TFrameStyle;
    procedure SetEnabled( Value: Boolean);
    procedure SetBorder( Value: TEdgeBorders);
    procedure SetStyle( Value: TFrameStyle);
  protected
    {protected}
  public
    constructor Create(Owner: TComponent);
    procedure Assign(Source: TPersistent); override;
  published
    property Enabled: Boolean read FEnabled write SetEnabled default False;
    property Border: TEdgeBorders read FBorder write SetBorder default [ebLeft, ebTop, ebRight, ebBottom];
    property Style: TFrameStyle read FStyle write SetStyle default fsFrameBox;
  end;  // TFrame

  TMouseEffect = class(TPersistent)
  private
    FColor: TColor;
    FFont: TFont;
    FEnabled: Boolean;
    FFrame: Boolean;
    FParentColor: Boolean;
    FParentFont: Boolean;
    procedure SetFont(Value: TFont);
  protected
    {protected}
  public
    constructor Create(Owner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Color: TColor read FColor write FColor;
    property Enabled: Boolean read FEnabled write FEnabled default False;
    property Font: TFont read FFont write SetFont;
    property Frame: Boolean read FFrame write FFrame default True;
    property ParentColor: Boolean read FParentColor write FParentColor default True;
    property ParentFont: Boolean read FParentFont write FParentFont default True;
  end;  // TMouseEffect

  TBlinkStyle  = (blNone, blBlink, blHiLo);

  TBlink  = class(TPersistent)
  private
    FLabel: TLabel;
    FHiColor: TColor;
    FLoColor: TColor;
    FInterval: Integer;
    FTimer: TTimer;
    FStyle: TBlinkStyle;
    procedure SetInterval( Value: Integer);
    procedure SetStyle( Value: TBlinkStyle);
    procedure FTimerOnTimer( Sender:TObject);
    procedure SetHiColor( Value: TColor);
    procedure SetLoColor( Value: TColor);
  protected
    {protected}
  public
    constructor Create(Owner: TComponent);
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Interval: Integer read FInterval write SetInterval;
    property Style: TBlinkStyle read FStyle write SetStyle default blNone;
    property HiColor: TColor read FHiColor write SetHiColor;
    property LoColor: TColor read FLoColor write SetLoColor;

  end;  // TmbLink

  TAttach = ( aaNone, aaTop, aaLeft, aaRight, aaBottom );

  TAKCustomLabel = class(TLabel)
  private
    FAttachTo: TAttach;
    FAttachDistance: Word;
    FBlink: TBlink;
    FFrame: TFrameBorder;
    FURL: String;

    FMouseEffectEnter: TMouseEffect;
    FMouseEffectLeave: TMouseEffect;

    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;

    procedure SetAttach( Value: TAttach);
    {$IFDEF VCL}
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMMouseEnter( var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave( var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
    {$ENDIF}
    procedure dbDrawEdge;
    procedure MousePaint( Mouse: TMouseEffect);
    procedure SetURL(const Value: string);
    procedure ShiftLabel;
  protected
    property AttachTo: TAttach read FAttachTo write SetAttach default aaNone;
    property AttachDistance: Word read FAttachDistance write FAttachDistance default 0;
    property Blink: TBlink read FBlink write FBlink;
    {$IFDEF CLX}
    procedure EnabledChanged; override;
    procedure VisibleChanged; override;
    procedure MouseEnter(AControl: TControl); override;
    procedure MouseLeave(AControl: TControl); override;
    {$ENDIF}
    property Frame: TFrameBorder read FFrame write FFrame;
    property URL: string read FURL write SetURL;
    property MouseEffectEnter: TMouseEffect read FMouseEffectEnter write FMouseEffectEnter;
    property MouseEffectLeave: TMouseEffect read FMouseEffectLeave write FMouseEffectLeave;
    {$IFDEF VCL}
    procedure Paint; override;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    {$IFDEF VCL}
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    {$ENDIF}
  end;

  TAKLabel = class(TAKCustomLabel)
  published
    property AttachTo;
    property AttachDistance;
    property Blink;
    property Frame;
    property MouseEffectEnter;
    property MouseEffectLeave;
    property URL;
    {$IFDEF CLX}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
  end;

  { TAKCustomEdit }

  TAKCustomEdit = class(TEdit)
  private
    FClickKey: TShortCut;
    FEditButton: TSpeedButton;
    FButtonSpacing: Integer;
    FOnButtonClick: TNotifyEvent;
    procedure SetButtonPosition;
    procedure SetButtonSpacing(const Value: Integer);
    procedure ButtonClick(Sender: TObject);
    {$IFDEF VCL}
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;
    {$ENDIF}
  protected
    property ClickKey: TShortCut read FClickKey write FClickKey default scAltDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$IFDEF CLX}
    procedure SetParent( const Value: TWidgetControl); override;
    {$ENDIF}
    {$IFDEF VCL}
    procedure SetParent(AParent: TWinControl); override;
    {$ENDIF}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    {$IFDEF CLX}
    procedure VisibleChanged; override;
    procedure EnabledChanged; override;
    {$ENDIF}
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalButton;
    property EditButton: TSpeedButton read FEditButton;
    property ButtonSpacing: Integer read FButtonSpacing write SetButtonSpacing;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  { TAKEdit }

  TAKEdit = class(TAKCustomEdit)
  published
    property ClickKey;
    property EditButton;
    property ButtonSpacing;
    property OnButtonClick;
  end;

  { TAKDBCustomEdit }

  TAKDBCustomEdit = class(TDBEdit)
  private
    FClickKey: TShortCut;
    FEditButton: TSpeedButton;
    FOnButtonClick: TNotifyEvent;
    FButtonSpacing: Integer;
    procedure SetButtonPosition;
    procedure SetButtonSpacing(const Value: Integer);
    procedure ButtonClick(Sender: TObject);
    {$IFDEF VCL}
    procedure CMEnabledchanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMBidimodechanged(var Message: TMessage); message CM_BIDIMODECHANGED;
    procedure CMVisiblechanged(var Message: TMessage); message CM_VISIBLECHANGED;    
    {$ENDIF}
  protected
    property ClickKey: TShortCut read FClickKey write FClickKey default scAltDown;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    {$IFDEF CLX}
    procedure SetParent( const Value: TWidgetControl); override;
    {$ENDIF}
    {$IFDEF VCL}
    procedure SetParent(AParent: TWinControl); override;
    {$ENDIF}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
    {$IFDEF CLX}
    procedure Visiblechanged; override;
    procedure Enabledchanged; override;
    {$ENDIF}
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer); override;
    procedure SetupInternalButton;
    property EditButton: TSpeedButton read FEditButton;
    property ButtonSpacing: Integer read FButtonSpacing write SetButtonSpacing;
    property OnButtonClick: TNotifyEvent read FOnButtonClick write FOnButtonClick;
  end;

  { TAKDBEdit }

  TAKDBEdit = class(TAKDBCustomEdit)
  published
    property ClickKey;
    property EditButton;
    property ButtonSpacing;
    property OnButtonClick;
  end;

{ TAKStatus }

  TGetStringEvent = function(Sender: TObject): string of object;
  TDataValueEvent = procedure(Sender: TObject; DataSet: TDataSet;
    var Value: Longint) of object;
  TAKLabelStyle = (kState, kRecordNo, kRecordSize);
  TAKStatusKind = dsInactive..dsCalcFields;

  TAKStatus = class(TCustomLabel)
  private
    FDataLink: TDataLink;
    FDataSetName: Boolean;
    FStyle: TAKLabelStyle;
    FCalcCount: Boolean;
    FCaptions: TStrings;
    FDefaultCaptions: TStrings;
    FRecordCount: Longint;
    FRecordNo: Longint;
    FOnGetDataName: TGetStringEvent;
    FOnGetRecNo: TDataValueEvent;
    FOnGetRecordCount: TDataValueEvent;
    function GetStatusKind(State: TDataSetState): TAKStatusKind;
    procedure CaptionsChanged(Sender: TObject);
    function GetDataSetName: string;
    procedure SetDataSetName(Value: Boolean);
    function GetDataSource: TDataSource;
    procedure SetDataSource(Value: TDataSource);
    function GetDatasetState: TDataSetState;
    procedure SetStyle(Value: TAKLabelStyle);
    procedure SetCaptions(Value: TStrings);
    procedure SetCalcCount(Value: Boolean);
  protected
    procedure Loaded; override;
    function GetLabelCaption: string;
    function GetCaption(State: TDataSetState): string; virtual;
    {$IFDEF CLX}function GetLabelText: WideString; override;{$ENDIF}
    {$IFDEF VCL}function GetLabelText: string; override;{$ENDIF}
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure UpdateData; virtual;
    procedure UpdateStatus; virtual;
    property Caption;
    property DataSetState: TDataSetState read GetDatasetState;
  published
    property DataSetName: Boolean read FDataSetName write SetDataSetName default False;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
    property Captions: TStrings read FCaptions write SetCaptions;
    property Style: TAKLabelStyle read FStyle write SetStyle default kState;
    property CalcRecCount: Boolean read FCalcCount write SetCalcCount default False;
    property Layout default tlCenter;
    property Align;
    property Alignment;
    property AutoSize;
    property Color;
    {$IFDEF VCL}
    property DragCursor;
    {$ENDIF}
    property DragMode;
    property Font;
{$IFDEF AK_D4}
    property Anchors;
    {$IFDEF VCL}
    property BiDiMode;
    property DragKind;
    property ParentBiDiMode;
    {$ENDIF}
    property Constraints;
{$ENDIF}
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent;
    property Visible;
    property WordWrap;
    property OnGetDataName: TGetStringEvent read FOnGetDataName write FOnGetDataName;
    property OnGetRecordCount: TDataValueEvent read FOnGetRecordCount
      write FOnGetRecordCount;
    property OnGetRecNo: TDataValueEvent read FOnGetRecNo write FOnGetRecNo;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF CLX}
    property OnMouseEnter;
    property OnMouseLeave;
    {$ENDIF}
    {$IFDEF WIN32}
    property OnStartDrag;
    {$ENDIF}
    {$IFDEF AK_D5}
    property OnContextPopup;
    {$ENDIF}
    {$IFDEF AK_D4}
      {$IFDEF VCL}
    property OnEndDock;
    property OnStartDock;
      {$ENDIF}
    {$ENDIF}
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AK Lib', [TAKLabel]);
  RegisterComponents('AK Lib', [TAKEdit]);
  RegisterComponents('AK Lib', [TAKDBEdit]);
  RegisterComponents('AK Lib', [TAKStatus]);
end;

{ TFrameBorder }

constructor TFrameBorder.Create(Owner: TComponent);
begin

  inherited Create;

  FEnabled := False;
  FBorder  := [ebLeft, ebTop, ebRight, ebBottom];
  FStyle   := fsFrameBox;

  if Owner is TControl then
    FControl := TControl(Owner)
  else
    FControl := NIL;

end;

procedure TFrameBorder.SetEnabled( Value: Boolean);
begin
  if (FEnabled <> Value) then
  begin
    FEnabled := Value;
    if (FControl <> NIL) then
      FControl.Invalidate;
  end;
end;

procedure TFrameBorder.SetBorder( Value: TEdgeBorders);
begin
  if (FBorder <> Value) then
  begin
    FBorder := Value;
    if (FControl <> NIL) then
      FControl.Invalidate;
  end;
end;

procedure TFrameBorder.SetStyle( Value: TFrameStyle);
begin
  if (FStyle <> Value) then
  begin
    FStyle := Value;
    if (FControl <> NIL) then
      FControl.Invalidate;
  end;
end;

procedure TFrameBorder.Assign( Source: TPersistent);
var
  s: TFrameBorder;
begin

  if (Source is TFrameBorder) then
  begin
    s := TFrameBorder(Source);
    FEnabled := s.Enabled;
    FBorder := s.FBorder;
    FStyle  := s.Style;
    if (FControl <> NIL) then
      FControl.Invalidate;
  end else
    inherited Assign(Source);

end;

{ TMouseEffect }

constructor TMouseEffect.Create(Owner: TComponent);
begin

  inherited Create;

  FEnabled     := False;
  FColor       := clBtnFace;
  FFont        := TFont.Create;
  FFrame       := True;
  FParentColor := True;
  FParentFont  := True;

end;

destructor TMouseEffect.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TMouseEffect.Assign( Source: TPersistent);
var
  s: TMouseEffect;
begin

  if (Source is TMouseEffect) then
  begin

    s := TMouseEffect(Source);

    FEnabled     := s.Enabled;
    FColor       := s.Color;
    FFont.Assign(s.Font);
    FFrame       := s.Frame;
    FParentColor := s.ParentColor;
    FParentFont  := s.ParentFont;

  end else
    inherited Assign(Source);

end;

procedure TMouseEffect.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

{ TBlink }

constructor TBlink.Create(Owner: TComponent);
begin

  inherited Create;

  FStyle    := blNone;
  FHiColor  := clBlue;
  FLoColor  := clNavy;
  FInterval := 300;

  FTimer := TTimer.Create(Owner);

  FTimer.Interval := FInterval;
  FTimer.Enabled  := False;
  FTimer.OnTimer  := FTimerOnTimer;

  if (Owner is TLabel) then
    FLabel := TLabel(Owner)
  else
    FLabel := NIL;

end;

destructor TBlink.Destroy;
begin
  FTimer.Free;
  inherited Destroy;
end;

procedure TBlink.Assign( Source: TPersistent);
var
  s: TBlink;
begin

  if (Source is TBlink) then
  begin

    s := TBlink(Source);

    FHiColor   := s.HiColor;
    FLoColor   := s.HiColor;
    FInterval  := s.Interval;
    FStyle     := s.Style;

    FTimer.Assign(s.FTimer);

    if Assigned(FLabel) then
      FLabel.Invalidate;

  end else
    inherited Assign(Source);

end;

procedure TBlink.FTimerOnTimer(Sender:TObject);
begin

  if (FStyle = blHilo) and Assigned(FLabel) then
  begin
    if (FLabel.Font.Color = FHiColor) then
      FLabel.Font.Color := FLoColor
    else
      FLabel.Font.Color := FHiColor;
  end;

  if (FStyle = blBLink) and Assigned(FLabel) then
  begin
    if (FLabel.Font.Color = FLabel.Color) then
       FLabel.Font.Color := FHiColor
    else
       FLabel.Font.Color := FLabel.Color;
  end;

end;

procedure TBlink.SetStyle( Value: TBlinkStyle);
begin

  if (FStyle <> Value) then
  begin
    FStyle := Value;
    FTimer.Enabled  := (Value in [blHilo,blBLink]);
    if Assigned(FLabel) then
      FLabel.Invalidate;
  end;

end;

procedure TBlink.SetInterval(Value: integer);
begin

  if (FInterval <> Value) then
  begin
    FInterval := Value;
    FTimer.Interval := FInterval;
    if Assigned(FLabel) then
      FLabel.Invalidate;
  end;

end;

procedure TBlink.SetHiColor(Value: TColor);
begin

  if (FHiColor <> Value) then
  begin
    FHiColor := Value;
    if Assigned(FLabel) then
      FLabel.Invalidate;
  end;

end;

procedure TBlink.SetLoColor(Value: TColor);
begin

  if (FLoColor <> Value) then begin
    FLoColor := Value;
    if Assigned(FLabel) then
      FLabel.Invalidate;
  end;

end;

{ TAKCustomLabel }

constructor TAKCustomLabel.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  FAttachTo       := aaNone;
  FAttachDistance := 0;
  FBlink          := TBlink.Create(Self);
  FFrame          := TFrameBorder.Create(Self);

  FMouseEffectEnter := TMouseEffect.Create(Self);
  FMouseEffectLeave := TMouseEffect.Create(Self);

end;

destructor TAKCustomLabel.Destroy;
begin

  FMouseEffectEnter.Free;
  FMouseEffectLeave.Free;

  FFrame.Free;
  FBlink.Free;

  inherited Destroy;

end;

procedure TAKCustomLabel.Click;
var
 {$IFDEF LINUX}Mailer,{$ENDIF}
 TempURL: string;
begin

  inherited Click;

  if Trim(FURL) = '' then
  begin
    // Se o caption for uma URL executa o programa correspondente
    if (Pos( '@', Caption) > 1) or
       (Pos( 'http', Caption) > 0) or (Pos( 'www.', Caption) > 0) then
      TempURL := Trim(Caption);
  end else
    TempUrl := Trim(FURL);

  if (TempURL <> '') then
  begin
    {$IFDEF VCL}
    ShellExecute( GetDesktopWindow(), 'open', PChar(TempURL), nil, nil, SW_SHOWNORMAL);
    {$ENDIF}
    {$IFDEF LINUX}
    Mailer := GetEnvironmentVariable('BROWSER');
    if (Mailer = '') then
      Mailer := 'netscape';
    Libc.System(PChar(Format('%s %s', [Mailer, TempURL])));
   {$ENDIF}
  end;

end;

{$IFDEF VCL}
procedure TAKCustomLabel.Paint;
begin
  inherited Paint;
  ShiftLabel;
  dbDrawEdge;
end;
{$ENDIF}

procedure TAKCustomLabel.dbDrawEdge;
var
  Rect: TRect;
  Canvas: TCanvas;
  {$IFDEF VCL}Flags: Integer;{$ENDIF}
  fStyle: TFrameStyle;
begin

  Rect   := Self.ClientRect;
  fStyle := FFrame.Style;

  {$IFDEF CLX}
  Canvas := Self.Bitmap.Canvas;
  case fStyle of
    fsFrameSingle: DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
    fsFrameBox:    DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
    fsFrameSunken: DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
    fsFrameRaised: DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
    fsFrameEtched: DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
    fsFrameBump:   DrawEdge( Canvas, Rect, esRaised, esLowered, Frame.Border);
  end;
  {$ENDIF}

  {$IFDEF VCL}
  Canvas := Self.Canvas;
  Flags  := 0;

  if FFrame.Enabled then
  begin
    if ebLeft in FFrame.Border then    Flags := Flags + BF_LEFT;
    if ebBottom in FFrame.Border then  Flags := Flags + BF_BOTTOM;
    if ebTop in FFrame.Border then     Flags := Flags + BF_TOP;
    if ebRight in FFrame.Border then   Flags := Flags + BF_RIGHT;
  end;  // if FFrameEnabled

  case fStyle of
    fsFrameSingle: DrawEdge( Canvas.Handle, Rect, BDR_SUNKENOUTER, Flags or BF_MONO);
    fsFrameBox:    DrawEdge( Canvas.Handle, Rect, EDGE_SUNKEN, Flags or BF_MONO);
    fsFrameSunken: DrawEdge( Canvas.Handle, Rect, EDGE_SUNKEN, Flags);
    fsFrameRaised: DrawEdge( Canvas.Handle, Rect, EDGE_RAISED, Flags);
    fsFrameEtched: DrawEdge( Canvas.Handle, Rect, EDGE_ETCHED, Flags);
    fsFrameBump:   DrawEdge( Canvas.Handle, Rect, EDGE_BUMP, Flags);
  end; // case
  {$ENDIF}

end;

procedure TAKCustomLabel.MousePaint( Mouse: TMouseEffect);
begin

  if Mouse.Enabled then
  begin

    Frame.Enabled := Mouse.Frame;

    if Mouse.ParentColor then
      ParentColor := True
    else
      Color := Mouse.Color;

    if Mouse.ParentFont then
      ParentFont := True
    else
      Font.Assign(Mouse.Font);

  end;

end;

procedure TAKCustomLabel.ShiftLabel;
begin

  { Procedimento de Suporte ao Aclopamento em FocusControl }
  if (FocusControl = NIL) or (AttachTo = aaNone) then
    Exit;

  case AttachTo of
    aaTop: begin
      if Top <> (FocusControl.Top - Height - FAttachDistance) then
        Top := (FocusControl.Top - Height - FAttachDistance);
      if Left <> FocusControl.Left then
        Left := FocusControl.Left;
      if Width <> FocusControl.Width then
        Width := FocusControl.Width;
      end;

    aaLeft: begin
      if Top <> FocusControl.Top then
        Top := FocusControl.Top;
      if Left <> (FocusControl.Left - Width - FAttachDistance) then
        Left := (FocusControl.Left - Width - FAttachDistance);
      if Height <> FocusControl.Height then
        Height := FocusControl.Height;
      end;

    aaRight: begin
      if Top <> FocusControl.Top then
        Top := FocusControl.Top;
      if Left <> (FocusControl.Left + FocusControl.Width + FAttachDistance) then
        Left := (FocusControl.Left + FocusControl.Width + FAttachDistance) ;
      if Height <> FocusControl.Height then
        Height := FocusControl.Height;
      end;

    aaBottom: begin
      if Top <> (FocusControl.Top + FocusControl.Height + FAttachDistance) then
        Top := (FocusControl.Top + FocusControl.Height + FAttachDistance);
      if Left <> FocusControl.Left then
        Left := FocusControl.Left;
      if Width <> FocusControl.Width then
        Width := FocusControl.Width;
      end;

    end;  // case

end;  // ShiftLabel

{$IFDEF CLX}
procedure TAKCustomLabel.MouseEnter(AControl: TControl);
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomLabel.CMMouseEnter(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  if Assigned(OnMouseEnter) and Enabled and Visible then
    OnMouseEnter(Self);
  if Enabled and Visible then
    MousePaint( MouseEffectEnter);
end;

{$IFDEF CLX}
procedure TAKCustomLabel.MouseLeave(AControl: TControl);
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomLabel.CMMouseLeave(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  if Assigned(OnMouseLeave) and Enabled and Visible then
    OnMouseLeave(Self);
  if Enabled and Visible then
    MousePaint(MouseEffectLeave);
end;

{$IFDEF CLX}
procedure TAKCustomLabel.EnabledChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomLabel.CMEnabledChanged( var Message: TMessage);
{$ENDIF}
begin
  Invalidate;
  if (FocusControl <> NIL) and (FAttachTo <> aaNone) then
    FocusControl.Enabled := Enabled;
end;

{$IFDEF CLX}
procedure TAKCustomLabel.VisibleChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomLabel.CMVisibleChanged(var Message: TMessage);
{$ENDIF}
begin
  Invalidate;
  if (FocusControl <> NIL) and (FAttachTo <> aaNone) then
    FocusControl.Visible := Enabled;
end;

procedure TAKCustomLabel.SetAttach( Value: TAttach );
begin
  if (Value <> FAttachTo) then
  begin
    FAttachTo := Value;
    if (FAttachTo <> aaNone) then
    begin
      AutoSize := False;
      Align    := alNone;
    end;
    Invalidate;
  end;
end;

procedure TAKCustomLabel.SetURL( const Value: String);
begin
  FURL := Value;
  if (Caption = Name) then
    Caption := Value;
end;

{ TAKCustomEdit }

constructor TAKCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonSpacing := 3;
  FClickKey := scAltDown;
  SetupInternalButton;
end;

{$IFDEF VCL}
procedure TAKCustomEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditButton.BiDiMode := BiDiMode;
end;
{$ENDIF}

{$IFDEF CLX}
procedure TAKCustomEdit.EnabledChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomEdit.CMEnabledChanged(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  FEditButton.Enabled := Enabled;
end;

{$IFDEF CLX}
procedure TAKCustomEdit.VisibleChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomEdit.CMVisibleChanged(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  FEditButton.Visible := Visible;
end;

procedure TAKCustomEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditButton) and (Operation = opRemove) then
    FEditButton := nil;
end;

procedure TAKCustomEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetButtonPosition;
end;

procedure TAKCustomEdit.SetButtonPosition;
var
  P: TPoint;
begin

  if FEditButton = nil then
    exit;

  P := Point(Left + Width + FButtonSpacing,
             Top + ((Height - FEditButton.Height) div 2));

  FEditButton.SetBounds( P.x, P.y, FEditButton.Width, FEditButton.Height);

end;

procedure TAKCustomEdit.SetButtonSpacing(const Value: Integer);
begin
  FButtonSpacing := Value;
  SetButtonPosition;
end;

procedure TAKCustomEdit.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  if csDesigning in ComponentState then
    Text := '';
end;

{$IFDEF CLX}
procedure TAKCustomEdit.SetParent(const Value: TwidgetControl);
{$ENDIF}
{$IFDEF VCL}
procedure TAKCustomEdit.SetParent(AParent: TWinControl);
{$ENDIF}
begin
  {$IFDEF CLX}inherited SetParent(Value);{$ENDIF}
  {$IFDEF VCL}inherited SetParent(AParent);{$ENDIF}
  if not Assigned(FEditButton) then
  begin
    FEditButton.Parent := {$IFDEF CLX}Value{$ENDIF}{$IFDEF VCL}AParent{$ENDIF};
    FEditButton.Visible := True;
  end;
end;

procedure TAKCustomEdit.ButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self);
end;

procedure TAKCustomEdit.SetupInternalButton;
begin
  if not Assigned(FEditButton) then
  begin
    FEditButton := TSpeedButton.Create(Self);
    FEditButton.Name := 'SubButton';
    FEditButton.FreeNotification(Self);
    FEditButton.Caption := '...';
    FEditButton.Font.Name := 'Arial';
    FEditButton.Font.Size := FEditButton.Font.Size + 2;
    FEditButton.Font.Style := FEditButton.Font.Style + [fsBold];
    FEditButton.Height := Self.Height;
    FEditButton.Width := 21;
    FEditButton.OnClick := ButtonClick;
  end;
end;

procedure TAKCustomEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (FClickKey = ShortCut(Key, Shift)) and (FEditButton.Width > 0) then begin
    ButtonClick(Self);
    Key := 0;
  end;
end;

{ TAKDBCustomEdit }

constructor TAKDBCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FButtonSpacing := 3;
  FClickKey := scAltDown;
  SetupInternalButton;
end;

{$IFDEF VCL}
procedure TAKDBCustomEdit.CMBidimodechanged(var Message: TMessage);
begin
  inherited;
  FEditButton.BiDiMode := BiDiMode;
end;
{$ENDIF}

{$IFDEF CLX}
procedure TAKDBCustomEdit.EnabledChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKDBCustomEdit.CMEnabledchanged(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  FEditButton.Enabled := Enabled;
end;

{$IFDEF CLX}
procedure TAKDBCustomEdit.VisibleChanged;
{$ENDIF}
{$IFDEF VCL}
procedure TAKDBCustomEdit.CMVisiblechanged(var Message: TMessage);
{$ENDIF}
begin
  inherited;
  FEditButton.Visible := Visible;
end;

procedure TAKDBCustomEdit.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FEditButton) and (Operation = opRemove) then
    FEditButton := nil;
end;

procedure TAKDBCustomEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  SetButtonPosition;
end;

procedure TAKDBCustomEdit.SetButtonPosition;
var
  P: TPoint;
begin

  if FEditButton = nil then exit;

  P := Point(Left + Width + FButtonSpacing,
             Top + ((Height - FEditButton.Height) div 2));

  FEditButton.SetBounds( P.x, P.y, FEditButton.Width, FEditButton.Height);

end;

procedure TAKDBCustomEdit.SetButtonSpacing(const Value: Integer);
begin
  if Value <> FButtonSpacing then
  begin
    FButtonSpacing := Value;
    SetButtonPosition;
  end;
end;

procedure TAKDBCustomEdit.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  if csDesigning in ComponentState then
    Text := '';
end;

{$IFDEF CLX}
procedure TAKDBCustomEdit.SetParent( const Value: TWidgetControl);
{$ENDIF}
{$IFDEF VCL}
procedure TAKDBCustomEdit.SetParent(AParent: TWinControl);
{$ENDIF}
begin
  {$IFDEF CLX}inherited SetParent(Value);{$ENDIF}
  {$IFDEF VCL}inherited SetParent(AParent);{$ENDIF}
  if FEditButton = nil then exit;
  {$IFDEF CLX}FEditButton.Parent := Value;{$ENDIF}
  {$IFDEF VCL}FEditButton.Parent := AParent;{$ENDIF}
  FEditButton.Visible := True;
end;

procedure TAKDBCustomEdit.ButtonClick(Sender: TObject);
begin
  if Assigned(FOnButtonClick) then
    FOnButtonClick(Self);
end;

procedure TAKDBCustomEdit.SetupInternalButton;
begin
  if not Assigned(FEditButton) then
  begin
    FEditButton := TSpeedButton.Create(Self);
    FEditButton.Name := 'SubButton';
    FEditButton.FreeNotification(Self);
    FEditButton.Caption := '...';
    FEditButton.Font.Name := 'Arial';
    FEditButton.Font.Size := FEditButton.Font.Size + 2;
    FEditButton.Font.Style := FEditButton.Font.Style + [fsBold];
    FEditButton.Height := Self.Height;
    FEditButton.Width := 21;
    FEditButton.OnClick := ButtonClick;
  end;
end;

procedure TAKDBCustomEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (FClickKey = ShortCut(Key, Shift)) and (FEditButton.Width > 0) then
  begin
    ButtonClick(Self);
    Key := 0;
  end;
end;

{ TStatusDataLink }

type
  TStatusDataLink = class(TDataLink)
  private
    FLabel: TAKStatus;
  protected
    procedure ActiveChanged; override;
    procedure EditingChanged; override;
    procedure DataSetChanged; override;
    procedure DataSetScrolled(Distance: Integer); override;
    procedure LayoutChanged; override;
  public
    constructor Create(ALabel: TAKStatus);
    destructor Destroy; override;
  end;

constructor TStatusDataLink.Create(ALabel: TAKStatus);
begin
  inherited Create;
  FLabel := ALabel;
end;

destructor TStatusDataLink.Destroy;
begin
  FLabel := nil;
  inherited Destroy;
end;

procedure TStatusDataLink.ActiveChanged;
begin
  DataSetChanged;
end;

procedure TStatusDataLink.DataSetScrolled(Distance: Integer);
begin
  if (FLabel <> nil) and (FLabel.Style = kRecordNo) then
    FLabel.UpdateStatus;
end;

procedure TStatusDataLink.EditingChanged;
begin
  if (FLabel <> nil) and (FLabel.Style <> kRecordSize) then
    FLabel.UpdateStatus;
end;

procedure TStatusDataLink.DataSetChanged;
begin
  if (FLabel <> nil) then
    FLabel.UpdateData;
end;

procedure TStatusDataLink.LayoutChanged;
begin
  if (FLabel <> nil) and (FLabel.Style <> kRecordSize) then
    DataSetChanged; { ??? }
end;

{ TAKStatus }

const
  GlyphSpacing = 2;
  GlyphColumns = 7;

constructor TAKStatus.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);

  Layout := tlCenter;
  ControlStyle := ControlStyle - [csSetCaption {$IFDEF WIN32}, csReplicatable {$ENDIF}];
  FRecordCount := -1;
  FRecordNo := -1;
  ShowAccelChar := False;
  FDataSetName := False;
  FDataLink := TStatusDataLink.Create(Self);
  FStyle := kState;
  FCaptions := TStringList.Create;
  TStringList(FCaptions).OnChange := CaptionsChanged;
  Caption := '';

  FDefaultCaptions := TStringList.Create;
  FDefaultCaptions.Add('dsInactive');
  FDefaultCaptions.Add('dsBrowse');
  FDefaultCaptions.Add('dsEdit');
  FDefaultCaptions.Add('dsInsert');
  FDefaultCaptions.Add('dsSetKey');
  FDefaultCaptions.Add('dsCalcFields');

end;

destructor TAKStatus.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  TStringList(FCaptions).OnChange := nil;
  FCaptions.Free;
  FCaptions := nil;
  FDefaultCaptions.Free;
  FDefaultCaptions := nil;
  inherited Destroy;
end;

procedure TAKStatus.Loaded;
begin
  inherited Loaded;
  UpdateData;
end;

function TAKStatus.GetLabelCaption: string;
begin
  if (csDesigning in ComponentState) and
     ( (FStyle = kState) or (FDatalink = nil) or not FDatalink.Active) then
    Result := Format( '(%s)', [Name])
  else if ((FDatalink = nil) or (DataSource = nil)) then
    Result := ''
  else begin
    case FStyle of
      kState:
         if (GetDataSetName = '') then
           Result := GetCaption(DataSource.State)
         else
           Result := Format('%s: %s', [GetDataSetName, GetCaption(DataSource.State)]);
      kRecordNo:
        if FDataLink.Active then
        begin
          if FRecordNo >= 0 then
          begin
            if FRecordCount >= 0 then
              Result := Format('%d:%d', [FRecordNo, FRecordCount])
            else
              Result := IntToStr(FRecordNo);
          end
          else begin
            if FRecordCount >= 0 then
              Result := Format('( %d )', [FRecordCount])
            else
              Result := '';
          end;
        end
        else Result := '';
      kRecordSize:
        if FDatalink.Active then
          Result := IntToStr(FDatalink.DataSet.RecordSize)
        else
          Result := '';
    end;
  end;
end;

function TAKStatus.GetDatasetState: TDataSetState;
begin
  if DataSource <> nil then
    Result := DataSource.State
  else
    Result := dsInactive;
end;

procedure TAKStatus.SetName(const Value: TComponentName);
begin
  inherited SetName(Value);
  if (csDesigning in ComponentState) then Invalidate;
end;

procedure TAKStatus.SetCaptions(Value: TStrings);
begin
  FCaptions.Assign(Value);
end;

function TAKStatus.GetStatusKind(State: TDataSetState): TAKStatusKind;
begin
{$IFDEF WIN32}
  if not (State in [Low(TAKStatusKind)..High(TAKStatusKind)]) then
  begin
    case State of
      dsFilter: Result := dsSetKey;
      {$IFDEF AK_D3}
      dsNewValue, dsOldValue, dsCurValue: Result := dsEdit;
      {$ELSE}
      dsUpdateNew, dsUpdateOld: Result := dsEdit;
      {$ENDIF}
      else Result := TAKStatusKind(State);
    end;
  end
  else
{$ENDIF WIN32}
    Result := TAKStatusKind(State);
end;

function TAKStatus.GetCaption(State: TDataSetState): string;
var
  Kind: TAKStatusKind;
begin
  Kind := GetStatusKind(State);
  if Assigned(FCaptions) and (Ord(Kind) < FCaptions.Count) and
     (FCaptions[Ord(Kind)] <> '') then
    Result := FCaptions[Ord(Kind)]
  else
    Result := FDefaultCaptions[Ord(Kind)];
end;

procedure TAKStatus.CaptionsChanged(Sender: TObject);
begin
  TStringList(FCaptions).OnChange := nil;
  try
    while (Pred(FCaptions.Count) > Ord(High(TAKStatusKind))) do
      FCaptions.Delete(FCaptions.Count - 1);
  finally
    TStringList(FCaptions).OnChange := CaptionsChanged;
  end;
  if not (csDesigning in ComponentState) then
    Invalidate;
end;

procedure TAKStatus.UpdateData;

  function IsSequenced: Boolean;
  begin
    {$IFDEF AK_D3}
    Result := FDatalink.DataSet.IsSequenced;
    {$ELSE}
    Result := not ((FDatalink.DataSet is TDBDataSet) and
      TDBDataSet(FDatalink.DataSet).Database.IsSQLBased);
    {$ENDIF}
  end;

begin

  FRecordCount := -1;

  if (FStyle = kRecordNo) and FDataLink.Active and (DataSource.State in [dsBrowse, dsEdit]) then
  begin
    if Assigned(FOnGetRecordCount) then
      FOnGetRecordCount(Self, FDataLink.DataSet, FRecordCount)
    else if (FCalcCount or IsSequenced) then
    begin
      {$IFDEF AK_D3}
      FRecordCount := FDataLink.DataSet.RecordCount;
      {$ELSE}
      FRecordCount := DataSetRecordCount(FDataLink.DataSet)
      {$ENDIF}
    end;
  end;

  UpdateStatus;

end;

procedure TAKStatus.UpdateStatus;
begin

  if (DataSource <> nil) and (FStyle = kRecordNo) then
  begin

    FRecordNo := -1;
    if FDataLink.Active then
    begin
      if Assigned(FOnGetRecNo) then
        FOnGetRecNo( Self, FDataLink.DataSet, FRecordNo)
      else
        try
          {$IFDEF AK_D3}
          with FDatalink.DataSet do
            if not IsEmpty then FRecordNo := RecNo;
          {$ELSE}
          FRecordNo := DataSetRecNo(FDatalink.DataSet);
          {$ENDIF}
        except
        end;
    end;  // FDataLink.Active

  end;

  {$IFDEF VCL}AdjustBounds;{$ENDIF}
  Invalidate;

end;

procedure TAKStatus.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and (AComponent = DataSource) then
    DataSource := nil;
end;

function TAKStatus.GetDataSetName: string;
begin
  Result := '';
  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FOnGetDataName) then
      Result := FOnGetDataName(Self)
    else if FDataSetName and Assigned(DataSource) and Assigned(DataSource.DataSet) then
      Result := DataSource.DataSet.Name;
  end;
end;

procedure TAKStatus.SetDataSetName(Value: Boolean);
begin
  if FDataSetName <> Value then
  begin
    FDataSetName := Value;
    Invalidate;
  end;
end;

function TAKStatus.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TAKStatus.SetDataSource(Value: TDataSource);
begin
  {$IFDEF AK_D4}
  if not (FDataLink.DataSourceFixed and (csLoading in ComponentState)) then
  {$ENDIF}
    FDataLink.DataSource := Value;
  {$IFDEF WIN32}
  if Value <> nil then
    Value.FreeNotification(Self);
  {$ENDIF}
  if not (csLoading in ComponentState) then
    UpdateData;
end;

procedure TAKStatus.SetCalcCount(Value: Boolean);
begin
  if FCalcCount <> Value then
  begin
    FCalcCount := Value;
    if not (csLoading in ComponentState) then UpdateData;
  end;
end;

procedure TAKStatus.SetStyle(Value: TAKLabelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    if not (csLoading in ComponentState) then
      UpdateData;
  end;
end;

{$IFDEF CLX}function TAKStatus.GetLabelText: WideString;{$ENDIF}
{$IFDEF VCL}function TAKStatus.GetLabelText: string;{$ENDIF}
begin
  Result := GetLabelCaption;
end;

end.
