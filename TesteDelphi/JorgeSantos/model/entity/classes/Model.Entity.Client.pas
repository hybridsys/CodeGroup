unit Model.Entity.Client;

interface

uses
  Model.Entity.Interfaces, Data.DB, Model.Factory.Connection,
  FireDAC.Comp.Client;

type
  TEntityClient = class(TInterfacedObject, IEntity)
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
  end;
implementation

{ TEntityPerson }

constructor TEntityClient.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;
  FQuery := FFactoryConnection.Query;
  FQuery.Connection := FFactoryConnection.Connection;
end;

function TEntityClient.Dataset(aValue: TDatasource): IEntity;
begin
  Result := Self;
  aValue.DataSet := FQuery;
end;

function TEntityClient.Dataset(aValue: TDataset): IEntity;
begin
  Result := Self;
  aValue.Assign(FQuery);
end;

function TEntityClient.Delete(aObjeto: TObject): Boolean;
begin
end;

destructor TEntityClient.Destroy;
begin
  inherited;
end;

function TEntityClient.Get(aId: Integer): IEntity;
begin

end;

procedure TEntityClient.Insert(aObjeto: TObject);
begin

end;

class function TEntityClient.New: IEntity;
begin
  Result := Self.Create;
end;

procedure TEntityClient.Open;
begin
  try
    FQuery.Open('select * from clientes');
  finally

  end;
end;

procedure TEntityClient.Update(aObjeto: TObject);
begin

end;

end.
