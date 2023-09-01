unit CocoFoneService;

interface

uses
  XData.Server.Module,
  XData.Service.Common,
  System.Classes;

type
  [ServiceContract]
  ICocoFoneService = interface(IInvokable)
    ['{ACC6A738-FC59-4FE6-B079-76393822D4DA}']
    [HttpGet] function LoadFarm(Value: string): String;
    [HttpGet] function LoadDrops(Value: string): String;
  end;

  [ServiceImplementation]
  TCocoFoneService = class(TInterfacedObject, ICocoFoneService)
    function LoadFarm(Value: string): String;
    function LoadDrops(Value: string): String;
  end;

implementation
uses
  xdmCocoFone;


function TCocoFoneService.LoadFarm(Value: string): String;
begin
  Result := dmCocoFone.LoadFarm(Value);
end;

function TCocoFoneService.LoadDrops(Value: string): string;
begin
  Result := dmCocoFone.LoadDrops(Value);
end;

initialization
  RegisterServiceType(TypeInfo(ICocoFoneService));
  RegisterServiceType(TCocoFoneService);

end.
