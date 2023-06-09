unit LO_Solitario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Math, Grids, StdCtrls;

Const
  _Pos_Nula = -1;
  _Clave_Nula = '';
  _Id_Nulo = 0;

Type
  Tipo_Clave = string[20];
  Tipo_Posicion = longint;
  Tipo_Cadena = string[50];
  _Numero = 1..12;


  Tipo_Una_Carta = record
                      id: Tipo_Posicion;
                      Clave: Tipo_Clave;
                      Palo: string[10];
                      Num: _Numero;
                      Nombre: string[10];
                    end;

  Tipo_Reg_Indice = record
                      Clave: Tipo_Clave;
                      Pos: Tipo_Posicion;
                      Sig, Ant: Tipo_Posicion;
                    end;

  Tipo_Reg_Control = record
                      Primero, Ultimo, Borrado_Prim, Borrado_Ult: Tipo_Posicion;
                     end;

  oTipo_ADS = Class
  Protected
    F: File of Tipo_Una_Carta;
  Public
    Constructor Create (Ruta, Nombre: String); virtual;
    Procedure Abrir;
    Procedure Cerrar;
    Procedure Insertar (Reg: Tipo_Una_Carta; pos: Tipo_Posicion);
    Function Pos_Nueva: Tipo_Posicion;
    Procedure Modificar (Reg: Tipo_Una_Carta; pos: Tipo_Posicion);
    Procedure Capturar (var Reg: Tipo_Una_Carta; pos: Tipo_Posicion);
    Function Primero: Tipo_Posicion;
    Function Ultimo: Tipo_Posicion;
    Function Proximo (pos: Tipo_Posicion): Tipo_Posicion;
    Function Anterior (pos: Tipo_Posicion): Tipo_Posicion;
    Function Vacio: boolean;
    Procedure Vaciar;
    Function Pos_Nula: Tipo_Posicion;
    Function Clave_Nula: Tipo_Clave;
    Function Id_Nulo: Tipo_Posicion;
    Destructor Destroy; override;
  end;

  oTipo_Listas = Class
    Cartas: oTipo_ADS;
  Protected
    I: File of Tipo_Reg_Indice;
    C: File of Tipo_Reg_Control;
  Public
    Constructor Create (cRuta, cNombre: string; limite: shortint); virtual;
    Procedure Abrir;
    Procedure Cerrar;
    Function Buscar (clave: Tipo_Clave; var Pos: Tipo_Posicion): boolean;
    Procedure Insertar (Reg: Tipo_Reg_Indice; Pos: Tipo_Posicion);
    Function Pos_Nueva: Tipo_Posicion;
    Procedure Eliminar (Pos: Tipo_Posicion);
    Procedure Intercambio (pos, pos2: Tipo_Posicion);
    Procedure Capturar (var Reg: Tipo_Reg_Indice; Pos: Tipo_Posicion);
    Procedure Modificar (var Reg: Tipo_Reg_Indice; Pos: Tipo_Posicion);
    Function Primero: Tipo_Posicion;
    Function Proximo (pos: Tipo_Posicion): Tipo_Posicion;
    Function Anterior (pos: Tipo_Posicion): Tipo_Posicion;
    Function Ultimo: Tipo_Posicion;
    Function Vacio: boolean;
    Procedure Vaciar;
    Function Pos_Nula: Tipo_Posicion;
    Function Clave_Nula: Tipo_Clave;
    Function Id_Nulo: Tipo_Posicion;
    Destructor Destroy; override;
  end;

  oTipo_Mazo = Class (oTipo_Listas)
  Private
    ordenado: boolean;
    Mezclado: boolean;
    Cortes: boolean;
  Public
    Constructor Create (cRuta, cNombre: string; limite: shortint); override;
    procedure Mezclar (limite: ShortInt);
    procedure Cortar (limite: ShortInt);
    function DarCarta: Tipo_Reg_Indice;
    procedure Carta_Ganada;
    Function Mazo_Ordenado: boolean;  
    Function Mazo_Mezclado: boolean;
    Function Mazo_Cortado: boolean;
    Destructor Destroy; override;
  end;

  oTipo_Pila = Class 
    Cartas: oTipo_ADS;
  Protected
    I: File of Tipo_Reg_Indice;
    C: File of Tipo_Reg_Control;
  Public
    Constructor Create (cRuta, cNombre: string); virtual;
    Procedure AbrirPila;
    Procedure CerrarPila;
    Function Tope: Tipo_Reg_Indice;
    Procedure Apilar (RI: Tipo_Reg_Indice);
    Procedure Desapilar;
    Function Pila_Vacia: boolean;   
    Procedure Vaciar;
    Function Pos_Nula: Tipo_Posicion;
    Destructor Destroy; override;
  end;

  oTipo_Montones = Class (oTipo_Pila)
  Public
    Procedure Volcar_Carta (RI: Tipo_Reg_Indice; Grilla: TStringGrid);
  end;

  oTipo_Solitario = Class
    Cartas: oTipo_ADS;
    Mazo: oTipo_Mazo;
    Monton1: oTipo_Montones;   
    Monton2: oTipo_Montones;
    Monton3: oTipo_Montones;
    Monton4: oTipo_Montones;  
    Oros: oTipo_Montones;
    Espadas: oTipo_Montones;
    Bastos: oTipo_Montones;
    Copas: oTipo_Montones;
    Descarte: oTipo_Montones;
    Monton_Aux: oTipo_Montones;
  Private
    Limite: shortInt;
  Public
    Procedure Crear;
    Procedure Nueva_Partida (Limite: ShortInt);
    Function Limite_Cartas: ShortInt;
    Procedure Mostrar_Mazo (grilla: TStringGrid);
    Function Carta_Mazo: Tipo_Clave;
    Procedure Rellenar_Mazo;
    Function Juego_Finalizado: boolean;
    Procedure Seguir_Jugando (grilla1, grilla2, grilla3, grilla4: TStringGrid; ERetirados, EOro, EBasto, ECopa, EEspada: TEdit);
    Procedure Cerrar;
  end;

Implementation

{-----------------------M�todos ADS-----------------------}

Constructor oTipo_ADS.Create;
var
  Ruta_Modelo:String;
