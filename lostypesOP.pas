unit LosTypes;

{$mode objfpc}{$H+}

interface

const
  Dimension = 2; // x, y
  InfoNum = 14;
  InfoStr: array[1..InfoNum] of string =
  ('Observación', 'Mínimo', 'Máximo', 'Rango', 'Media(Promedio)', 'Varianza',
   'Desviación Estándar', 'Coef. de Variación', 'Er Est', 'Asimétrica',
   'Curtosis', 'Percentil 25', 'Mediana', 'Percentil 75');
  debugFile='debug.txt';
  Efecto_de_Pepita_Puro: boolean = False;
  NearlyZero  = 1E-07;
  NumeroDatos= 10000;
type
  {tipos de datos}
  tSingle4 = single;       //1.5x10^-45..3.4x10^38
  tSingle8 = double;       //5.0x10^-324..1.7x10^308
  tEntero8s  = Shortint;   //-128..127
  tEntero16s = Smallint;   //-32768..32767
  tEntero32s = Longint;    //-2147483648..2147483647
  tEntero8   = Byte;       //0..255
  tEntero16  = Word;       //0..65535
  tEntero32  = Longword;   //0..4294967295
  { TEstimacion }
  TEstimacion = (Puntual, Bloques);
  { TRejilla }
  TRejilla = record
    NodosX        :Integer;
    NodosY        :Integer;
    OrigenX       :tSingle4;
    OrigenY       :tSingle4;
    IncX          :tSingle4;
    IncY          :tSingle4;
    //Celdas     :Array Of Boolean;
  end;
  { TInVDistKrigData }
  TInVDistKrigData= record
    RadioX,RadioY:real;
    Coef: tEntero8; //coeficiente de estimación inverso de la distancia
    Angulo: tSingle4;
  end;
  { TVario }
  TVario = Record
              NoPares     :tEntero16;      //
              NoPMarcados :tEntero16;
              Lag         :tSingle4;    //
              PromDist    :tSingle4;
              Diferencia  :Array[1..3000] Of Record                //
                                               P1,P2   :tEntero16;      //
                                               Marcado :Boolean;   //
                                               Dist    :tSingle4;    //
                                               Valor   :tSingle4;    //
                                             End;
              Gamma       :tSingle4;    //
            End;
  { TGamma }
  TGamma = Record
    DirHorizontal,
    DirVertical    :tSingle4;
    Vario          :Array[1..200] Of TVario;
  end;
  { TPar }
  TPar = record
    p1,p2: tEntero16;
  end;
  { TPares }
  TPares = Record
              NIndice   :tEntero32s;
              Distancia :tSingle4;
              Alfa      :tSingle4;
              Beta      :tSingle4;
              par       :TPar;
            End;
  { Tls }
  Tls = record
    x,y: tEntero8;
  end;
  { TEstadData }
  TEstadData= record
    Observacion  :tSingle4;
    Minimo       :tSingle4;
    Maximo       :tSingle4;
    Rango        :tSingle4;
    Media        :tSingle4;
    Varianza     :tSingle4;
    DesvEstandar :tSingle4;
    CoefVariacion:tSingle4;
    ErEst        :tSingle4;
    Asimetrica   :tSingle4;
    Curtosis     :tSingle4;
    Percentil25  :tSingle4;
    Mediana      :tSingle4;
    Percentil75  :tSingle4;
  end;
  { TmiAlign }
  TmiAlign=(centro,derecha);
  { TTipoTabla }
  TTipoTabla = Record
    Li     :tSingle4;
    Ls     :tSingle4;
    ni     :tEntero16;
    Fri    :tSingle4;
    Fai    :tEntero16;
    Frai   :tSingle4;
    MC     :tSingle4;
  End;
  { TTipoIndiceNi }
  TTipoIndiceNi = Record
    Marcado :Boolean;
    NoNi    :Integer;
    Indice  :Array[1..400] Of Integer;
  End;
  { TelHistorigrama }
  TelHistorigrama= record
    Tabla           :Array[1..20] Of TTipoTabla;
    IntervaloNi     :Array[1..20] Of TTipoIndiceNi;
  end;
  { TMapaV }
  TMapaV = Record
    GValor    :tSingle4;
    NPares    :Integer;
  End;
  { TFNewFile }
  TaImprimir = (IDatosE,IEstad,IHisto,IEstim);
  { TVarioDir }
  TVarioDir = (Vertical, Horizontal);
  { TModelo }
  TModelo = record
    Tipo: tEntero8; {Tipo de Modelo, 0.- Ninguno,
                                            1.-Esférico, 2.-Exponencial
                                            3.- Gaussiano, 4.-Lineal}
    C:    real; {Meseta, Sill, Palier}
    AX:   real; {Alcance en X, Range, Portée}
    AY:   real; {Alcance en Y, Range, Portée}
  end;
  { TAjusteV }
  TAjusteV = record
    meseta: tSingle4;
    alcancex, alcancey: tSingle4;
    seleccionado: boolean;
  end;
  { TCriterios }
  TCriterios = record
    NPuntos:    integer;
    VReal:      array[1..NumeroDatos] of tSingle4;   //aparentemente la cant de puntos NCasos
    VEstimado:  array[1..NumeroDatos] of tSingle4;
    VKriging:   array[1..NumeroDatos] of tSingle4;
    ErrorMedio: tSingle4;
    ErrorStMedio: tSingle4;
    VarianzaSt: tSingle4;
  end;
  { TLocalizacion }
  TLocalizacion = record
    Nombre:   string;
    X, Y, Z:  tSingle4;
    Variable: array[1..10] of tSingle4; //TVariable;
  end;
  { TAjuste }
  TAjuste = record
    //Titulo: string;
    VarioDir: TVarioDir;
    NVario: tEntero8;     //numero de variogramas
    NPVario: tEntero16;     //numero de puntos del variograma
    CovCorr: tSingle4;
    NEstructuras: tEntero8;
    Estructura: array[1..10] of TModelo;
    Anisotropia: boolean;
    AAnisot: tSingle4;//AnguloAnisot
    Co             :tSingle4;
    DatoZonaI: string;
    DatoOrdenMatriz: string;
    Media: tSingle4;
    Criterios: TCriterios;
    ajusteVario: array[0..4] of TAjusteV;
    Datos: array[1..1000] of TLocalizacion;
    N: integer; // NCasos -1 para el ajuste, no se toman puntos coincidentes
  end;
  { TLEstimacion }
  TLEstimacion = record
    Marcado: boolean;
    X, Y:    real;
    Np:      integer;
    Pesos:   array[1..400] of record
      Indice: integer;
      Valor:  real;
    end;
    Valor:  real;
    VEstim: real
  end;
  { TKriging }
  TKriging      = (Simple, Ordinario);
  { TMatriz }
  TMatriz = array[1..400, 1..400] of real;
  { TVector }
  TVector = array[1..400] of real;
  { TElKriging }
  TElKriging = record
    Matriz: TMatriz;
    VectorM, VectorL: TVector;
  end;
  { TDistancia }
  TDistancia = record
    P1, P2: real;
    DifX:   real;
    DifY:   real;
  end;
  { TCalcDistancias }
  TCalcDistancias= record
    Coef             :tSingle4;
    RadioX,RadioY:real;
    ZonaInflX:Real;
    ZonaInflY:Real;
    Estim         :Array[1..1] of TLEstimacion; {Localizaciones a estimar}
    DistEstimDato :Array[1..400] Of TDistancia;
    NoIndice      :Array[1..400] Of Integer; {Indice de los datos que se utilizan para estimar Xo,Yo o Xv,Yv}
    DistDatoDato  :Array[1..400,1..400] Of TDistancia; {Distancia entre datos}
    Np: integer;      {numero de localizaciones dentro del alcance y el indice de estas}
    //N :integer; //
    //AAnisot:tSingle4;
  end;
  {TGuardaGrafico}
  TGuardaGrafico = (edt,gmb,gmbp,ghisto,reg,dis,vario,map,estim);
