program Project_Juego_Solitario;

uses
  Forms,
  Form_Menu_Solitario in 'Form_Menu_Solitario.pas' {FMenuSolitario},
  Form_Juego_Solitario in 'Form_Juego_Solitario.pas' {FJuegoSolitario};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMenuSolitario, FMenuSolitario);
  Application.CreateForm(TFJuegoSolitario, FJuegoSolitario);
  Application.Run;
end.