begin
  Inherited Create;
  Ruta_Modelo:= Ruta + '/' + Nombre +'.DAT';
  Assign (self.F, Ruta_Modelo);
  if FileExists (Ruta_Modelo) = False then
    begin
      Rewrite (self.F);
      Close (self.F);
    end;
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Abrir;
begin
  Reset (self.F);
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Cerrar;
begin
  Close (self.F);
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Pos_Nueva;
begin
  Pos_Nueva:= FileSize (Self.F);
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Insertar;
begin
  Reg.Id:= FileSize (self.F);
  Seek (self.F, FileSize (self.F));
  write (self.F, Reg);
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Modificar;
begin
  Seek (self.F, pos);
  Write (self.F, reg);
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Capturar;
begin
  Seek (self.F, pos);
  Read (self.F, Reg);
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Primero;
begin
  if FileSize (self.F) = 0 then
    Primero:= _Pos_Nula
  else
    Primero:= 0;
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Ultimo;
begin
  if FileSize (self.F) = 0 then
    Ultimo:= _Pos_Nula
  else
    Ultimo:= FileSize (self.F);
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Proximo;
begin
  if Pos < Pred (FileSize (self.F)) then
    Proximo:= Succ (Pos)
  else
    Proximo:= _Pos_Nula;
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Anterior;
begin
  if Pos > 0 then
    Anterior:= Pred (Pos)
  else
    Anterior:= _Pos_Nula;
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Vacio;
begin
  Vacio:= FileSize (Self.F) = 0;
end;

{-----------------------------------------------------------------}
Procedure oTipo_ADS.Vaciar;
begin
  Close (Self.F);
  Rewrite (Self.F);
  Reset (Self.F);
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Pos_Nula;
begin
  Pos_Nula:= _Pos_Nula;
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Clave_Nula;
begin
  Clave_Nula:= _Clave_Nula;
end;

{-----------------------------------------------------------------}
Function oTipo_ADS.Id_Nulo;
begin
  Id_Nulo:= _Id_Nulo;
end;

{-----------------------------------------------------------------}
Destructor oTipo_ADS.Destroy;
begin
  Inherited Destroy;
end;


{-----------------------M�todos Listas-----------------------}

Constructor oTipo_Listas.Create;
var
  Ruta: string;
  RC: Tipo_Reg_Control;
begin
  Inherited Create;
  Ruta:= cRuta + '\' + cNombre;
  Assign (Self.C, Ruta + '.CON');
  Assign (Self.I, Ruta + '.NTX');
  if (FileExists (Ruta + '.CON') = false)
      or (FileExists (Ruta + '.NTX') = false) then
    begin
      //Genero Indice
      Rewrite (Self.I);
      Close (Self.I);

      //Genero Control
      Rewrite (Self.C);
      RC.Primero:= _Pos_Nula;
      RC.Ultimo:= _Pos_Nula;
      RC.Borrado_Prim:= _Pos_Nula;
      RC.Borrado_Ult:= _Pos_Nula;
      Write (Self.C, RC);
      Close (Self.C);
    end;
end;

//--------------------------------------------------
Procedure oTipo_Listas.Abrir;
begin
  Reset (Self.I);
  Reset (Self.C);
end;

//--------------------------------------------------
Procedure oTipo_Listas.Cerrar;
begin
  Close (Self.I);
  Close (Self.C);
end;

//--------------------------------------------------
Function oTipo_Listas.Buscar;
var
  bEncontrado, bCorte: boolean;
  RI, RUlt, RPrim: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
  Clave_Media: Tipo_Clave;
begin
  // Leo archivo de Control
  Seek (self.C,0);
  Read (self.C,RC);

  if RC.Primero = _Pos_Nula then
    begin
      bEncontrado:= False;
      pos:= FileSize(Self.I);
    end
  else
    begin
      Seek (self.I, RC.Primero);
      Read (self.I, RPrim);
      Seek (Self.I, RC.Ultimo);
      Read (Self.I, RUlt);

      Clave_Media:= IntToStr((StrToInt(RPrim.Clave) + StrToInt(RUlt.Clave)) div 2);
      {Clave_Media:= Chr(Ord(RPrim.Clave[1] + Ord(RUlt.Clave[1])) div 2) +
                 Chr(Ord(RPrim.Clave[2] + Ord(RUlt.Clave[2])) div 2) +
                 Chr(Ord(RPrim.Clave[3] + Ord(RUlt.Clave[3])) div 2);    }

      if Clave < Clave_Media then
        begin //B�squeda ascendente
          bEncontrado:= false;
          bCorte:= False;
          Pos:= RC.Primero;

          while ((bEncontrado = False) and (bCorte = False) and (Pos <> _Pos_Nula)) do
            begin
              Seek (Self.I, Pos);
              Read (Self.I, RI);

              if RI.Clave = Clave then
                bEncontrado:= True
              else
                if RI.Clave > Clave then
                  bCorte := True
                else
                  Pos:= RI.Sig;
            end;
        end
      else
        begin //B�squeda descendente
          bEncontrado:= false;
          bCorte:= False;
          Pos:= RC.Ultimo;

          while ((bEncontrado = False) and (bCorte = False) and (Pos <> _Pos_Nula)) do
            begin
              Seek (Self.I, Pos);
              Read (Self.I, RI);

              if RI.Clave = Clave then
                bEncontrado:= True
              else
                if RI.Clave < Clave then
                  bCorte := True
                else
                  Pos:= RI.Ant;
            end;
        end;
    end;

  Buscar:= bEncontrado;
end;

//--------------------------------------------------
Procedure oTipo_Listas.Insertar;
var
  Reg_Ant, Reg_Sig: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
  Pos_Nueva: Tipo_Posicion;
