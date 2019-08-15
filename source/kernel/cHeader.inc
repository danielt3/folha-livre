{                                                                              }
{ Standard compiler directives.                                                }
{                                                                              }

{$DEFINE OS_WIN32}
{$DEFINE CPU_INTEL386}

{$DESCRIPTION 'Delphi Fundamentals'}
{$EXTENDEDSYNTAX ON}
{$IOCHECKS ON}
{$LONGSTRINGS ON}
{$BOOLEVAL OFF}
{$OPTIMIZATION ON}
{$IFDEF DEBUG}
  {$ASSERTIONS ON}
  {$DEBUGINFO ON}
  {$OVERFLOWCHECKS ON}
  {$RANGECHECKS ON}
  {$WARNINGS ON}
  {$HINTS ON}
{$ELSE}
  {$ASSERTIONS OFF}
  {$DEBUGINFO OFF}
  {$OVERFLOWCHECKS OFF}
  {$RANGECHECKS OFF}
  {$WARNINGS OFF}
  {$HINTS OFF}
{$ENDIF}

