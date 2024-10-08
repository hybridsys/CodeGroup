unit Model.Entity.Product;

interface

uses
  Model.Entity.Interfaces, Data.DB, Model.Factory.Connection,
  FireDAC.Comp.Client;

type
  TEntityProduct = class(TInterfacedObject, IEntity)
  private
    FQuery: TFDQuery;
    FFactoryConnection: TFactoryConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IEntity;
    function Dataset(aValue: TDatasource): IEntity; overload;
    function Dataset(aValue: TDataset): IEntity; overload;
    procedure Open;
    procedure Insert(aObjeto: TObject);
    procedure Update(aObjeto: TObject);
    function Delete(aObjeto: TObject): Boolean;
    function Get(aId: Integer): IEntity;
    function GetProductValue(Id: Integer): Real;
  end;
implementation

{ TEntityPerson }

constructor TEntityProduct.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;
  FQuery := FFactoryConnection.Query;
  FQuery.Connection := FFactoryConnection.Connection;
end;

function TEntityProduct.Dataset(aValue: TDatasource): IEntity;
begin
  Result := Self;
  aValue.DataSet := FQuery;
end;

function TEntityProduct.Dataset(aValue: TDataset): IEntity;
begin
  Result := Self;
  aValue.Assign(FQuery);
end;

function TEntityProduct.Delete(aObjeto: TObject): Boolean;
begin
end;

destructor TEntityProduct.Destroy;
begin
  inherited;
end;

function TEntityProduct.Get(aId: Integer): IEntity;
begin

end;

function TEntityProduct.GetProductValue(Id: Integer): Real;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('SELECT precovenda ');
    Query.SQL.Add('  FROM produtos ');
    Query.SQL.Add(' WHERE id = :id');
    Query.ParamByName('id').AsInteger := Id;
    Query.Open;
    Result := Query.FieldByName('precovenda').AsFloat;
  finally
    Query.Free;
  end;

end;

procedure TEntityProduct.Insert(aObjeto: TObject);
begin

end;

class function TEntityProduct.New: IEntity;
begin
  Result := Self.Create;
end;

procedure TEntityProduct.Open;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select * from produtos');
  FQuery.Open;
end;

procedure TEntityProduct.Update(aObjeto: TObject);
begin

end;

end.