begin
  // La rutina inserta en la ultima posicion, cambiando el enlace

  // Leo archivo de Control
  Seek (self.C, 0);
  Read (Self.C, RC);

  Pos_Nueva:= FileSize (Self.I);

  if (RC.Primero = _Pos_Nula) then
    begin //Inserto en el modelo vac�o
      RC.Primero:= Pos_Nueva;
      RC.Ultimo:= Pos_Nueva;
      Reg.Ant:= _Pos_Nula;
      Reg.Sig:= _Pos_Nula;
    end
  else
    if (Pos = RC.Primero) then
      begin //Inserto en la primera posici�n
        Seek (Self.I, pos);
        Read (Self.I, Reg_Sig);
        Reg_Sig.Ant:= Pos_Nueva;
        Seek (Self.I, pos);
        Write (Self.I, Reg_Sig);
        Reg.Ant:= _Pos_Nula;
        Reg.Sig:= Pos;
        RC.Primero:= Pos_Nueva;
      end
    else
      if (Pos = _Pos_Nula) then
        begin //Inserto en la �ltima posici�n
          Seek (Self.I, RC.Ultimo);
          Read (Self.I, Reg_Ant);
          Reg_Ant.Sig:= Pos_Nueva;
          Seek (Self.I, RC.Ultimo);
          Write (Self.I, Reg_Ant);
          Reg.Ant:= RC.Ultimo;
          Reg.Sig:= _Pos_Nula;
          RC.Ultimo:= Pos_Nueva;
        end
      else
        begin //Inserto en el medio
          Seek (Self.I, pos);
          Read (Self.I, Reg_Sig);
          Seek (Self.I, Reg_Sig.Ant);
          Read (Self.I, Reg_Ant);  
          Reg.Sig:= Pos;
          Reg.Ant:= Reg_Sig.Ant;
          Reg_Ant.Sig:= Pos_Nueva;
          Reg_Sig.Ant:= Pos_Nueva;
          Seek (Self.I, pos);
          Write (Self.I, Reg_Sig);
          Seek (Self.I, Reg.Ant);
          Write (Self.I, Reg_Ant);
        end;

  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);

  //Grabo el registro del �ndice
  Seek (Self.I, Pos_Nueva);
  Write (Self.I, Reg);
end;

//--------------------------------------------------
Function oTipo_Listas.Pos_Nueva;
begin
  Pos_Nueva:= FileSize (Self.I);
end;

//--------------------------------------------------
Procedure oTipo_Listas.Eliminar;
var
  Reg, Reg_Ant, Reg_Sig, Reg_X: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
  pos_Ant, pos_Sig: Tipo_Posicion;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  //Leo el registro
  Seek (Self.I, Pos);
  Read (Self.I, Reg);

  if (pos = RC.Primero) and (pos = RC.Ultimo) then
    begin //Elimino y el m�todo vac�o
      RC.Primero:= _Pos_Nula;
      RC.Ultimo:= _Pos_Nula;
    end
  else
    if (RC.Primero = pos) then
      begin //Elimino el de la primera posici�n
        pos_Sig:= Reg.Sig;
        Seek (Self.I, pos_Sig);
        Read (Self.I, Reg_Sig);
        Reg_Sig.Ant:= _Pos_Nula;
        RC.Primero:= pos_Sig;
        Seek (Self.I, pos_Sig);
        Write(Self.I, Reg_Sig);
      end
    else
      if (RC.Ultimo = pos) then
        begin //Elimino el de la �ltima posici�n
          pos_Ant:= Reg.Ant;
          Seek (Self.I, pos_Ant);
          Read (Self.I, Reg_Ant);
          Reg_Ant.Sig:= _Pos_Nula;
          RC.Ultimo:= pos_Ant;
          Seek (Self.I, pos_Ant);
          Write (Self.I, Reg_Ant);
        end
      else
        begin //Elimino en el medio
          pos_Sig:= Reg.Sig;
          pos_Ant:= Reg.Ant;
          Seek (Self.I, pos_Sig);
          Read (Self.I, Reg_Ant);  
          Seek (Self.I, pos_Ant);
          Read (Self.I, Reg_Sig);

          Reg_Ant.Sig:= pos_Sig;
          Reg_Sig.Ant:= pos_Ant;

          Seek (Self.I, pos_Ant);
          Write (Self.I, Reg_Ant);
          Seek (Self.I, pos_Sig);
          Write (Self.I, Reg_Sig);
        end;

  //Agregar c�lula a borrados (al principio)
  Reg.Sig:= RC.Borrado_Prim;
  Reg.Ant:= _Pos_Nula;

  if RC.Borrado_Prim <> _Pos_Nula then
    begin
      Seek (Self.I, RC.Borrado_Prim);
      Read (Self.I, Reg_X);
      Reg_X.Ant:= pos; 
      Seek (Self.I, RC.Borrado_Prim);
      Write (Self.I, Reg_X);
    end
  else
    RC.Borrado_Ult:= pos;

  RC.Borrado_Prim:= pos;

  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);

  //Grabo el registro del �ndice
  Seek (Self.I, Pos);
  Write (Self.I, Reg);
end;

