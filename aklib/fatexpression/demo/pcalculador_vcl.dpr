program pcalculador_clx;

uses
  Forms,
  ucalculador_vcl in 'ucalculador_vcl.pas' {Calculador},
  AKExpression in '..\AKExpression.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCalculador, Calculador);
  Application.Run;
end.
