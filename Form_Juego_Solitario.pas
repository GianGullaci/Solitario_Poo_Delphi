unit Form_Juego_Solitario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, LO_Solitario;

type
  TFJuegoSolitario = class(TForm)
    LMazo: TLabel;
    EMazo: TEdit;
    SGMonton1: TStringGrid;
    SGMonton2: TStringGrid;
    SGMonton3: TStringGrid;
    SGMonton4: TStringGrid;
    EOro: TEdit;
    EBasto: TEdit;
    ECopa: TEdit;
    EEspada: TEdit;
    LOro: TLabel;
    LBasto: TLabel;
    LCopa: TLabel;
    LEspada: TLabel;
    LRetirados: TLabel;
    ERetirados: TEdit;
    BMazo: TButton;
    BOro: TButton;
    BBasto: TButton;
    BCopa: TButton;
    BEspada: TButton;
    BRetirados: TButton;
    BMonton1: TButton;
    BMonton2: TButton;
    BMonton3: TButton;
    BMonton4: TButton;
    BSalir: TButton;
    SGMazo: TStringGrid;
    BMezclar: TButton;
    BCorte: TButton;
    procedure BSalirClick(Sender: TObject);
    procedure BMezclarClick(Sender: TObject);
    procedure BCorteClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BMazoClick(Sender: TObject);
    procedure BMonton1Click(Sender: TObject);
    procedure BMonton2Click(Sender: TObject);
    procedure BMonton3Click(Sender: TObject);
    procedure BMonton4Click(Sender: TObject);
    procedure BRetiradosClick(Sender: TObject);
    procedure BOroClick(Sender: TObject);
    procedure BBastoClick(Sender: TObject);
    procedure BCopaClick(Sender: TObject);
    procedure BEspadaClick(Sender: TObject);
  private
    { Private declarations }
    RI_Mazo, RI_Monton, RI_Monton2: Tipo_Reg_Indice;  
    uc_Mazo, uc_Monton, uc_Monton2: Tipo_Una_Carta;
    da_carta, da_monton: boolean;
    monton1, monton2, monton3, monton4: boolean;
  public
    { Public declarations }
    oJuego_Solitario: oTipo_Solitario;     
    nueva: boolean;
  end;

var
  FJuegoSolitario: TFJuegoSolitario;

implementation

uses Form_Menu_Solitario;

{$R *.dfm}
         

procedure TFJuegoSolitario.FormActivate(Sender: TObject);
begin
  if nueva then
    begin
      EMazo.Text:= oJuego_Solitario.Carta_Mazo;
      EOro.Text:= '';
      EBasto.Text:= '';
      ECopa.Text:= '';
      EEspada.Text:= '';
      ERetirados.Text:= '';
      SGMonton1.RowCount:= 1;
      SGMonton1.Rows[0].Clear;
      SGMonton2.RowCount:= 1;
      SGMonton2.Rows[0].Clear;
      SGMonton3.RowCount:= 1;
      SGMonton3.Rows[0].Clear;
      SGMonton4.RowCount:= 1;
      SGMonton4.Rows[0].Clear;
      if oJuego_Solitario.Mazo.Mazo_Ordenado then
        begin
          BMezclar.Enabled:= True;
          BCorte.Enabled:= True;
        end;
    end
  else
    begin
      EOro.Text:= '';
      EBasto.Text:= '';
      ECopa.Text:= '';
      EEspada.Text:= '';
      ERetirados.Text:= '';
      SGMonton1.RowCount:= 1;
      SGMonton1.Rows[0].Clear;
      SGMonton2.RowCount:= 1;
      SGMonton2.Rows[0].Clear;
      SGMonton3.RowCount:= 1;
      SGMonton3.Rows[0].Clear;
      SGMonton4.RowCount:= 1;
      SGMonton4.Rows[0].Clear;
      if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
        EMazo.Text:= oJuego_Solitario.Carta_Mazo;
      oJuego_Solitario.Seguir_Jugando(SGMonton1,SGMonton2,SGMonton3,SGMonton4,ERetirados,EOro,EBasto,ECopa,EEspada);
    end;
end;

procedure TFJuegoSolitario.BSalirClick(Sender: TObject);
begin
  FMenuSolitario.Show;
  FJuegoSolitario.Visible:= false;
end;

procedure TFJuegoSolitario.BMezclarClick(Sender: TObject);
begin
  oJuego_Solitario.Mazo.Mezclar(oJuego_Solitario.Limite_Cartas);
  oJuego_Solitario.Mostrar_Mazo(SGMazo);
  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
end;

procedure TFJuegoSolitario.BCorteClick(Sender: TObject);
begin
  oJuego_Solitario.Mazo.Cortar(oJuego_Solitario.Limite_Cartas);
  oJuego_Solitario.Mostrar_Mazo(SGMazo);
  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
end;