//--------------------------------------------------
Procedure oTipo_Listas.Intercambio;
var
  RI, RI2, Reg_Ant, Reg_Sig, RI_Aux: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (self.C, 0);
  Read (Self.C, RC);

  //Leo el registro 1
  Seek (Self.I, Pos);
  Read (Self.I, RI);

  //Leo el registro 2
  Seek (Self.I, Pos2);
  Read (Self.I, RI2);

  if (pos <> RC.Primero) and (pos <> RC.Ultimo) and (pos2 <> RC.Primero) and (pos2 <> RC.Ultimo) then
    begin
      if (RI.Sig = pos2) then
        begin
          Seek (Self.I,RI.Ant);
          Read (Self.I,Reg_Ant);
          Reg_Ant.Sig:= pos2;
          Seek (Self.I,RI.Ant);
          write (Self.I,Reg_Ant);
           
          Seek (Self.I,RI2.Sig);
          Read (Self.I,Reg_Sig);
          Reg_Sig.Ant:= pos;
          Seek (Self.I,RI2.Sig);
          write (Self.I,Reg_Sig);
        end
      else
        if (RI2.Sig = pos) then
          begin              
            Seek (Self.I,RI2.Ant);
            Read (Self.I,Reg_Ant);
            Reg_Ant.Sig:= pos;     
            Seek (Self.I,RI2.Ant);
            write (Self.I,Reg_Ant);
                                   
            Seek (Self.I,RI.Sig);
            Read (Self.I,Reg_Sig);
            Reg_Sig.Ant:= pos2;        
            Seek (Self.I,RI.Sig);
            write (Self.I,Reg_Sig);
          end
        else
          begin
            Seek (Self.I,RI.Ant);
            Read (Self.I,Reg_Ant);
            Reg_Ant.Sig:= pos2;
            Seek (Self.I,RI.Ant);
            write (Self.I,Reg_Ant);

            Seek (Self.I,RI.Sig);
            Read (Self.I,Reg_Sig);
            Reg_Sig.Ant:= pos2;
            Seek (Self.I,RI.Sig);
            write (Self.I,Reg_Sig);

            Seek (Self.I,RI2.Ant);
            Read (Self.I,Reg_Ant);
            Reg_Ant.Sig:= pos;
            Seek (Self.I,RI2.Ant);
            write (Self.I,Reg_Ant);

            Seek (Self.I,RI2.Sig);
            Read (Self.I,Reg_Sig);
            Reg_Sig.Ant:= pos;
            Seek (Self.I,RI2.Sig);
            write (Self.I,Reg_Sig);
          end;
    end
  else
    if (pos = RC.Primero) and (pos2 <> RC.Ultimo) then
     begin
      if (RI.Sig = pos2) then
        begin
          Seek (Self.I,RI2.Sig);
          Read (Self.I,Reg_Sig);
          Reg_Sig.Ant:= pos;
          Seek (Self.I,RI2.Sig);
          write (Self.I,Reg_Sig);
        end
      else
        begin
          Seek (Self.I,RI.Sig);
          Read (Self.I,Reg_Sig);
          Reg_Sig.Ant:= pos2;
          Seek (Self.I,RI.Sig);
          write (Self.I,Reg_Sig);

          Seek (Self.I,RI2.Ant);
          Read (Self.I,Reg_Ant);
          Reg_Ant.Sig:= pos;
          Seek (Self.I,RI2.Ant);
          write (Self.I,Reg_Ant);

          Seek (Self.I,RI2.Sig);
          Read (Self.I,Reg_Sig);
          Reg_Sig.Ant:= pos;        
          Seek (Self.I,RI2.Sig);
          write (Self.I,Reg_Sig);
        end;

      RC.Primero:= pos2
    end
   else
    if (pos = RC.Primero) and (pos2 = RC.Ultimo) then
      begin     
        Seek (Self.I,RI.Sig);
        Read (Self.I,Reg_Sig);
        Reg_Sig.Ant:= pos2;
        Seek (Self.I,RI.Sig);
        write (Self.I,Reg_Sig);

        Seek (Self.I,RI2.Ant);
        Read (Self.I,Reg_Ant);
        Reg_Ant.Sig:= pos;       
        Seek (Self.I,RI2.Ant);
        write (Self.I,Reg_Ant);

        RC.Primero:= pos2;
        RC.Ultimo:= pos;
      end
    else
      if (pos2 = RC.Primero) and (pos <> RC.Ultimo) then
        begin
          if (RI2.Sig = pos) then
            begin
              Seek (Self.I,RI.Sig);
              Read (Self.I,Reg_Sig);
              Reg_Sig.Ant:= pos2;   
              Seek (Self.I,RI.Sig);
              write (Self.I,Reg_Sig);
            end
          else
            begin   
              Seek (Self.I,RI2.Sig);
              Read (Self.I,Reg_Sig);
              Reg_Sig.Ant:= pos;  
              Seek (Self.I,RI2.Sig);
              write (Self.I,Reg_Sig);
                   
              Seek (Self.I,RI.Ant);
              Read (Self.I,Reg_Ant);
              Reg_Ant.Sig:= pos2; 
              Seek (Self.I,RI.Ant);
              write (Self.I,Reg_Ant);

              
              Seek (Self.I,RI.Sig);
              Read (Self.I,Reg_Sig);
              Reg_Sig.Ant:= pos2;   
              Seek (Self.I,RI.Sig);
              write (Self.I,Reg_Sig);
            end;

          RC.Primero:= pos
        end
      else
        if (pos2 = RC.Primero) and (pos = RC.Ultimo) then
          begin          
            Seek (Self.I,RI2.Sig);
            Read (Self.I,Reg_Sig);
            Reg_Sig.Ant:= pos;
            Seek (Self.I,RI2.Sig);
            write (Self.I,Reg_Sig);

            Seek (Self.I,RI.Ant);
            Read (Self.I,Reg_Ant);
            Reg_Ant.Sig:= pos2;
            Seek (Self.I,RI.Ant);
            write (Self.I,Reg_Ant);

            RC.Primero:= pos;
            RC.Ultimo:= pos2;
          end
        else
          if (pos = RC.Ultimo) and (pos2 <> RC.Primero) then
            begin
              if (RI.Ant = pos2) then
                begin
                  Seek (Self.I,RI2.Ant);
                  Read (Self.I,Reg_Ant);
                  Reg_Ant.Sig:= pos;
                  Seek (Self.I,RI2.Ant);
                  write (Self.I,Reg_Ant);
                end
              else
                begin
                  Seek (Self.I,RI.Ant);
                  Read (Self.I,Reg_Ant);
                  Reg_Ant.Sig:= pos2;
                  Seek (Self.I,RI.Ant);
                  write (Self.I,Reg_Ant);

                  Seek (Self.I,RI2.Ant);
                  Read (Self.I,Reg_Ant);
                  Reg_Ant.Sig:= pos;
                  Seek (Self.I,RI2.Ant);
                  write (Self.I,Reg_Ant);

                  Seek (Self.I,RI2.Sig);
                  Read (Self.I,Reg_Sig);
                  Reg_Sig.Ant:= pos;
                  Seek (Self.I,RI2.Sig);
                  write (Self.I,Reg_Sig);
                end;

              RC.Ultimo:= pos2
            end
          else
            if (pos = RC.Ultimo) and (pos2 = RC.Primero) then
              begin
                Seek (Self.I,RI.Ant);
                Read (Self.I,Reg_Ant);
                Reg_Ant.Sig:= pos2;
                Seek (Self.I,RI.Ant);
                write (Self.I,Reg_Ant);

                Seek (Self.I,RI2.Sig);
                Read (Self.I,Reg_Sig);
                Reg_Sig.Ant:= pos;
                Seek (Self.I,RI2.Sig);
                write (Self.I,Reg_Sig);

                RC.Primero:= pos;
                RC.Ultimo:= pos2;
              end
            else
              if (pos2 = RC.Ultimo) and (pos <> RC.Primero) then
                begin
                  if (RI2.Ant = pos) then
                    begin
                      Seek (Self.I,RI.Ant);
                      Read (Self.I,Reg_Ant);
                      Reg_Ant.Sig:= pos2;   
                      Seek (Self.I,RI.Ant);
                      write (Self.I,Reg_Ant);
                    end
                  else
                    begin              
                      Seek (Self.I,RI2.Ant);
                      Read (Self.I,Reg_Ant);
                      Reg_Ant.Sig:= pos;        
                      Seek (Self.I,RI2.Ant);
                      write (Self.I,Reg_Ant);
                      
                      Seek (Self.I,RI.Ant);
                      Read (Self.I,Reg_Ant);
                      Reg_Ant.Sig:= pos2;      
                      Seek (Self.I,RI.Ant);
                      write (Self.I,Reg_Ant);

                      Seek (Self.I,RI.Sig);
                      Read (Self.I,Reg_Sig);
                      Reg_Sig.Ant:= pos2;   
                      Seek (Self.I,RI.Sig);
                      write (Self.I,Reg_Sig);
                    end;

                  RC.Ultimo:= pos
                end
              else
                if (pos2 = RC.Ultimo) and (pos = RC.Primero) then
                  begin
                    Seek (Self.I,RI2.Ant);
                    Read (Self.I,Reg_Ant);
                    Reg_Ant.Sig:= pos;    
                    Seek (Self.I,RI2.Ant);
                    write (Self.I,Reg_Ant);

                    Seek (Self.I,RI.Sig);
                    Read (Self.I,Reg_Sig);
                    Reg_Sig.Ant:= pos2;
                    Seek (Self.I,RI.Sig);
                    write (Self.I,Reg_Sig);

                    RC.Primero:= pos2;
                    RC.Ultimo:= pos;
                  end;

  if (RI.Sig = pos2) then
    begin
      RI_Aux:= RI2;
      RI2.Ant:= RI.Ant;
      RI2.Sig:= pos;               
      Seek (Self.I,pos2);
      write (Self.I,RI2);

      RI.Ant:= pos2;
      RI.Sig:= RI_Aux.Sig;
      Seek (Self.I,pos);
      write (Self.I,RI);
    end
  else
    if (RI2.Sig = pos) then
      begin
        RI_Aux:= RI2;
        RI2.Ant:= pos;
        RI2.Sig:= RI.Sig;
        Seek (Self.I,pos2);
        write (Self.I,RI2);

        RI.Ant:= RI_Aux.Ant;
        RI.Sig:= pos2;
        Seek (Self.I,pos);
        write (Self.I,RI);
      end
    else
      begin
        RI_Aux:= RI2;
        RI2.Sig:= RI.Sig;
        RI2.Ant:= RI.Ant;         
        Seek (Self.I,pos2);
        write (Self.I,RI2);

        RI.Sig:= RI_Aux.Sig;
        RI.Ant:= RI_Aux.Ant;     
        Seek (Self.I,pos);
        write (Self.I,RI);
      end;

  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);
