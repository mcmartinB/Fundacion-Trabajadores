{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE ON}
{$WARN UNSAFE_CODE ON}
{$WARN UNSAFE_CAST ON}
unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, DB, kbmMemTable;

type
  TFMain = class(TForm)
    pnlGrids: TPanel;
    dbgrdTrabajadores: TDBGrid;
    btnActualizar: TButton;
    btnSalir: TButton;
    pnl1: TPanel;
    dbgrdEmpresas: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnActualizarClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
  private
    { Private declarations }
    sRuta, sFicheroDatos: string;
    slTrabajadores, slTrabajadoresErr: TStringList;

    iOperarios: Integer;
    sCodPlanta: string;
    sNifOperario, sAlta, sBaja: string;

    procedure ActualizarDatos;
    function CargarTrabajadores: boolean;
    function LeerTrabajadores: boolean;
    function TokensTrabajador( const ALine: string ): boolean;

  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

{$R *.dfm}

uses
  FileCtrl, UUtils, UDMDestino;

var
  DMDestino: TDMDestino;

procedure TFMain.FormCreate(Sender: TObject);
begin
  //
  slTrabajadores:= TStringList.Create;
  slTrabajadoresErr:= TStringList.Create;

  sRuta:= ExtractFilePath(Application.ExeName);
  if Copy( sRuta, Length( sRuta ), 1 ) <> '\' then
    sRuta:= sRuta + '\';
  sFicheroDatos:= sRuta + 'DatosTrabajadoresFundacion.csv';


  btnActualizar.caption:= 'Actualizar Operarios -->>> '+ sFicheroDatos;
  DMDestino:= TDMDestino.Create( Self );
  if DMDestino.AbrirBaseDatos( sRuta  ) then
  begin
    DMDestino.qryEmpresas.Open;
    DMDestino.qryOperarios.Open;
  end;
end;

procedure TFMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //
  FreeAndNil( slTrabajadores );
  FreeAndNil( slTrabajadoresErr );

  DMDestino.CerrarBaseDatos;
  FreeAndNil( DMDestino );
end;

procedure TFMain.btnSalirClick(Sender: TObject);
begin
  Close;
end;

procedure TFMain.btnActualizarClick(Sender: TObject);
begin
  ActualizarDatos;
end;

procedure  TFMain.ActualizarDatos;
var
  iNuevos, iModificados: Integer;
begin
  if CargarTrabajadores then
  begin
    DMDestino.ActualizarOperarios( iNuevos, iModificados );
    if iOperarios <> iNuevos + iModificados then
    begin
      ShowMessage('ERROR al pasar los operarios, puede ser que no exista la empresa a la que estan asignados.' );
    end;
    ShowMessage('TOTAL = ' + IntToStr(iOperarios) + ' -->> Nuevos = ' + IntToStr(iNuevos) + ' // Modificados = ' + IntToStr(iModificados)  );
  end
  else
  begin
    ShowMessage('ERROR al leer el fichero ' + sFicheroDatos + ' o fichero sin datos.' );
  end;
end;


function TFMain.LeerTrabajadores: boolean;
begin
  if FileExists( sFicheroDatos ) then
  begin
    slTrabajadores.Clear;
    slTrabajadores.LoadFromFile( sFicheroDatos );
    Result:= True;
  end
  else
  begin
    Result:= False;
  end;
end;

function TFMain.CargarTrabajadores: boolean;
var
  i: Integer;
  dFecha: TDateTime;
begin
  Result:= False;
  slTrabajadoresErr.Clear;
  slTrabajadores.Clear;
  DMDestino.kmtOperarios.Close;
  DMDestino.kmtOperarios.Open;
  iOperarios:= 0;

  if LeerTrabajadores then
  begin
    Result:= True;
    i:= 0;
    while i < slTrabajadores.Count  do
    begin
      if TokensTrabajador( slTrabajadores[i] ) then
      begin
        if DMDestino.kmtOperarios.Locate('nif_o',sNifOperario,[]) then
        begin
          if TryStrToDate( sAlta, dFecha ) then
          begin
            if dFecha > DMDestino.kmtOperarios.FieldByName('fecha_alta_o').AsDateTime then
            begin
              DMDestino.kmtOperarios.Edit;
              DMDestino.kmtOperarios.FieldByName('fecha_alta_o').AsDateTime:= dFecha;
              if TryStrToDate( sBaja, dFecha ) then
                DMDestino.kmtOperarios.FieldByName('fecha_baja_o').AsDateTime:= dFecha
              else
                DMDestino.kmtOperarios.FieldByName('fecha_baja_o').Clear;
              DMDestino.kmtOperarios.FieldByName('cod_planta_o').AsString:= sCodPlanta;
              DMDestino.kmtOperarios.Post;
            end;
          end;
        end
        else
        begin
          DMDestino.kmtOperarios.Insert;
          DMDestino.kmtOperarios.FieldByName('nif_o').AsString:= sNifOperario;
          if TryStrToDate( sAlta, dFecha ) then
            DMDestino.kmtOperarios.FieldByName('fecha_alta_o').AsDateTime:= dFecha
          else
            DMDestino.kmtOperarios.FieldByName('fecha_alta_o').Clear;
          if TryStrToDate( sBaja, dFecha ) then
            DMDestino.kmtOperarios.FieldByName('fecha_baja_o').AsDateTime:= dFecha
          else
            DMDestino.kmtOperarios.FieldByName('fecha_baja_o').Clear;
          DMDestino.kmtOperarios.FieldByName('cod_planta_o').AsString:= sCodPlanta;

          DMDestino.kmtOperarios.Post;
          Inc( iOperarios );
        end;
      end
      else
      begin
        slTrabajadoresErr.Add( slTrabajadores[i] );
      end;
      Inc( i );
    end;
  end;
  if  slTrabajadoresErr.Count > 0 then
  begin
    //Guardar log de errores
  end;
end;


function TFMain.TokensTrabajador( const ALine: string ): boolean;
var
  sLine, sAux: string;
begin
  GetToken( ALine, sAux, sLine, '|' );  //Nif empresa, ignoramos
  GetToken( sLine, sAux, sLine, '|' );  //Nombre empresa, ignoramos
  GetToken( sLine, sNifOperario, sLine, '|' ); //Nif operario
  GetToken( sLine, sAux, sLine, '|' );  //Nombre operario, ignoramos
  GetToken( sLine, sCodPlanta, sLine, '|' ); //Cuenta de cotizacion = codigo planta
  sCodPlanta:= RellenaCeros( sCodPlanta, 11 );
  GetToken( sLine, sAlta, sLine, '|' );
  GetToken( sLine, sBaja, sLine, '|' );
  Result:= sNifOperario <> '';
end;

end.