procedure TFJuegoSolitario.BMazoClick(Sender: TObject);
begin
 if nueva then
  begin
  if oJuego_Solitario.Mazo.Mazo_Mezclado and oJuego_Solitario.Mazo.Mazo_Cortado then
    begin
      if not da_carta then
       begin
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          begin
            RI_Mazo:= oJuego_Solitario.Mazo.DarCarta;
            da_carta:= True;
            da_monton:= False;
            BMazo.Caption:= 'ESC';
          end
        else
          showmessage('No hay más cartas en el mazo');
        BMezclar.Enabled:= False;
        BCorte.Enabled:= False;
       end
      else
        begin
          da_carta:= false;
          BMazo.Caption:= 'OK';
        end;
    end
  else
    showmessage('Debe mezclar y cortar el mazo');
  end
 else
  begin
    if not da_carta then
      begin
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          begin
            RI_Mazo:= oJuego_Solitario.Mazo.DarCarta;
            da_carta:= True;
            da_monton:= False;
            BMazo.Caption:= 'ESC';
          end
        else
          showmessage('No hay más cartas en el mazo');
        BMezclar.Enabled:= False;
        BCorte.Enabled:= False;
       end
      else
        begin
          da_carta:= false;
          BMazo.Caption:= 'OK';
        end;
  end;
end;

procedure TFJuegoSolitario.BMonton1Click(Sender: TObject);
begin
  if da_carta then
   begin
    if oJuego_Solitario.Monton1.Pila_Vacia then
      begin
        oJuego_Solitario.Monton1.Volcar_Carta(RI_Mazo,SGMonton1);
        da_carta:= false;        
        BMazo.Caption:= 'OK';
        oJuego_Solitario.Mazo.Carta_Ganada;
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          EMazo.Text:= oJuego_Solitario.Carta_Mazo
        else
          if not oJuego_Solitario.Descarte.Pila_Vacia then
            begin
              oJuego_Solitario.Rellenar_Mazo;
              EMazo.Text:= oJuego_Solitario.Carta_Mazo;
              ERetirados.Text:= '';
            end
          else
            begin
              EMazo.Text:= '';
              ERetirados.Text:= '';
            end;
      end
    else
      begin
        RI_Monton:= oJuego_Solitario.Monton1.Tope;
        oJuego_Solitario.Cartas.Capturar(uc_Mazo,RI_Mazo.Pos);
        oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
        if (uc_Mazo.Palo <> uc_Monton.Palo) and (uc_Mazo.Num = pred(uc_Monton.Num)) then
          begin
            oJuego_Solitario.Monton1.Volcar_Carta(RI_Mazo,SGMonton1);
            da_carta:= false;   
            BMazo.Caption:= 'OK';
            oJuego_Solitario.Mazo.Carta_Ganada;
            if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
              EMazo.Text:= oJuego_Solitario.Carta_Mazo
            else
              if not oJuego_Solitario.Descarte.Pila_Vacia then
                begin
                  oJuego_Solitario.Rellenar_Mazo;
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                  ERetirados.Text:= '';
                end
              else
                begin
                  EMazo.Text:= '';
                  ERetirados.Text:= '';
                end;
          end
        else
          showmessage('No es posible realizar el movimiento');
      end;
   end
  else
    if da_monton then
      begin
        if not monton1 then
          begin
           if not oJuego_Solitario.Monton1.Pila_Vacia then
           begin
            RI_Monton2:= oJuego_Solitario.Monton1.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_Monton2,RI_Monton2.Pos);
            oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
            if (uc_Monton.Palo <> uc_Monton2.Palo) and (uc_Monton.Num = pred(uc_Monton2.Num)) then
              begin
                oJuego_Solitario.Monton1.Volcar_Carta(RI_Monton,SGMonton1);
                da_monton:= false;
                if monton2 then
                  begin
                    oJuego_Solitario.Monton2.Desapilar;
                    monton2:= false;
                    BMonton2.Caption:= 'OK';
                    SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                    SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                  end
                else
                  if monton3 then
                    begin
                      oJuego_Solitario.Monton3.Desapilar;
                      monton3:= false;    
                      BMonton3.Caption:= 'OK';
                      SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                      SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                    end
                  else
                    begin
                      oJuego_Solitario.Monton4.Desapilar;
                      monton4:= false;    
                      BMonton4.Caption:= 'OK';
                      SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                      SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                    end;
              end
            else
              showmessage('No es posible realizar el movimiento');
           end
           else
           begin
            oJuego_Solitario.Monton1.Volcar_Carta(RI_Monton,SGMonton1);
            da_monton:= false;
            if monton2 then
              begin
                oJuego_Solitario.Monton2.Desapilar;
                monton2:= false;  
                BMonton2.Caption:= 'OK';
                SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
              end
            else
              if monton3 then
                begin
                  oJuego_Solitario.Monton3.Desapilar;
                  monton3:= false;    
                  BMonton3.Caption:= 'OK';
                  SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                  SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                end
              else
                begin
                  oJuego_Solitario.Monton4.Desapilar;
                  monton4:= false;  
                  BMonton4.Caption:= 'OK';
                  SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                  SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                end;
           end;
          end
        else
          begin
            da_monton:= false;
            monton1:= false;     
            BMonton1.Caption:= 'OK';
          end;
      end
    else
      begin
        if not oJuego_Solitario.Monton1.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Monton1.Tope;
            da_monton:= true;
            monton1:= true;
            BMonton1.Caption:= 'ESC';
          end
        else
          showmessage('No hay cartas en el montón');
      end;
end;

