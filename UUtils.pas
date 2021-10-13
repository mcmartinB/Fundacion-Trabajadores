unit UUtils;

interface

function  RellenaCeros( const ALinea: string; const ALen: integer ): string;
procedure GetToken( const ALinea: string; var VToken, VResto: string;
                   const ASep: string = ','; const AComillas: string = '"' );

function GetSQL( var VScript, VSQL: string ): boolean;



implementation

uses
  SysUtils;

function  RellenaCeros( const ALinea: string; const ALen: integer ): string;
var
  iLen: Integer;
begin
  result:= Trim(ALinea);
  iLen:= Length( result );
  while iLen < ALen do
  begin
    result:= '0' + result;
    inc( iLen );
  end;
end;


procedure GetToken( const ALinea: string; var VToken, VResto: string;
                   const ASep: string = ','; const AComillas: string = '"' );
var
  iPos: integer;
begin
  VResto:= Trim( ALinea );

  if VResto <> '' then
  begin
    if Copy( VResto, 1, 1 ) = AComillas then
    begin
      VResto:= Copy( VResto, 2, length( VResto ) - 1 );
      iPos:= Pos( AComillas, VResto );
      if iPos > 0 then
      begin
        //entre comillas
        VToken:= Copy( VResto, 1, iPos -1 );
        VResto:= Copy( VResto, iPos + 2, length( VResto ) - ( iPos + 1 ) );
      end
      else
      begin
        //empieza por comillas
        iPos:= Pos( ASep, VResto );
        if iPos > 0 then
        begin
          VToken:= AComillas + Copy( VResto, 1, iPos -1 );
          VResto:= Copy( VResto, iPos + 1, length( VResto ) - iPos );
        end
        else
        begin
          //empieza por comillas
          VToken:= AComillas + VResto;
          VResto:= '';
        end;
      end;
    end
    else
    begin
      //entre separador
      iPos:= Pos( ASep, VResto );
      if iPos > 0 then
      begin
        VToken:= Copy( VResto, 1, iPos -1 );
        VResto:= Copy( VResto, iPos + 1, length( VResto ) - iPos );
      end
      else
      begin
        //empieza por comillas
        VToken:= VResto;
        VResto:= '';
      end;
    end;
  end
  else
  begin
    VToken:= '';
  end;
end;

function GetSQL( var VScript, VSQL: string ): boolean;
var
  sAux: string;
begin
  Result:= Trim(VScript) <> '';
  if result then
  begin
    GetToken( VScript, VSQL, sAux, ';' );
    VScript:= Trim( sAux );
  end;
end;

end.
