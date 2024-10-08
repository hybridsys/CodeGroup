unit Model.Entity.Order;

interface

uses
  Data.DB, Model.Factory.Connection, FireDAC.Comp.Client, Model.Entity.Interfaces;

type
  TEntityOrder = class(TInterfacedObject, IEntity)
  private
    FQuery: TFDQuery;
    FFactoryConnection: TFactoryConnection;
    FLastID: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IEntity;
    function Dataset(aValue: TDatasource): IEntity; overload;
    function Dataset(aValue: TDataset): IEntity; overload;
    procedure Open;
    procedure GetOrders;
    procedure Insert(aObjeto: TObject);
    procedure Update(aObjeto: TObject);
    function Delete(aObjeto: TObject): Boolean;
    function Get(aId: Integer): IEntity;
    function LastID: Integer;
  end;
implementation

uses
  Model.Order;

{ TEntityPerson }

constructor TEntityOrder.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;
  FQuery := FFactoryConnection.Query;
  FQuery.Connection := FFactoryConnection.Connection;
end;

function TEntityOrder.Dataset(aValue: TDatasource): IEntity;
begin
  Result := Self;
  aValue.DataSet := FQuery;
end;

function TEntityOrder.Dataset(aValue: TDataset): IEntity;
begin
  Result := Self;
  aValue.Assign(FQuery);
end;

function TEntityOrder.Delete(aObjeto: TObject): Boolean;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('DELETE FROM dadospedido ');
    Query.SQL.Add(' WHERE id = :id');
    Query.ParamByName('id').AsInteger := TOrder(aObjeto).ID;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

destructor TEntityOrder.Destroy;
begin
  inherited;
end;

function TEntityOrder.Get(aId: Integer): IEntity;
begin

end;

procedure TEntityOrder.Insert(aObjeto: TObject);
var
  Query: TFDQuery;
begin
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('insert into dadospedido');
    Query.SQL.Add('(idcliente, dataemissao, valortotal) ');
    Query.SQL.Add('values (:idcliente, :dataemissao, :valortotal)');
    Query.ParamByName('idcliente').AsInteger := TOrder(aObjeto).IdCliente;
    Query.ParamByName('dataemissao').AsDateTime := TOrder(aObjeto).DataEmissao;
    Query.ParamByName('valortotal').AsFloat := TOrder(aObjeto).ValorTotal;
    Query.ExecSQL;
    Query.SQL.Clear;
    Query.SQL.Add('select last_insert_id() as lastid');
    Query.Open;
    FLastID := Query.FieldByName('lastid').AsInteger;
  finally
    Query.Free;
  end;
end;

function TEntityOrder.LastID: Integer;
begin
  Result := FLastId;
end;

class function TEntityOrder.New: IEntity;
begin
  Result := Self.Create;
end;

procedure TEntityOrder.Open;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select * from dadospedido');
  FQuery.Open;
end;

procedure TEntityOrder.GetOrders;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select dp.*, cl.nome from dadospedido dp, clientes cl where cl.id = dp.idcliente');
  FQuery.Open;
end;

procedure TEntityOrder.Update(aObjeto: TObject);
begin

end;

end.

