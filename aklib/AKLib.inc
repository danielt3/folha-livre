{                                                                              }
{ Standard compiler directives.                                                }
{                                                                              }

// Opcoes de banco de dados

{.$DEFINE DBX}    // Database Express
{$DEFINE IBX}    // Interbase Express
{.$DEFINE IBO}    // Interbase Objects
{.$DEFINE ADO}    // Acess Data Objet
{.$DEFINE DBX}    // Database Express
{.$DEFINE ZEOS}   // Zeos Objects
{.$DEFINE MDO}    // Mercury DataBase Object

{$IFDEF IBX}
  {$DEFINE INTERBASE}
{$ENDIF}

{$IFDEF IBO}
  {$DEFINE INTERBASE}
{$ENDIF}

{$IFDEF MDO}
  {$DEFINE INTERBASE}
{$ENDIF}

// Versao do Delphi

{$IFDEF VER160} { Borland Delphi 8.0 }
  {$DEFINE AK_D8}
{$ENDIF}

{$IFDEF VER150} { Borland Delphi 7.0 }
  {$DEFINE AK_D7}
{$ENDIF}

{$IFDEF VER140} { Borland Delphi 6.0 }
  {$DEFINE AK_D6}
{$ENDIF}

{$IFDEF VER130} { Borland Delphi 5.0 }
  {$DEFINE AK_D5}
{$ENDIF}

{$IFDEF VER120} { Borland Delphi 4.0 }
  {$DEFINE AK_D4}
{$ENDIF}

{$IFDEF VER100} { Borland Delphi 3.0 }
  {$DEFINE AK_D3}
{$ENDIF}

{$IFDEF AK_D8}
  {$DEFINE AK_D7}
{$ENDIF}

{$IFDEF AK_D7}
  {$DEFINE AK_D6}
{$ENDIF}

{$IFDEF AK_D6}
  {$DEFINE AK_D5}
{$ENDIF}

{$IFDEF AK_D5}
  {$DEFINE AK_D4}
{$ENDIF}

{$IFDEF AK_D4}
  {$DEFINE AK_D3}
{$ENDIF}

{$IFDEF AK_D6}
  {$DEFINE AK_MIDASLIB}
{$ENDIF}

// Opcoes de plataformas

{$IFNDEF LINUX}
  {$DEFINE MSWINDOWS}
{$ENDIF}

// Opcoes de toolkit

{$IFDEF LINUX}
  {$DEFINE CLX}
  {$UNDEF VCL}
{$ENDIF}

{$IFNDEF CLX}
  {$DEFINE VCL}
{$ENDIF}