procedure TFJuegoSolitario.BMonton2Click(Sender: TObject);
begin
  if da_carta then
   begin
    if oJuego_Solitario.Monton2.Pila_Vacia then
      begin
        oJuego_Solitario.Monton2.Volcar_Carta(RI_Mazo,SGMonton2);
        da_carta:= false;   
        BMazo.Caption:= 'OK';
        oJuego_Solitario.Mazo.Carta_Ganada;
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          EMazo.Text:= oJuego_Solitario.Carta_Mazo
        else
          if not oJuego_Solitario.Descarte.Pila_Vacia then
            begin
              oJuego_Solitario.Rellenar_Mazo;
              EMazo.Text:= oJuego_Solitario.Carta_Mazo;
              ERetirados.Text:= '';
            end
          else
            begin
              EMazo.Text:= '';
              ERetirados.Text:= '';
            end;
      end
    else
      begin
        RI_Monton:= oJuego_Solitario.Monton2.Tope;
        oJuego_Solitario.Cartas.Capturar(uc_Mazo,RI_Mazo.Pos);
        oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
        if (uc_Mazo.Palo <> uc_Monton.Palo) and (uc_Mazo.Num = pred(uc_Monton.Num)) then
          begin
            oJuego_Solitario.Monton2.Volcar_Carta(RI_Mazo,SGMonton2);
            da_carta:= false;     
            BMazo.Caption:= 'OK';
            oJuego_Solitario.Mazo.Carta_Ganada;
            if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
              EMazo.Text:= oJuego_Solitario.Carta_Mazo
            else
              if not oJuego_Solitario.Descarte.Pila_Vacia then
                begin
                  oJuego_Solitario.Rellenar_Mazo;
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                  ERetirados.Text:= '';
                end
              else
                begin
                  EMazo.Text:= '';
                  ERetirados.Text:= '';
                end;
          end
        else
          showmessage('No es posible realizar el movimiento');
      end;
   end
  else
    if da_monton then
      begin
        if not monton2 then
          begin
           if not oJuego_Solitario.Monton2.Pila_Vacia then
           begin
            RI_Monton2:= oJuego_Solitario.Monton1.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_Monton2,RI_Monton2.Pos);
            oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
            if (uc_Monton.Palo <> uc_Monton2.Palo) and (uc_Monton.Num = pred(uc_Monton2.Num)) then
              begin
                oJuego_Solitario.Monton2.Volcar_Carta(RI_Monton,SGMonton2);
                da_monton:= false;
                if monton1 then
                  begin
                    oJuego_Solitario.Monton1.Desapilar;
                    monton1:= false;  
                    BMonton1.Caption:= 'OK';
                    SGMonton1.RowCount:= SGMonton1.RowCount - 1; 
                    SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                  end
                else
                  if monton3 then
                    begin
                      oJuego_Solitario.Monton3.Desapilar;
                      monton3:= false;
                      BMonton3.Caption:= 'OK';
                      SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                      SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                    end
                  else
                    begin
                      oJuego_Solitario.Monton4.Desapilar;
                      monton4:= false;     
                      BMonton4.Caption:= 'OK';
                      SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                      SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                    end;
              end
            else
              showmessage('No es posible realizar el movimiento');
           end
           else
           begin
            oJuego_Solitario.Monton2.Volcar_Carta(RI_Monton,SGMonton2);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;   
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton3 then
                begin
                  oJuego_Solitario.Monton3.Desapilar;
                  monton3:= false;  
                  BMonton3.Caption:= 'OK';
                  SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                  SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                end
              else
                begin
                  oJuego_Solitario.Monton4.Desapilar;
                  monton4:= false;  
                  BMonton4.Caption:= 'OK';
                  SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                  SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                end;
           end;
          end
        else
          begin
            da_monton:= false;
            monton2:= false;  
            BMonton2.Caption:= 'OK';
          end;
      end
    else
      begin
        if not oJuego_Solitario.Monton2.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Monton2.Tope;
            da_monton:= true;
            monton2:= true;    
            BMonton2.Caption:= 'ESC';
          end
        else
          showmessage('No hay cartas en el montón');
      end;
end;