end;

//--------------------------------------------------
Procedure oTipo_Listas.Capturar;
begin
  Seek (Self.I, Pos);
  Read (Self.I, Reg);
end;

//--------------------------------------------------
Procedure oTipo_Listas.Modificar;
begin
  Seek (Self.I, Pos);
  Write (Self.I, Reg);
end;

//--------------------------------------------------
Function oTipo_Listas.Primero;
var
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  Primero:= RC.Primero;
end;

//--------------------------------------------------
Function oTipo_Listas.Ultimo;
var
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  Ultimo:= RC.Ultimo;
end;

//--------------------------------------------------
Function oTipo_Listas.Proximo;
var
  RI: Tipo_Reg_Indice;
begin
  if Pos < FileSize (self.I) then
    begin
      Seek (Self.I, Pos);
      Read (Self.I, RI);
      Proximo:= RI.Sig;
    end
  else
    Proximo:= _Pos_Nula;
end;

//--------------------------------------------------
Function oTipo_Listas.Anterior;
var
  RI: Tipo_Reg_Indice;
begin
  if Pos > 0 then
    begin
      Seek (Self.I, Pos);
      Read (Self.I, RI);
      Anterior:= RI.Ant;
    end
  else
    Anterior:= _Pos_Nula;
end;

//--------------------------------------------------
Function oTipo_Listas.Pos_Nula;
begin
  Pos_Nula:= _Pos_Nula;
end;

//--------------------------------------------------
Function oTipo_Listas.Vacio;
begin
  Vacio:= FileSize (Self.I) = 0;
end;

//--------------------------------------------------
Procedure oTipo_Listas.Vaciar;
var
  RC: Tipo_Reg_Control;
begin
  Close (Self.I);
  Rewrite (Self.I);
  Reset (Self.I);

  Seek (Self.C, 0);
  Read (Self.C, RC);
  RC.Primero:= _Pos_Nula;
  RC.Ultimo:= _Pos_Nula;
  RC.Borrado_Prim:= _Pos_Nula;
  RC.Borrado_Ult:= _Pos_Nula;
  Seek (Self.C, 0);
  Write (Self.C, RC);
End;

//--------------------------------------------------
Function oTipo_Listas.Clave_Nula;
begin
  Clave_Nula:= _Clave_Nula;
end;

//--------------------------------------------------
Function oTipo_Listas.Id_Nulo;
begin
  Id_Nulo:= _Id_Nulo;
end;

//--------------------------------------------------
Destructor oTipo_Listas.Destroy;
begin
  Inherited Destroy;
end;


{-----------------------M�todos Mazo-----------------------}

Constructor oTipo_Mazo.Create;
Const
  Palos: array[1..4] of string = ('Oro','Basto','Copa','Espada');
  Nombres: array[1..12] of string = ('As','Dos','Tres','Cuatro','Cinco','Seis','Siete',
                                    'Ocho','Nueve','Sota','Caballo','Rey');