var
  editado: boolean;
  TieneNombre: boolean;
  Nombre: string;
  ls: array of Tls;                //cant de saltos para imprimir
  ColEstat: array of array of tSingle4; //Estadística de las columnas
  losPares: array of TPares;
  elGamma: array of TGamma;
  MapaVar: array of array of TMapaV;
  aImprimir: TaImprimir;
  FRow: tEntero16;
  precision: tEntero8;
  camino: string;
  paresCalculados: boolean;
  EstadisticaCalculada:boolean;
  ICMB, ICMBP: tEntero16s;
  combinaciones: string;
  elHistorigrama: TelHistorigrama;    //calculo histo
  saltos, vueltas: tEntero8;
  //variograma
  NNp: tEntero16;    //numero de pares
  TolAngHor, TolAngVer: tSingle4;
  TolLineal: tSingle4;
  DistMax: tSingle4;
  Increm: tSingle4;
  CovCorr: tSingle4;
  //Mapa Var
  MapaMin,MapaMax:tSingle4;
  Ajuste:TAjuste;
  lasDistancias: TCalcDistancias;
  Kriging: TKriging;
  ElKriging: TElKriging;
  CantDatos: integer; //cant de rows, datos a procesar
  VActiva:integer;      //Variable Activa, la del combo
  //estimacion
  Rejilla :TRejilla;
  DKData: TInvDistKrigData;
  Estimacion    :TEstimacion;
  GuardaGrafico:TGuardaGrafico;
  laCol, laFil: Integer;
implementation

end.