procedure TFJuegoSolitario.BMonton3Click(Sender: TObject);
begin
  if da_carta then
   begin
    if oJuego_Solitario.Monton3.Pila_Vacia then
      begin
        oJuego_Solitario.Monton3.Volcar_Carta(RI_Mazo,SGMonton3);
        da_carta:= false;    
        BMazo.Caption:= 'OK';
        oJuego_Solitario.Mazo.Carta_Ganada;
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          EMazo.Text:= oJuego_Solitario.Carta_Mazo
        else
          if not oJuego_Solitario.Descarte.Pila_Vacia then
            begin
              oJuego_Solitario.Rellenar_Mazo;
              EMazo.Text:= oJuego_Solitario.Carta_Mazo;
              ERetirados.Text:= '';
            end
          else
            begin
              EMazo.Text:= '';
              ERetirados.Text:= '';
            end;
      end
    else
      begin
        RI_Monton:= oJuego_Solitario.Monton3.Tope;
        oJuego_Solitario.Cartas.Capturar(uc_Mazo,RI_Mazo.Pos);
        oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
        if (uc_Mazo.Palo <> uc_Monton.Palo) and (uc_Mazo.Num = pred(uc_Monton.Num)) then
          begin
            oJuego_Solitario.Monton3.Volcar_Carta(RI_Mazo,SGMonton3);
            da_carta:= false;
            BMazo.Caption:= 'OK';
            oJuego_Solitario.Mazo.Carta_Ganada;
            if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
              EMazo.Text:= oJuego_Solitario.Carta_Mazo
            else
              if not oJuego_Solitario.Descarte.Pila_Vacia then
                begin
                  oJuego_Solitario.Rellenar_Mazo;
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                  ERetirados.Text:= '';
                end
              else
                begin
                  EMazo.Text:= '';
                  ERetirados.Text:= '';
                end;
          end
        else
          showmessage('No es posible realizar el movimiento');
      end;
   end
  else
    if da_monton then
      begin
        if not monton3 then
          begin        
           if not oJuego_Solitario.Monton3.Pila_Vacia then
           begin
            RI_Monton2:= oJuego_Solitario.Monton3.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_Monton2,RI_Monton2.Pos);
            oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
            if (uc_Monton.Palo <> uc_Monton2.Palo) and (uc_Monton.Num = pred(uc_Monton2.Num)) then
              begin
                oJuego_Solitario.Monton3.Volcar_Carta(RI_Monton,SGMonton3);
                da_monton:= false;
                if monton2 then
                  begin
                    oJuego_Solitario.Monton2.Desapilar;
                    monton2:= false;  
                    BMonton2.Caption:= 'OK';
                    SGMonton2.RowCount:= SGMonton2.RowCount - 1;  
                    SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                  end
                else
                  if monton1 then
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false;   
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end
                  else
                    begin
                      oJuego_Solitario.Monton4.Desapilar;
                      monton4:= false;    
                      BMonton4.Caption:= 'OK';
                      SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                      SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                    end;
              end
            else
              showmessage('No es posible realizar el movimiento');
           end
           else
           begin
            oJuego_Solitario.Monton3.Volcar_Carta(RI_Monton,SGMonton3);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton2 then
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false;  
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end
              else
                begin
                  oJuego_Solitario.Monton4.Desapilar;
                  monton4:= false; 
                  BMonton4.Caption:= 'OK';
                  SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                  SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                end;
           end;
          end
        else
          begin
            da_monton:= false;
            monton3:= false;  
            BMonton3.Caption:= 'OK';
          end;
      end
    else
      begin
        if not oJuego_Solitario.Monton3.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Monton3.Tope;
            da_monton:= true;
            monton3:= true;
            BMonton3.Caption:= 'ESC';
          end
        else
          showmessage('No hay cartas en el montón');
      end;
end;

procedure TFJuegoSolitario.BMonton4Click(Sender: TObject);
begin
  if da_carta then
   begin
    if oJuego_Solitario.Monton4.Pila_Vacia then
      begin
        oJuego_Solitario.Monton4.Volcar_Carta(RI_Mazo,SGMonton4);
        da_carta:= false;    
        BMazo.Caption:= 'OK';
        oJuego_Solitario.Mazo.Carta_Ganada;
        if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
          EMazo.Text:= oJuego_Solitario.Carta_Mazo
        else
          if not oJuego_Solitario.Descarte.Pila_Vacia then
            begin
              oJuego_Solitario.Rellenar_Mazo;
              EMazo.Text:= oJuego_Solitario.Carta_Mazo;
              ERetirados.Text:= '';
            end
          else
            begin
              EMazo.Text:= '';
              ERetirados.Text:= '';
            end;
      end
    else
      begin
        RI_Monton:= oJuego_Solitario.Monton4.Tope;
        oJuego_Solitario.Cartas.Capturar(uc_Mazo,RI_Mazo.Pos);
        oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
        if (uc_Mazo.Palo <> uc_Monton.Palo) and (uc_Mazo.Num = pred(uc_Monton.Num)) then
          begin
            oJuego_Solitario.Monton4.Volcar_Carta(RI_Mazo,SGMonton4);
            da_carta:= false;  
            BMazo.Caption:= 'OK';
            oJuego_Solitario.Mazo.Carta_Ganada;
            if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
              EMazo.Text:= oJuego_Solitario.Carta_Mazo
            else
              if not oJuego_Solitario.Descarte.Pila_Vacia then
                begin
                  oJuego_Solitario.Rellenar_Mazo;
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                  ERetirados.Text:= '';
                end
              else
                begin
                  EMazo.Text:= '';
                  ERetirados.Text:= '';
                end;
          end
        else
          showmessage('No es posible realizar el movimiento');
      end;
   end
  else
    if da_monton then
      begin
        if not monton4 then
          begin         
           if not oJuego_Solitario.Monton4.Pila_Vacia then
           begin
            RI_Monton2:= oJuego_Solitario.Monton4.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_Monton2,RI_Monton2.Pos);
            oJuego_Solitario.Cartas.Capturar(uc_Monton,RI_Monton.Pos);
            if (uc_Monton.Palo <> uc_Monton2.Palo) and (uc_Monton.Num = pred(uc_Monton2.Num)) then
              begin
                oJuego_Solitario.Monton4.Volcar_Carta(RI_Monton,SGMonton4);
                da_monton:= false;
                if monton2 then
                  begin
                    oJuego_Solitario.Monton2.Desapilar;
                    monton2:= false;     
                    BMonton2.Caption:= 'OK';
                    SGMonton2.RowCount:= SGMonton2.RowCount - 1; 
                    SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                  end
                else
                  if monton3 then
                    begin
                      oJuego_Solitario.Monton3.Desapilar;
                      monton3:= false;  
                      BMonton3.Caption:= 'OK';
                      SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                      SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                    end
                  else
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false; 
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end;
              end
            else
              showmessage('No es posible realizar el movimiento');
           end
           else
           begin
            oJuego_Solitario.Monton4.Volcar_Carta(RI_Monton,SGMonton4);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;     
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton3 then
                begin
                  oJuego_Solitario.Monton3.Desapilar;
                  monton3:= false;    
                  BMonton3.Caption:= 'OK';
                  SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                  SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                end
              else
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false;   
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end;
           end;
          end
        else
          begin
            da_monton:= false;
            monton4:= false;  
            BMonton4.Caption:= 'OK';
          end;
      end
    else
      begin
        if not oJuego_Solitario.Monton4.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Monton4.Tope;
            da_monton:= true;
            monton4:= true;    
            BMonton4.Caption:= 'ESC';
          end
        else
          showmessage('No hay cartas en el montón');
      end;
