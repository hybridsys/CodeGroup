unit Model.Entity.OrderProduct;

interface

uses
  Data.DB, Model.Factory.Connection, FireDAC.Comp.Client, Model.Entity.Interfaces;

type
  TEntityOrderProduct = class(TInterfacedObject, IEntity)
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
    procedure GetProductOrder(idOrder: Integer);
    procedure Insert(aObjeto: TObject);
    procedure Update(aObjeto: TObject);
    function Delete(aObjeto: TObject): Boolean;
    function Get(aId: Integer): IEntity;
    function GetTotalOrder(id: Integer): Real;
  end;
implementation

uses
  Model.OrderProduct;

{ TEntityPerson }

constructor TEntityOrderProduct.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;
  FQuery := FFactoryConnection.Query;
  FQuery.Connection := FFactoryConnection.Connection;
end;

function TEntityOrderProduct.Dataset(aValue: TDatasource): IEntity;
begin
  Result := Self;
  aValue.DataSet := FQuery;
end;

function TEntityOrderProduct.Dataset(aValue: TDataset): IEntity;
begin
  Result := Self;
  aValue.Assign(FQuery);
end;

function TEntityOrderProduct.Delete(aObjeto: TObject): Boolean;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('DELETE FROM produtospedido');
    Query.SQL.Add(' WHERE idpedido = :idpedido AND idproduto = :idproduto');
    Query.ParamByName('idpedido').AsInteger := TOrderProduct(aObjeto).IDOrder;
    Query.ParamByName('idproduto').AsInteger := TOrderProduct(aObjeto).IdProduct;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

destructor TEntityOrderProduct.Destroy;
begin
  inherited;
end;

function TEntityOrderProduct.Get(aId: Integer): IEntity;
begin

end;

procedure TEntityOrderProduct.Insert(aObjeto: TObject);
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;

  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('INSERT INTO produtospedido');
    Query.SQL.Add('(idpedido, idproduto, qtdproduto, valorunitario, valortotal) ');
    Query.SQL.Add('values (:idpedido, :idproduto, :qtdproduto, :valorunitario, :valortotal)');
    Query.ParamByName('idpedido').AsInteger := TOrderProduct(aObjeto).IDOrder;
    Query.ParamByName('idproduto').AsInteger := TOrderProduct(aObjeto).IdProduct;
    Query.ParamByName('qtdproduto').AsInteger := TOrderProduct(aObjeto).Amount;
    Query.ParamByName('valorunitario').asFloat := TOrderProduct(aObjeto).UnitValue;
    Query.ParamByName('valortotal').AsFloat := TOrderProduct(aObjeto).TotalValue;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

class function TEntityOrderProduct.New: IEntity;
begin
  Result := Self.Create;
end;

procedure TEntityOrderProduct.Open;
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('select * from produtospedido');
  FQuery.Open;
end;

procedure TEntityOrderProduct.GetProductOrder(idOrder: Integer);
begin
  FQuery.SQL.Clear;
  FQuery.SQL.Add('SELECT pp.*, p.descricao ');
  FQuery.SQL.Add('  FROM produtospedido pp, ');
  FQuery.SQL.Add('       produtos p ');
  FQuery.SQL.Add(' WHERE pp.idproduto = p.id ');
  FQuery.SQL.Add('   AND pp.idpedido = :id' );
  FQuery.ParamByName('id').AsInteger := idOrder;
  FQuery.Open;

end;

function TEntityOrderProduct.GetTotalOrder(id: Integer): Real;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Clear;
    Query.SQL.Add('SELECT SUM(valortotal) Total ');
    Query.SQL.Add('  FROM produtospedido pp ');
    Query.SQL.Add(' WHERE pp.idpedido = :id' );
    Query.ParamByName('id').AsInteger := id;
    Query.Open;
    Result := Query.FieldByName('Total').AsFloat;
  finally
    Query.Close;
  end;

end;

procedure TEntityOrderProduct.Update(aObjeto: TObject);
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.Connection := FFactoryConnection.Connection;
    Query.SQL.Add('UPDATE produtospedido SET qtdproduto = :qtdproduto, valorunitario = :valorunitario, valortotal = :valortotal ');
    Query.SQL.Add(' WHERE id = :id');
    Query.ParamByName('id').AsInteger := TOrderProduct(aObjeto).Id;
    Query.ParamByName('qtdproduto').AsInteger:= TOrderProduct(aObjeto).Amount;
    Query.ParamByName('valorunitario').AsFloat := TOrderProduct(aObjeto).UnitValue;
    Query.ParamByName('valortotal').AsFloat    := TOrderProduct(aObjeto).TotalValue;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
