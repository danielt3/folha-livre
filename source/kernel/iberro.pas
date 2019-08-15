unit iberro;

interface

uses Windows, Messages, SysUtils, Classes, IB, Dialogs, Forms, Controls;

type TIBCustomErro = Class(TOBject)
  private
  public
    procedure TrataErro(E: EIBInterBaseError);
    procedure TrataErroClient(E: EIBClientError);
    procedure ErrorMsg(Sender : TObject;E: exception);
end;

var
  Erro: TIBCustomErro;

implementation

//uses dmdserver;

procedure TIBCustomErro.TrataErro(E: EIBInterBaseError);
var
  x,SqlError: Integer;
  SqlMessage,cTable: string;


begin
  SqlError:= 0;
  SqlMessage := '';
  SqlError := E.SQLCode;

  case SQLError of
  -913:begin //" DEADLOCK a transação não pode continuar por que esta bloqueada por outra na rede"
        showmessage('Transação será revertida. Registro em Uso na Rede');
      end;

  -530: begin
         showmessage('Violação de Integridade Referencial. Existem outras informações dependentes destas.');
      end;
  -902: begin //" O usuario não possui senha no interbase ou vc não disponibilizou acesso a certas
             // tabelas "
         showmessage('Você não tem Acesso ao Banco de Dados. Erro Interno, contate o Administrador.');
       end;
  -625: begin //"Validação de dados ( campo em branco valores fora da faixa...)"
         showmessage('Erro de Validação de Coluna.');
       end;
  -551: begin
         showmessage('Você não tem permissão para esta Operação. Contate o Administrador.');
//         DmServer.UserChange  :=1;
        end;
  -832: showmessage('Este resgistro não pode ser excluído porque' + #10 +
                     'Existem outros que dependem dele e que não foram excluídos');
  -12203: showmessage('Base de Dados está fora do ar. Favor entrar'
                      + #10 + 'em contato com o responsável pela rede na '
                      + #10 + 'localidade selecionada ou tente mais tarde.');
  -803:Showmessage('Chave Primária já existente. Regitro não pode ser duplicado');

  -10256 : showmessage('Erro desconhecido do sgdb');

end;

  Screen.Cursor := crDefault ;

end;


procedure TIBCustomErro.ErrorMsg(Sender  : TObject ;E: exception);
//var
//  f,i:integer;
begin
  if ( e is EIBClientError ) then
       TrataErroClient(E as EIBClientError)
  else if ( e is EIBInterBaseError ) then
       TrataErro(E  as EIBInterBaseError)
  else
     begin
       if (Pos('is not a valid date', E.Message) > 0) then
         begin
           If (copy(E.Message,2,10) <> '  /  /    ') then
            Application.MessageBox('Data inválida!','Dados incorretos',mb_ok+mb_iconerror);
         end

       else application.ShowException(E);
     end
end;


procedure TIBCustomErro.TrataErroClient(E:EIBClientError);
var
  SqlError :Integer;

begin
  SqlError := E.SQLCode;

  case SQLError of
  16:begin
       showmessage('Voce não Tem  permissão para esta Operação.');
     end;
  end;
end;

end.