end;

procedure TFJuegoSolitario.BRetiradosClick(Sender: TObject);
var
  Reg_Carta: Tipo_Una_Carta;
begin
  if da_carta then
    begin
      oJuego_Solitario.Descarte.Apilar(RI_Mazo);
      oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
      ERetirados.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);;
      da_carta:= false; 
      BMazo.Caption:= 'OK';
      oJuego_Solitario.Mazo.Carta_Ganada;
      if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
        EMazo.Text:= oJuego_Solitario.Carta_Mazo
      else
        if not oJuego_Solitario.Descarte.Pila_Vacia then
          begin
            oJuego_Solitario.Rellenar_Mazo;
            EMazo.Text:= oJuego_Solitario.Carta_Mazo;
            ERetirados.Text:= '';
          end
        else
          begin
            EMazo.Text:= '';
            ERetirados.Text:= '';
          end;
   end
  else
    showmessage('Debe seleccionar una carta del mazo');
end;

procedure TFJuegoSolitario.BOroClick(Sender: TObject);
var
  Reg_Carta: Tipo_Una_Carta;
begin
  if da_carta then
    begin
      oJuego_Solitario.Cartas.Capturar(uc_mazo,RI_Mazo.Pos);
      if (oJuego_Solitario.Oros.Pila_Vacia) and (UpperCase(uc_mazo.Palo) = 'ORO') and (uc_mazo.Num = 1) then
        begin
          oJuego_Solitario.Oros.Apilar(RI_Mazo);
          oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
          EOro.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
          da_carta:= false;  
          BMazo.Caption:= 'OK';
          oJuego_Solitario.Mazo.Carta_Ganada;
          if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
            EMazo.Text:= oJuego_Solitario.Carta_Mazo
          else
            if not oJuego_Solitario.Descarte.Pila_Vacia then
              begin
                oJuego_Solitario.Rellenar_Mazo;
                EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                ERetirados.Text:= '';
              end
            else
              begin
                EMazo.Text:= '';
                ERetirados.Text:= '';
              end;
        end
      else
        if not oJuego_Solitario.Oros.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Oros.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
            if (UpperCase(uc_mazo.Palo) = 'ORO') and (uc_mazo.Num = succ(uc_monton.Num)) then
              begin
                oJuego_Solitario.Oros.Apilar(RI_Mazo);
                oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
                EOro.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                da_carta:= false;  
                BMazo.Caption:= 'OK';
                oJuego_Solitario.Mazo.Carta_Ganada;
                if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo
                else
                  if not oJuego_Solitario.Descarte.Pila_Vacia then
                    begin
                      oJuego_Solitario.Rellenar_Mazo;
                      EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                      ERetirados.Text:= '';
                    end
                  else
                    begin
                      EMazo.Text:= '';
                      ERetirados.Text:= '';
                    end;
                if oJuego_Solitario.Juego_Finalizado then
                  showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
              end
            else
              showmessage('No es posible realizar el movimiento');
          end
        else
          showmessage('No es posible realizar el movimiento');
    end
  else
    if da_monton then
      begin
        oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
        if (oJuego_Solitario.Oros.Pila_Vacia) and (UpperCase(uc_monton.Palo) = 'ORO') and (uc_monton.Num = 1) then
          begin
            oJuego_Solitario.Oros.Apilar(RI_Monton);
            oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
            EOro.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton2 then
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false;
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end
              else
                if monton3 then
                  begin
                    oJuego_Solitario.Monton3.Desapilar;
                    monton3:= false;
                    BMonton3.Caption:= 'OK';
                    SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                    SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                  end
                else
                  begin
                    oJuego_Solitario.Monton4.Desapilar;
                    monton4:= false;   
                    BMonton4.Caption:= 'OK';
                    SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                    SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                  end;
          end
        else
          if not oJuego_Solitario.Oros.Pila_Vacia then
            begin
              RI_Monton2:= oJuego_Solitario.Oros.Tope;
              oJuego_Solitario.Cartas.Capturar(uc_monton2,RI_Monton2.Pos);
              if (UpperCase(uc_monton.Palo) = 'ORO') and (uc_monton.Num = succ(uc_monton2.Num)) then
                begin
                  oJuego_Solitario.Oros.Apilar(RI_Monton);
                  oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
                  EOro.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                  da_monton:= false;
                  if monton1 then
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false;  
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end
                  else
                    if monton2 then
                      begin
                        oJuego_Solitario.Monton2.Desapilar;
                        monton2:= false; 
                        BMonton2.Caption:= 'OK';
                        SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                        SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                      end
                    else
                      if monton3 then
                        begin
                          oJuego_Solitario.Monton3.Desapilar;
                          monton3:= false;
                          BMonton3.Caption:= 'OK';
                          SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                          SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                        end
                      else
                        begin
                          oJuego_Solitario.Monton4.Desapilar;
                          monton4:= false;  
                          BMonton4.Caption:= 'OK';
                          SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                          SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                        end;
                  if oJuego_Solitario.Juego_Finalizado then
                    showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
                end
              else
                showmessage('No es posible realizar el movimiento');
            end
          else
            showmessage('No es posible realizar el movimiento');
      end
    else
      showmessage('Debe seleccionar una carta');