var
  i,j: byte;
  Reg_Carta: Tipo_Una_Carta;
  RI: Tipo_Reg_Indice;
begin
  Inherited Create(cRuta,cNombre,limite);
  Self.Abrir;
  Self.Cartas:= oTipo_ADS.Create(GetCurrentDir,'Cartas');
  Self.Cartas.Abrir;

  if self.Vacio then
    begin
      for i:= Low(Palos) to High(Palos) do
        for j:= Low(Nombres) to limite do
          begin
            Reg_Carta.Clave:= Palos[i] + '-' + Nombres[j];
            Reg_Carta.Palo:= Palos[i];
            Reg_Carta.Num:= j;
            Reg_Carta.Nombre:= Nombres[j];
            RI.Clave:= Reg_Carta.Clave;
            RI.Pos:= Self.Cartas.Pos_Nueva;
            Self.Cartas.Insertar(Reg_Carta,Self.Cartas.Pos_Nueva);
            Self.Insertar(RI,Self.Pos_Nula);
          end;   
      Self.Ordenado:= True;
      Self.Mezclado:= False;
      Self.Cortes:= False;
    end;
end;

Procedure oTipo_Mazo.Mezclar;
var
  i: byte;
  Pos, Pos2: Tipo_Posicion;
begin
  randomize;
  for i:= 1 to limite * 10 do
    begin
      pos:= randomRange(0,Limite*4);
      repeat
        pos2:= randomRange(0,Limite*4);
      until (pos <> pos2);

      Self.Intercambio(pos,pos2);
    end;

  Self.Mezclado:= true;
  Self.ordenado:= false;
end;

Procedure oTipo_Mazo.Cortar;
var
  pos1, pos2,posCorte,pos3: Tipo_Posicion;
  RI1, RI2, RICorte, RI3: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  randomize;
  repeat
    posCorte:= RandomRange(0,Limite*4); 
  until (posCorte <> RC.Primero) and (PosCorte <> RC.Ultimo);

  pos1:= RC.Primero;
  Seek (Self.I, pos1);
  Read (Self.I, RI1);   

  pos3:= RC.Ultimo;
  Seek (Self.I, pos3);
  Read (Self.I, RI3);

  Seek (Self.I, posCorte);
  Read (Self.I, RICorte);

  pos2:= RICorte.Ant;
  Seek (Self.I, pos2);
  Read (Self.I, RI2);    

  if (RICorte.Ant = RC.Primero) then
    begin
      RICorte.Ant:= _Pos_Nula;
      RI1.Ant:= pos3;
      RI1.Sig:= _Pos_Nula;
      RI2.Ant:= pos3;
    end
  else
    begin
      RI1.Ant:= pos3;
      RICorte.Ant:= _Pos_Nula;
    end;

  RI2.Sig:= _Pos_Nula;
  RI3.Sig:= pos1;

  RC.Primero:= posCorte;
  RC.Ultimo:= pos2;

  Seek (Self.I, pos1);
  write (Self.I, RI1);
  
  Seek (Self.I, pos2);
  write (Self.I, RI2);

  Seek (Self.I, posCorte);
  write (Self.I, RICorte);

  Seek (Self.I, pos3);
  write (Self.I, RI3);
           
  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);

  Self.Cortes:= true;
  Self.ordenado:= false;
end;

Function oTipo_Mazo.DarCarta;
var
  RI: Tipo_Reg_Indice;
begin
  Self.Capturar(RI,Self.Ultimo);
  DarCarta:= RI;
end;

Procedure oTipo_Mazo.Carta_Ganada;
begin
  Self.Eliminar(Self.Ultimo);
end;

Function oTipo_Mazo.Mazo_Ordenado;
begin
  Result:= Self.ordenado;
end;

Function oTipo_Mazo.Mazo_Mezclado;
begin
  Result:= Self.Mezclado;
end;

Function oTipo_Mazo.Mazo_Cortado;
begin
  Result:= Self.Cortes;
end;

Destructor oTipo_Mazo.Destroy;
begin
  Inherited Destroy;
end;


{-----------------------M�todos Pilas-----------------------}

Constructor oTipo_Pila.Create;
var
  Ruta: string;
  RC: Tipo_Reg_Control;
begin
  Inherited Create;
  Ruta:= cRuta + '\' + cNombre;
  Assign (Self.C, Ruta + '.CON');
  Assign (Self.I, Ruta + '.NTX');
  if (FileExists (Ruta + '.CON') = false) or
      (FileExists (Ruta + '.NTX') = false) then
    begin
      //Genero Control
      Rewrite (Self.C);
      RC.Primero:= _Pos_Nula;
      RC.Ultimo:= _Pos_Nula;
      Write (Self.C, RC);
      Close (Self.C);
      
      //Genero Indice
      Rewrite (Self.I);
      Close (Self.I);
    end;
end;

Procedure oTipo_Pila.AbrirPila;
begin
  Reset (Self.I);
  Reset (Self.C);
end;

Procedure oTipo_Pila.CerrarPila;
begin
  Close (Self.I);
  Close (Self.C);
end;

Function oTipo_Pila.Tope;  //Si no est� vac�o
var
  RI: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (self.C,0);
  Read (self.C,RC);

  Seek (Self.I, RC.Primero);
  Read (Self.I, RI);

  Tope:= RI;
end;

Procedure oTipo_Pila.Apilar;
var
  RC: Tipo_Reg_Control;
  Pos_Nueva: Tipo_Posicion;
begin
  // La rutina apila en la primer posicion

  // Leo archivo de Control
  Seek (self.C, 0);
  Read (Self.C, RC);

  Pos_Nueva:= FileSize (Self.I);

  if RC.Primero = _Pos_Nula then
    begin //Apilo en Pila Vac�a
      RC.Primero:= Pos_Nueva;
      RC.Ultimo:= Pos_Nueva;
      RI.Sig:= _Pos_Nula;
    end
  else
    begin //Apilo en Pila ya existente
      RI.Sig:= RC.Primero;
      RC.Primero:= Pos_Nueva;
    end;

  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);

  //Grabo el registro del �ndice
  Seek (Self.I, Pos_Nueva);
  Write (Self.I, RI);
