unit xdmCocoFone;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.IBBase, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Comp.BatchMove.JSON,
  FireDAC.Comp.BatchMove, FireDAC.Comp.BatchMove.DataSet;

type
  TdmCocoFone = class(TDataModule)
    con1: TFDConnection;
    FDTransaction1: TFDTransaction;
    Q1: TFDQuery;
    FBDriver1: TFDPhysFBDriverLink;
    BatchMove1: TFDBatchMove;
    BatchReader1: TFDBatchMoveDataSetReader;
    BatchWriter1: TFDBatchMoveJSONWriter;
  private
    { Private declarations }
  public
    //procedure LoadFarm(const AValue: string; aStream: TStringStream);
    function LoadFarm(const AValue: string): String;
    //procedure LoadDrops(const AValue: string; aStream: TStream);
    function LoadDrops(const AValue: string): String;
  end;

var
  dmCocoFone: TdmCocoFone;

implementation
uses
  System.JSON;
{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmCocoFone }

const
  sqlDrops = 'select * from drops_by_farmer (%s)';
  sqlFarm = 'select * from farmer_by_code (%s)';

(*****************************************************************************
*  Load data from the farm source using the supplied parameter.              *
*  Just save the query to stream to include the field defs/metadata. This is *
*  the DataSnap approach and why it does not work for open APIs.             *
*  Use the BatchMove to get only the data as json. The BatchMove execute     *
*  will open the query, which can be set to auto close, so those actions are *
*  not specifically required in the code. BatchMove runs, but fails with a   *
*  stream error for me, as does using the manual code with streams. (Rio)    *
*  Copied code from WebBroker demo project to do it long-hand.               *
*****************************************************************************)
//procedure TdmCocoFone.LoadFarm(const AValue: string; aStream: TStringStream);
function TdmCocoFone.LoadFarm(const AValue: string): String;
var
  ix1: integer;
  obj: TJSONObject;
begin
  Result := '';
  if AValue = '' then
    Exit;
  if Q1.Active then
    Q1.Close;

  Q1.SQL.Clear;
  Q1.SQL.Add(Format(sqlFarm, [QuotedStr(AValue)]));
  Q1.Open;
  try
    // save query to json including all of the field defs - use for memtable/TDataSet  on client
    //Q1.SaveToStream(aStream, sfJSON);     // requires FDStanStorageJSONLink
    // uses 3 batch move components
    //BatchWriter1.Stream := aStream;
    //BatchMove1.Execute;

    // manual code
    if Q1.RecordCount > 0 then
    begin
      if Q1.FieldDefs.Count > 0 then
      begin
        obj := TJSONObject.Create;
        // load data - only one record so no need to map fields
        for ix1 := 0 to Q1.FieldDefs.Count - 1 do
          obj.AddPair(IntToStr(ix1 + 1), Q1.Fields[ix1].AsString);

        Result := obj.ToString;
      end;  // if fields > 0
    end;  // if count > 0
  finally
    Q1.Close;
  end;
end;

(*****************************************************************************
*  Load data from the drops/supply source using the supplied parameter.      *
*  See above for comments.                                                   *
*****************************************************************************)
//procedure TdmCocoFone.LoadDrops(const AValue: string; aStream: TStream);
function TdmCocoFone.LoadDrops(const AValue: string): String;
var
  ix1: integer;
  ix2: integer;
  ary: TJSONArray;
  obj: TJSONObject;
begin
  if AValue = '' then
    Exit;
  //if aStream = nil then
  //  Exit;

  if Q1.Active then
    Q1.Close;

  Q1.SQL.Clear;
  Q1.SQL.Add(Format(sqlDrops, [QuotedStr(AValue)]));
  Q1.Open;
  try
    // save query to json including all of the field defs - use for memtable/TDataSet  on client
    //Q1.SaveToStream(aStream, sfJSON);     // requires FDStanStorageJSONLink
    //BatchWriter1.Stream := aStream;
    //BatchMove1.Execute;

    // manual code
    if Q1.RecordCount > 0 then
    begin
      if Q1.FieldDefs.Count > 0 then
      begin
        ary := TJSONArray.Create;
        for ix2 := 0 to Q1.RecordCount - 1 do
        begin
          obj := TJSONObject.Create;
          // load record into json object - does not handle date format issue
          for ix1 := 0 to Q1.FieldDefs.Count - 1 do
            obj.AddPair(IntToStr(ix1 + 1), Q1.Fields[ix1].AsString);

          ary.AddElement(obj);
          Q1.Next;
        end;  // for ix1

        Result := ary.ToString;
      end;  // if fields > 0
    end;  // if count > 0
  finally
    Q1.Close;
  end;
end;

end.