end;

procedure TFJuegoSolitario.BBastoClick(Sender: TObject);
var
  Reg_Carta: Tipo_Una_Carta;
begin
  if da_carta then
    begin
      oJuego_Solitario.Cartas.Capturar(uc_mazo,RI_Mazo.Pos);
      if (oJuego_Solitario.Bastos.Pila_Vacia) and (UpperCase(uc_mazo.Palo) = 'BASTO') and (uc_mazo.Num = 1) then
        begin
          oJuego_Solitario.Bastos.Apilar(RI_Mazo);
          oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
          EBasto.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
          da_carta:= false;     
          BMazo.Caption:= 'OK';
          oJuego_Solitario.Mazo.Carta_Ganada;
          if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
            EMazo.Text:= oJuego_Solitario.Carta_Mazo
          else
            if not oJuego_Solitario.Descarte.Pila_Vacia then
              begin
                oJuego_Solitario.Rellenar_Mazo;
                EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                ERetirados.Text:= '';
              end
            else
              begin
                EMazo.Text:= '';
                ERetirados.Text:= '';
              end;
        end
      else
        if not oJuego_Solitario.Bastos.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Bastos.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
            if (UpperCase(uc_mazo.Palo) = 'BASTO') and (uc_mazo.Num = succ(uc_monton.Num)) then
              begin
                oJuego_Solitario.Bastos.Apilar(RI_Mazo);
                oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
                EBasto.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                da_carta:= false;  
                BMazo.Caption:= 'OK';
                oJuego_Solitario.Mazo.Carta_Ganada;
                if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo
                else
                  if not oJuego_Solitario.Descarte.Pila_Vacia then
                    begin
                      oJuego_Solitario.Rellenar_Mazo;
                      EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                      ERetirados.Text:= '';
                    end
                  else
                    begin
                      EMazo.Text:= '';
                      ERetirados.Text:= '';
                    end; 
                if oJuego_Solitario.Juego_Finalizado then
                  showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
              end
            else
              showmessage('No es posible realizar el movimiento');
          end
        else
          showmessage('No es posible realizar el movimiento');
   end
  else
    if da_monton then
      begin
        oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
        if (oJuego_Solitario.Bastos.Pila_Vacia) and (UpperCase(uc_monton.Palo) = 'BASTO') and (uc_monton.Num = 1) then
          begin
            oJuego_Solitario.Bastos.Apilar(RI_Monton);
            oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
            EBasto.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton2 then
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false;  
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end
              else
                if monton3 then
                  begin
                    oJuego_Solitario.Monton3.Desapilar;
                    monton3:= false;   
                    BMonton3.Caption:= 'OK';
                    SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                    SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                  end
                else
                  begin
                    oJuego_Solitario.Monton4.Desapilar;
                    monton4:= false; 
                    BMonton4.Caption:= 'OK';
                    SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                    SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                  end;
          end
        else
          if not oJuego_Solitario.Bastos.Pila_Vacia then
            begin
              RI_Monton2:= oJuego_Solitario.Bastos.Tope;
              oJuego_Solitario.Cartas.Capturar(uc_monton2,RI_Monton2.Pos);
              if (UpperCase(uc_monton.Palo) = 'BASTO') and (uc_monton.Num = succ(uc_monton2.Num)) then
                begin
                  oJuego_Solitario.Bastos.Apilar(RI_Monton);
                  oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
                  EBasto.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                  da_monton:= false;
                  if monton1 then
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false;
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end
                  else
                    if monton2 then
                      begin
                        oJuego_Solitario.Monton2.Desapilar;
                        monton2:= false; 
                        BMonton2.Caption:= 'OK';
                        SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                        SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                      end
                    else
                      if monton3 then
                        begin
                          oJuego_Solitario.Monton3.Desapilar;
                          monton3:= false;  
                          BMonton3.Caption:= 'OK';
                          SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                          SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                        end
                      else
                        begin
                          oJuego_Solitario.Monton4.Desapilar;
                          monton4:= false;  
                          BMonton4.Caption:= 'OK';
                          SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                          SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                        end;   
                  if oJuego_Solitario.Juego_Finalizado then
                    showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
                end
              else
                showmessage('No es posible realizar el movimiento');
            end
          else
            showmessage('No es posible realizar el movimiento');
      end
    else
      showmessage('Debe seleccionar una carta');