end;

Procedure oTipo_Pila.Desapilar;
var
  RI: Tipo_Reg_Indice;
  RC: Tipo_Reg_Control;
  Pos_Delete: Tipo_Posicion;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  Pos_Delete:= RC.Primero;

  Seek (Self.I, RC.Primero);
  Read (Self.I, RI);

  If RC.Primero = RC.Ultimo then
    begin //Desapilo y Pila Vac�a
      RC.Primero:= _Pos_Nula;
      RC.Ultimo:= _Pos_Nula;
    end
  else
    begin //Retiro el primero y quedan otros
      RC.Primero:= RI.Sig;
    end;

  //Agregar c�lula a borrados (al principio)
  RI.Sig:= RC.Borrado_Prim;
  RC.Borrado_Prim:= Pos_Delete;

  //Grabo el registro de control
  Seek (Self.C, 0);
  Write (Self.C, RC);

  //Grabo el registro del �ndice
  Seek (Self.I, Pos_Delete);
  Write (Self.I, RI);
end;

Function oTipo_Pila.Pos_Nula;
begin
  Pos_Nula:= _Pos_Nula;
end;

Function oTipo_Pila.Pila_Vacia;
var
  RC: Tipo_Reg_Control;
begin
  // Leo archivo de Control
  Seek (Self.C, 0);
  Read (Self.C, RC);

  Pila_Vacia:= RC.Primero = -1;
end;

Procedure oTipo_Pila.Vaciar;
var
  RC: Tipo_Reg_Control;
begin
  Close (Self.I);
  Rewrite (Self.I);
  Reset (Self.I);

  Seek (Self.C, 0);
  Read (Self.C, RC);
  RC.Primero:= _Pos_Nula;
  RC.Ultimo:= _Pos_Nula;
  Seek (Self.C, 0);
  Write (Self.C, RC);
End;

Destructor oTipo_Pila.Destroy;
begin
  Inherited Destroy;
end;


{-----------------------M�todos Montones-----------------------}
Procedure oTipo_Montones.Volcar_Carta;
var
  Reg_Carta: Tipo_Una_Carta;
begin      
  Self.Cartas:= oTipo_ADS.Create(GetCurrentDir,'Cartas');
  Self.Cartas.Abrir;

  Self.Apilar(RI);
  self.Cartas.Capturar(Reg_Carta,RI.Pos);
  Grilla.Cells[0,Grilla.RowCount-1]:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);  
  Grilla.Rows[Grilla.RowCount].Clear;
  Grilla.RowCount:= succ(Grilla.RowCount);
end;


{-----------------------M�todos del Juego-----------------------}

Procedure oTipo_solitario.Crear;
begin
  Self.Cartas:= oTipo_ADS.Create(GetCurrentDir,'Cartas');
  Self.Cartas.Abrir;
  Self.Mazo:= oTipo_Mazo.Create(GetCurrentDir,'Mazo',Self.Limite_Cartas);
  Self.Mazo.Abrir;
  Self.Monton1:= oTipo_Montones.Create(GetCurrentDir,'Monton1');
  Self.Monton1.AbrirPila;
  Self.Monton2:= oTipo_Montones.Create(GetCurrentDir,'Monton2');
  Self.Monton2.AbrirPila;
  Self.Monton3:= oTipo_Montones.Create(GetCurrentDir,'Monton3');
  Self.Monton3.AbrirPila;
  Self.Monton4:= oTipo_Montones.Create(GetCurrentDir,'Monton4');
  Self.Monton4.AbrirPila;
  Self.Oros:= oTipo_Montones.Create(GetCurrentDir,'Oros');
  Self.Oros.AbrirPila;
  Self.Espadas:= oTipo_Montones.Create(GetCurrentDir,'Espadas');
  Self.Espadas.AbrirPila;
  Self.Bastos:= oTipo_Montones.Create(GetCurrentDir,'Bastos');
  Self.Bastos.AbrirPila;
  Self.Copas:= oTipo_Montones.Create(GetCurrentDir,'Copas');
  Self.Copas.AbrirPila;
  Self.Descarte:= oTipo_Montones.Create(GetCurrentDir,'Descarte');
  Self.Descarte.AbrirPila;
  Self.Monton_Aux:= oTipo_Montones.Create(GetCurrentDir,'Monton_Aux');
  Self.Monton_Aux.AbrirPila;
end;

//--------------------------------------------------
Procedure oTipo_Solitario.Cerrar;
begin
  Self.Monton_Aux.CerrarPila;
  Self.Monton_Aux.Destroy;
  Self.Descarte.CerrarPila;
  Self.Descarte.Destroy;
  Self.Copas.CerrarPila;
  Self.Copas.Destroy;
  Self.Bastos.CerrarPila;
  Self.Bastos.Destroy;
  Self.Espadas.CerrarPila;
  Self.Espadas.Destroy;
  Self.Oros.CerrarPila;
  Self.Oros.Destroy;
  Self.Monton4.CerrarPila;
  Self.Monton4.Destroy;
  Self.Monton3.CerrarPila;
  Self.Monton3.Destroy;
  Self.Monton2.CerrarPila;
  Self.Monton2.Destroy;
  Self.Monton1.CerrarPila;
  Self.Monton1.Destroy;
  Self.Mazo.Cerrar;
  Self.Mazo.Destroy;
  Self.Cartas.Cerrar;
  Self.Cartas.Destroy;
  Self.Destroy;
end;

//--------------------------------------------------
Procedure oTipo_Solitario.Nueva_Partida;
begin
  Self.Cartas.Vaciar;
  Self.Mazo.Vaciar;
  Self.Monton1.Vaciar;
  Self.Monton2.Vaciar;
  Self.Monton3.Vaciar;
  Self.Monton4.Vaciar;
  Self.Oros.Vaciar;
  Self.Bastos.Vaciar;
  Self.Copas.Vaciar;
  Self.Espadas.Vaciar;
  Self.Descarte.Vaciar;


  Self.Limite:= Limite;
end;

//--------------------------------------------------
Function oTipo_Solitario.Limite_Cartas;
begin
  Result:= Self.Limite;
end;

