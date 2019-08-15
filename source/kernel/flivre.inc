{
Projeto FolhaLivre - Folha de Pagamento Livre
Arquivo de definição de diretivas para o FolhaLivre

Copyright (c) 2002-2009 Allan Lima

O FolhaLivre é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

{                                                                              }
{ Standard compiler directives.                                                }
{                                                                              }

// Para que esse arquivo seja ignorado defina a diretiva NO_FLIVRE.INC em
// >Project>Options... na guia "Directories/Conditionals" no campo "Conditional defines"

{$IFNDEF NO_FLIVRE.INC}

  // Opcoes de banco de dados

  {$IFNDEF NO_DEFINE_ACESS}
    {.$DEFINE DBX}    // Database Express
    {.$DEFINE IBX}    // Interbase Express
    {.$DEFINE IBO}    // Interbase Objects
    {.$DEFINE ADO}    // Acess Data Objet
    {.$DEFINE DBX}    // Database Express
    {.$DEFINE ZEOS}   // Zeos Objects
  {$ENDIF}

  {$IFDEF IBX}
    {$DEFINE INTERBASE}
  {$ENDIF}

  {$IFDEF IBO}
    {$DEFINE INTERBASE}
  {$ENDIF}

  // Opcoes de plataformas

  {$IFNDEF LINUX}
    {$DEFINE MSWINDOWS}
  {$ENDIF}

  {$IFDEF LINUX}
    {$DEFINE CLX}   // O Kylix utiliza exclusivamente a CLX
    {$UNDEF VCL}
  {$ENDIF}

  {$IFNDEF CLX}
    {$DEFINE VCL}   // Utiliza a VCL como padrão
  {$ENDIF}

  {$DEFINE JEDI}
  {$DEFINE SYN_EDIT}
  {$DEFINE WALLPAPER}
  {$DEFINE AK_LIB}
  {$DEFINE AK_USER}
  {$DEFINE AK_LABEL}
  {$DEFINE RX_LIB}
  {$DEFINE VOLGAPAK}
  {.$DEFINE SPLASH_SCREEN}

  {.$DEFINE DELPHI_BOLETO}

  {$IFDEF CLX}
    {$UNDEF RX_LIB}    // A biblioteca RXLIB não está portada para CLX
    {$UNDEF AK_USER}   // O componente AKUSER não está portado para CLX
    {$UNDEF VOLGAPAK}
  {$ENDIF}

  {$IFDEF FLIVRE}
    {$UNDEF RX_LIB}
    {$UNDEF VOLGAPAK}
    {$UNDEF AK_USER}
    {$DEFINE FIREBIRD}
    {$UNDEF SPLASH_SCREEN}
  {$ENDIF}

  {$IFNDEF AK_LIB}      // Se a diretica AK_LIB (biblioteca) não estiver definida
     {$UNDEF AK_USER}   // desativa a diretiva AK_USER (componente)
     {$UNDEF AK_LABEL}
  {$ENDIF}

  {.$DEFINE DEBUG}

  // Versao do Delphi

  {$IFDEF VER200} { CodeGear Delphi 2009 (also defines VER200) }
    {$DEFINE FL_D2009}
  {$ENDIF}

  {$IFDEF VER185} { CodeGear Delphi 2007 (also defines VER180) }
    {$DEFINE FL_D2007}
  {$ENDIF}

  {$IFDEF VER180} { Borland Delphi 2006 10.x / Turbo Delphi / Delphi 2007 }   // JB
    {$DEFINE FL_2006}
  {$ENDIF}

  {$IFDEF VER170} { Borland Delphi 2005 9.x }   // JB
     {$DEFINE FL_2005}
  {$ENDIF}

  {$IFDEF VER160} { Borland Delphi 8.0 }
    {$DEFINE FL_D8}
  {$ENDIF}

  {$IFDEF VER150} { Borland Delphi 7.0 }
    {$DEFINE FL_D7}
  {$ENDIF}

  {$IFDEF VER140} { Borland Delphi 6.0 }
    {$DEFINE FL_D6}
  {$ENDIF}

  {$IFDEF VER130} { Borland Delphi 5.0 }
    {$DEFINE FL_D5}
  {$ENDIF}

  {$IFDEF VER120} { Borland Delphi 4.0 }
    {$DEFINE FL_D4}
  {$ENDIF}

  {$IFDEF VER100} { Borland Delphi 3.0 }
    {$DEFINE FL_D3}
  {$ENDIF}

  {$IFDEF FL_D2009}
     {$DEFINE FL_D2007}
  {$ENDIF}

  {$IFDEF FL_D2007}
     {$DEFINE FL_D2006}
  {$ENDIF}

  {$IFDEF FL_D2006}
     {$DEFINE FL_2005}
  {$ENDIF}

  {$IFDEF FL_2005}
     {$DEFINE FL_D8}
  {$ENDIF}

  {$IFDEF FL_D8}
     {$DEFINE FL_D7}
  {$ENDIF}

  {$IFDEF FL_D7}
    {$DEFINE FL_D6}
  {$ENDIF}

  {$IFDEF FL_D6}
    {$DEFINE FL_D5}
    {$DEFINE FL_MIDASLIB}
  {$ENDIF}

  {$IFDEF FL_D5}
    {$DEFINE FL_D4}
  {$ENDIF}

  {$IFDEF FL_D4}
    {$DEFINE FL_D3}
  {$ENDIF}

{$ENDIF}