end;

procedure TFJuegoSolitario.BCopaClick(Sender: TObject);
var
  Reg_Carta: Tipo_Una_Carta;
begin
  if da_carta then
    begin
      oJuego_Solitario.Cartas.Capturar(uc_mazo,RI_Mazo.Pos);
      if (oJuego_Solitario.Copas.Pila_Vacia) and (UpperCase(uc_mazo.Palo) = 'COPA') and (uc_mazo.Num = 1) then
        begin
          oJuego_Solitario.Copas.Apilar(RI_Mazo);
          oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
          ECopa.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
          da_carta:= false; 
          BMazo.Caption:= 'OK';
          oJuego_Solitario.Mazo.Carta_Ganada;
          if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
            EMazo.Text:= oJuego_Solitario.Carta_Mazo
          else
            if not oJuego_Solitario.Descarte.Pila_Vacia then
              begin
                oJuego_Solitario.Rellenar_Mazo;
                EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                ERetirados.Text:= '';
              end
            else
              begin
                EMazo.Text:= '';
                ERetirados.Text:= '';
              end;
        end
      else
        if not oJuego_Solitario.Copas.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Copas.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
            if (UpperCase(uc_mazo.Palo) = 'COPA') and (uc_mazo.Num = succ(uc_monton.Num)) then
              begin
                oJuego_Solitario.Copas.Apilar(RI_Mazo);
                oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
                ECopa.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                da_carta:= false;  
                BMazo.Caption:= 'OK';
                oJuego_Solitario.Mazo.Carta_Ganada;
                if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo
                else
                  if not oJuego_Solitario.Descarte.Pila_Vacia then
                    begin
                      oJuego_Solitario.Rellenar_Mazo;
                      EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                      ERetirados.Text:= '';
                    end
                  else
                    begin
                      EMazo.Text:= '';
                      ERetirados.Text:= '';
                    end;  
                if oJuego_Solitario.Juego_Finalizado then
                  showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
              end
            else
              showmessage('No es posible realizar el movimiento');
          end
        else
          showmessage('No es posible realizar el movimiento');
   end
  else
    if da_monton then
      begin
        oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
        if (oJuego_Solitario.Copas.Pila_Vacia) and (UpperCase(uc_monton.Palo) = 'COPA') and (uc_monton.Num = 1) then
          begin
            oJuego_Solitario.Copas.Apilar(RI_Monton);
            oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
            ECopa.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false;    
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton2 then
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false;  
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end
              else
                if monton3 then
                  begin
                    oJuego_Solitario.Monton3.Desapilar;
                    monton3:= false; 
                    BMonton3.Caption:= 'OK';
                    SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                    SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                  end
                else
                  begin
                    oJuego_Solitario.Monton4.Desapilar;
                    monton4:= false;
                    BMonton4.Caption:= 'OK';
                    SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                    SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                  end;
          end
        else
          if not oJuego_Solitario.Copas.Pila_Vacia then
            begin
              RI_Monton2:= oJuego_Solitario.Copas.Tope;
              oJuego_Solitario.Cartas.Capturar(uc_monton2,RI_Monton2.Pos);
              if (UpperCase(uc_monton.Palo) = 'COPA') and (uc_monton.Num = succ(uc_monton2.Num)) then
                begin
                  oJuego_Solitario.Copas.Apilar(RI_Monton);
                  oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
                  ECopa.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                  da_monton:= false;
                  if monton1 then
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false; 
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end
                  else
                    if monton2 then
                      begin
                        oJuego_Solitario.Monton2.Desapilar;
                        monton2:= false;  
                        BMonton2.Caption:= 'OK';
                        SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                        SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                      end
                    else
                      if monton3 then
                        begin
                          oJuego_Solitario.Monton3.Desapilar;
                          monton3:= false;
                          BMonton3.Caption:= 'OK';
                          SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                          SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                        end
                      else
                        begin
                          oJuego_Solitario.Monton4.Desapilar;
                          monton4:= false; 
                          BMonton4.Caption:= 'OK';
                          SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                          SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                        end;    
                  if oJuego_Solitario.Juego_Finalizado then
                    showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
                end
              else
                showmessage('No es posible realizar el movimiento');
            end
          else
            showmessage('No es posible realizar el movimiento');
      end
    else
      showmessage('Debe seleccionar una carta');
end;

procedure TFJuegoSolitario.BEspadaClick(Sender: TObject);
var
  Reg_Carta: Tipo_Una_Carta;