//--------------------------------------------------
Procedure oTipo_Solitario.Mostrar_Mazo;
var
  Reg_Carta: Tipo_Reg_Indice;
  pos_Carta, i: Tipo_Posicion;
begin  
  pos_Carta:= Self.Mazo.Primero;
  i:= 0;
  while (pos_Carta <> Self.Mazo.Pos_Nula) do
    begin
      Self.Mazo.Capturar(Reg_Carta,pos_Carta);
      grilla.Cells[i,0]:= Reg_Carta.Clave;
      pos_Carta:= Self.Mazo.Proximo(pos_Carta);
      i:= succ(i);
    end;
  grilla.ColCount:= i;
end;

//--------------------------------------------------
Function oTipo_Solitario.Carta_Mazo;
var
  Reg_Mazo: Tipo_Reg_Indice;
  Reg_Carta: Tipo_Una_Carta;
begin
  Self.Mazo.Capturar(Reg_Mazo,Self.Mazo.Ultimo);
  Self.Cartas.Capturar(Reg_Carta,Reg_Mazo.Pos);
  Result:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
end;

//--------------------------------------------------
Procedure oTipo_Solitario.Rellenar_Mazo;
var
  Reg_Descarte: Tipo_Reg_Indice;
begin
  Self.Mazo.Vaciar;
  Repeat
    Reg_Descarte:= Self.Descarte.Tope;
    Self.Mazo.Insertar(Reg_Descarte,Self.Mazo.Pos_Nula);
    Self.Descarte.Desapilar;
  until Self.Descarte.Pila_Vacia;
end;

//--------------------------------------------------
Function oTipo_Solitario.Juego_Finalizado;
begin
  if ((Self.Mazo.Primero = _Pos_Nula) and (Self.Monton1.Pila_Vacia) and (Self.Monton2.Pila_Vacia)
      and (Self.Monton3.Pila_Vacia) and (Self.Monton4.Pila_Vacia) and (Self.Descarte.Pila_Vacia)) then
    Juego_Finalizado:= True
  else
    Juego_Finalizado:= False;
end;

//--------------------------------------------------
Procedure oTipo_Solitario.Seguir_Jugando;
var
  RI: Tipo_Reg_Indice;
  Reg_Carta: Tipo_Una_Carta;
begin
  while Self.Monton1.Pila_Vacia = false do
    begin
      RI:= Self.Monton1.Tope;
      Self.Monton1.Desapilar;
      Self.Monton_Aux.Apilar(RI);
    end;
  while Self.Monton_Aux.Pila_Vacia = false do
    begin
      RI:= Self.Monton_Aux.Tope;
      Self.Monton_Aux.Desapilar;
      Self.Monton1.Apilar(RI);
      self.Cartas.Capturar(Reg_Carta,RI.Pos);
      Grilla1.Cells[0,Grilla1.RowCount-1]:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
      Grilla1.RowCount:= succ(Grilla1.RowCount);
    end;

  while Self.Monton2.Pila_Vacia = false do
    begin
      RI:= Self.Monton2.Tope;
      Self.Monton2.Desapilar;
      Self.Monton_Aux.Apilar(RI);
    end;
  while Self.Monton_Aux.Pila_Vacia = false do
    begin
      RI:= Self.Monton_Aux.Tope;
      Self.Monton_Aux.Desapilar;
      Self.Monton2.Apilar(RI);
      self.Cartas.Capturar(Reg_Carta,RI.Pos);
      Grilla2.Cells[0,Grilla2.RowCount-1]:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
      Grilla2.RowCount:= succ(Grilla2.RowCount);
    end;

  while Self.Monton3.Pila_Vacia = false do
    begin
      RI:= Self.Monton3.Tope;
      Self.Monton3.Desapilar;
      Self.Monton_Aux.Apilar(RI);
    end;
  while Self.Monton_Aux.Pila_Vacia = false do
    begin
      RI:= Self.Monton_Aux.Tope;
      Self.Monton_Aux.Desapilar;
      Self.Monton3.Apilar(RI);
      self.Cartas.Capturar(Reg_Carta,RI.Pos);
      Grilla3.Cells[0,Grilla3.RowCount-1]:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
      Grilla3.RowCount:= succ(Grilla3.RowCount);
    end;

  while Self.Monton4.Pila_Vacia = false do
    begin
      RI:= Self.Monton4.Tope;
      Self.Monton4.Desapilar;
      Self.Monton_Aux.Apilar(RI);
    end;
  while Self.Monton_Aux.Pila_Vacia = false do
    begin
      RI:= Self.Monton_Aux.Tope;
      Self.Monton_Aux.Desapilar;
      Self.Monton4.Apilar(RI);
      self.Cartas.Capturar(Reg_Carta,RI.Pos);
      Grilla4.Cells[0,Grilla4.RowCount-1]:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
      Grilla4.RowCount:= succ(Grilla4.RowCount);
    end;

  if not Self.Descarte.Pila_Vacia then
    begin
      RI:= Self.Descarte.Tope;
      Self.Cartas.Capturar(Reg_Carta,RI.Pos);
      ERetirados.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
    end
  else
    ERetirados.Text:= '';

  if not Self.Oros.Pila_Vacia then
    begin
      RI:= Self.Oros.Tope;
      Self.Cartas.Capturar(Reg_Carta,RI.Pos);
      EOro.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
    end
  else
    EOro.Text:= '';

  if not Self.Espadas.Pila_Vacia then
    begin
      RI:= Self.Espadas.Tope;
      Self.Cartas.Capturar(Reg_Carta,RI.Pos);
      EEspada.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);       
    end
  else
    EEspada.Text:= '';

  if not Self.Copas.Pila_Vacia then
    begin
      RI:= Self.Copas.Tope;
      Self.Cartas.Capturar(Reg_Carta,RI.Pos);
      ECopa.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);    
    end
  else
    ECopa.Text:= '';

  if not Self.Bastos.Pila_Vacia then
    begin
      RI:= Self.Bastos.Tope;
      Self.Cartas.Capturar(Reg_Carta,RI.Pos);
      EBasto.Text:= Reg_Carta.Palo + '-' + IntToStr(Reg_Carta.Num);
    end
  else
    EBasto.Text:= '';
end;

end.
