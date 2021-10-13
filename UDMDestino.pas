unit UDMDestino;

interface

uses
  SysUtils, Classes, DB, DBTables, Dialogs, kbmMemTable;

type
  TDMDestino = class(TDataModule)
    dbDestino: TDatabase;
    dlgOpen: TOpenDialog;
    qryEmpresas: TQuery;
    qryOperarios: TQuery;
    kmtOperarios: TkbmMemTable;
    dsTrabajadores: TDataSource;
    dsEmpresas: TDataSource;
    tblOperarios: TQuery;
    qrySerial: TQuery;
    qryCodPlanta: TQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }

    function GetSerial: Integer;
    function GetCodigoEmpresa( const ACodPlanta: string ): string;

  public
    { Public declarations }
    sDescripcion, sBDName, sBDServer, sBDDriver, sUsuario, sClave: string;

    procedure ActualizarOperarios( var VAltas, VModificados: Integer );
    function  AbrirBaseDatos( const ARuta: string ): Boolean;
    procedure CerrarBaseDatos;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UUtils, Variants;


procedure TDMDestino.DataModuleCreate(Sender: TObject);
begin
  kmtOperarios.FieldDefs.Clear;
  kmtOperarios.FieldDefs.Add('nif_o', ftString, 10, False);
  kmtOperarios.FieldDefs.Add('fecha_alta_o', ftDate, 0, False);
  kmtOperarios.FieldDefs.Add('fecha_baja_o', ftDate, 0, False);
  kmtOperarios.FieldDefs.Add('cod_planta_o', ftString, 11, False);
  kmtOperarios.IndexFieldNames:= 'nif_o';
  kmtOperarios.CreateTable;
  kmtOperarios.Open;

  tblOperarios.SQL.Add(' select * from nof_operarios ');

  qryEmpresas.SQL.Clear;
  qryEmpresas.SQL.Add(' select empresa_e, nombre_e, cif_e, ''0'' || substr(cif_e,1,1) zona, substr(cif_e,2,4) regimen, substr(cif_e,6,5) codigo, serial_e from nof_empresas ');

  qryOperarios.SQL.Clear;
  qryOperarios.SQL.Add(' select empresa_o, nombre_e, zona_o, regimen_o, codigo_o, fecha_alta_o, fecha_baja_o, nif_o, n_seg_social_o, serial_o, ');
  qryOperarios.SQL.Add('        cast( Trim(nombre_ope_af) || '' '' || Trim(apellido1_ope_af) || '' '' || Trim(apellido2_ope_af) as char(50) ) nombre_o ');
  qryOperarios.SQL.Add(' from nof_operarios ');
  qryOperarios.SQL.Add('      join nof_alumno_fam on nif_ope_af = nif_o ');
  qryOperarios.SQL.Add('      join nof_empresas on empresa_o = empresa_e ');
  qryOperarios.SQL.Add(' where empresa_o = :empresa_e ');

  qrySerial.SQL.Clear;
  qrySerial.SQL.Add('select max(serial_o) serial_o from nof_operarios');

  qryCodPlanta.SQL.Clear;
  qryCodPlanta.SQL.Add('select empresa_e from nof_empresas where trim(cif_e) = :cod_planta ');

end;

function  TDMDestino.AbrirBaseDatos( const ARuta: string ): Boolean;
var
  IniFile: TIniFile;
begin
  //
  if not dbDestino.Connected then
  begin
    IniFile:= TIniFile.Create( ARuta + 'BDConfig.ini' );
    sDescripcion:= IniFile.ReadString('BDConfig','DESCRIPCION','');
    sBDName:= IniFile.ReadString('BDConfig','BDNAME','');
    sBDServer:= IniFile.ReadString('BDConfig','BDSEVER','');
    sBDDriver:= IniFile.ReadString('BDConfig','BDDRIVER','');
    sUsuario:= IniFile.ReadString('BDConfig','USUARIO','');
    sClave:= IniFile.ReadString('BDConfig','CLAVE','');
    FreeAndNil(IniFile);

    dbDestino.Params.Values['SERVER NAME']:= sBDServer;
    dbDestino.Params.Values['DATABASE NAME']:= sBDName;
    dbDestino.Params.Values['USER NAME']:= sUsuario;
    dbDestino.Params.Values['LANGDRIVER']:= sBDDriver;
    dbDestino.Params.Values['PASSWORD']:= sClave;

    dbDestino.Connected:= True;
  end;
  Result:= dbDestino.Connected;
end;

procedure TDMDestino.CerrarBaseDatos;
begin
  dbDestino.Connected:= False;
end;


function TDMDestino.GetSerial: Integer;
begin
  qrySerial.Open;
  Result:= qrySerial.FieldByName('serial_o').AsInteger;
  qrySerial.Close;
end;


function TDMDestino.GetCodigoEmpresa( const ACodPlanta: string ): string;
begin
  qryCodPlanta.ParamByName('cod_planta').AsString:= ACodPlanta;
  qryCodPlanta.Open;
  if not qryCodPlanta.IsEmpty then
    Result:= qryCodPlanta.FieldByName('empresa_e').AsString
  else
    Result:= '000';
  qryCodPlanta.Close;
end;


procedure TDMDestino.ActualizarOperarios( var VAltas, VModificados: Integer );
var
  iSerial: Integer;
  sCodEmpresa, sCodPlanta: string;
begin
  VAltas:= 0;
  VModificados:= 0;

  tblOperarios.Open;
  try
    iSerial:= GetSerial + 1;

    kmtOperarios.First;
    while not kmtOperarios.Eof do
    begin
      sCodPlanta:=kmtOperarios.fieldByName('cod_planta_o').AsString;
      sCodEmpresa:= GetCodigoEmpresa( sCodPlanta );
      if sCodEmpresa <> '' then
      begin
        if tblOperarios.Locate( 'nif_o', kmtOperarios.FieldByName('nif_o').AsString, [] ) then
        begin
          tblOperarios.Delete;
          VModificados:= VModificados + 1;
        end
        else
        begin
          VAltas:= VAltas + 1;
        end;

        tblOperarios.Insert;
        tblOperarios.FieldByName('empresa_o').AsString:= sCodEmpresa;
        tblOperarios.FieldByName('zona_o').AsString:= Copy( sCodPlanta, 1, 2 );
        tblOperarios.FieldByName('regimen_o').AsString:= Copy( sCodPlanta, 3, 4 );
        tblOperarios.FieldByName('codigo_o').AsString:= Copy( sCodPlanta, 7, 5 );
        tblOperarios.FieldByName('nif_o').AsString:= kmtOperarios.fieldByName('nif_o').AsString;
        tblOperarios.FieldByName('fecha_alta_o').AsDateTime:= kmtOperarios.fieldByName('fecha_alta_o').AsDateTime;
        if kmtOperarios.fieldByName('fecha_baja_o').Value <> null then
          tblOperarios.FieldByName('fecha_baja_o').AsDateTime:= kmtOperarios.fieldByName('fecha_baja_o').AsDateTime;
        tblOperarios.FieldByName('serial_o').AsInteger:= iSerial;
        tblOperarios.Post;
        iSerial:= iSerial + 1;
      end;

      kmtOperarios.Next;
    end;

  finally
    tblOperarios.Close;
  end;
end;

end.