begin
  if da_carta then
    begin
      oJuego_Solitario.Cartas.Capturar(uc_mazo,RI_Mazo.Pos);
      if (oJuego_Solitario.Espadas.Pila_Vacia) and (UpperCase(uc_mazo.Palo) = 'ESPADA') and (uc_mazo.Num = 1) then
        begin
          oJuego_Solitario.Espadas.Apilar(RI_Mazo);
          oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
          EEspada.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
          da_carta:= false;   
          BMazo.Caption:= 'OK';
          oJuego_Solitario.Mazo.Carta_Ganada;
          if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
            EMazo.Text:= oJuego_Solitario.Carta_Mazo
          else
            if not oJuego_Solitario.Descarte.Pila_Vacia then
              begin
                oJuego_Solitario.Rellenar_Mazo;
                EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                ERetirados.Text:= '';
              end
            else
              begin
                EMazo.Text:= '';
                ERetirados.Text:= '';
              end;
        end
      else
        if not oJuego_Solitario.Espadas.Pila_Vacia then
          begin
            RI_Monton:= oJuego_Solitario.Espadas.Tope;
            oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
            if (UpperCase(uc_mazo.Palo) = 'ESPADA') and (uc_mazo.Num = succ(uc_monton.Num)) then
              begin
                oJuego_Solitario.Espadas.Apilar(RI_Mazo);
                oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Mazo.Pos);
                EEspada.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                da_carta:= false;   
                BMazo.Caption:= 'OK';
                oJuego_Solitario.Mazo.Carta_Ganada;
                if oJuego_Solitario.Mazo.Ultimo <> oJuego_Solitario.Mazo.Pos_Nula then
                  EMazo.Text:= oJuego_Solitario.Carta_Mazo
                else
                  if not oJuego_Solitario.Descarte.Pila_Vacia then
                    begin
                      oJuego_Solitario.Rellenar_Mazo;
                      EMazo.Text:= oJuego_Solitario.Carta_Mazo;
                      ERetirados.Text:= '';
                    end
                  else
                    begin
                      EMazo.Text:= '';
                      ERetirados.Text:= '';
                    end;    
                if oJuego_Solitario.Juego_Finalizado then
                  showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
              end
            else
              showmessage('No es posible realizar el movimiento');
          end
        else
          showmessage('No es posible realizar el movimiento');
   end
  else
    if da_monton then
      begin
        oJuego_Solitario.Cartas.Capturar(uc_monton,RI_Monton.Pos);
        if (oJuego_Solitario.Espadas.Pila_Vacia) and (UpperCase(uc_monton.Palo) = 'ESPADA') and (uc_monton.Num = 1) then
          begin
            oJuego_Solitario.Espadas.Apilar(RI_Monton);
            oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
            EEspada.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
            da_monton:= false;
            if monton1 then
              begin
                oJuego_Solitario.Monton1.Desapilar;
                monton1:= false; 
                BMonton1.Caption:= 'OK';
                SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
              end
            else
              if monton2 then
                begin
                  oJuego_Solitario.Monton2.Desapilar;
                  monton2:= false; 
                  BMonton2.Caption:= 'OK';
                  SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                  SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                end
              else
                if monton3 then
                  begin
                    oJuego_Solitario.Monton3.Desapilar;
                    monton3:= false; 
                    BMonton3.Caption:= 'OK';
                    SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                    SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                  end
                else
                  begin
                    oJuego_Solitario.Monton4.Desapilar;
                    monton4:= false;
                    BMonton4.Caption:= 'OK';
                    SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                    SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                  end;
          end
        else
          if not oJuego_Solitario.Espadas.Pila_Vacia then
            begin
              RI_Monton2:= oJuego_Solitario.Espadas.Tope;
              oJuego_Solitario.Cartas.Capturar(uc_monton2,RI_Monton2.Pos);
              if (UpperCase(uc_monton.Palo) = 'ESPADA') and (uc_monton.Num = succ(uc_monton2.Num)) then
                begin
                  oJuego_Solitario.Espadas.Apilar(RI_Monton);
                  oJuego_Solitario.Cartas.Capturar(Reg_Carta,RI_Monton.Pos);
                  EEspada.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
                  da_monton:= false;
                  if monton1 then
                    begin
                      oJuego_Solitario.Monton1.Desapilar;
                      monton1:= false; 
                      BMonton1.Caption:= 'OK';
                      SGMonton1.RowCount:= SGMonton1.RowCount - 1;
                      SGMonton1.Rows[SGMonton1.RowCount-1].Clear;
                    end
                  else
                    if monton2 then
                      begin
                        oJuego_Solitario.Monton2.Desapilar;
                        monton2:= false; 
                        BMonton2.Caption:= 'OK';
                        SGMonton2.RowCount:= SGMonton2.RowCount - 1;
                        SGMonton2.Rows[SGMonton2.RowCount-1].Clear;
                      end
                    else
                      if monton3 then
                        begin
                          oJuego_Solitario.Monton3.Desapilar;
                          monton3:= false;  
                          BMonton3.Caption:= 'OK';
                          SGMonton3.RowCount:= SGMonton3.RowCount - 1;
                          SGMonton3.Rows[SGMonton3.RowCount-1].Clear;
                        end
                      else
                        begin
                          oJuego_Solitario.Monton4.Desapilar;
                          monton4:= false;
                          BMonton4.Caption:= 'OK';
                          SGMonton4.RowCount:= SGMonton4.RowCount - 1;
                          SGMonton4.Rows[SGMonton4.RowCount-1].Clear;
                        end;      
                  if oJuego_Solitario.Juego_Finalizado then
                    showmessage('ˇˇˇFELICITACIONES!!! HAS GANADO EL JUEGO');
                end
              else
                showmessage('No es posible realizar el movimiento');
            end
          else
            showmessage('No es posible realizar el movimiento');
      end
    else
      showmessage('Debe seleccionar una carta');
end;

end.
