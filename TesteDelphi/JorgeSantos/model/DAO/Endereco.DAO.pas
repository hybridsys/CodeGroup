unit Endereco.DAO;

interface

uses
  Model.Entity.DAO.Interfaces, Data.DB, Model.Factory.Connection,
  FireDAC.Comp.Client, Model.Factory.Connection.Interfaces;
  type
    TEnderecoDAO = class(TInterfacedObject, IEntityDAO)
    private
      FFactoryConnection: IFactoryConnection;
    public
      function LoadData: TDataset;
      procedure Insert(aObjeto: TObject);
      procedure Update(aObjeto: TObject);
      function Delete(aId: Int64): Boolean;
      function Get(aId: Int64): TObject;
      constructor Create;
      destructor Destroy; override;
      function GetLast: Int64;

    end;

implementation

uses
  Model.Endereco, System.SysUtils;

{ TEnderecoDAO }

constructor TEnderecoDAO.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;

end;

function TEnderecoDAO.Delete(aId: Int64): Boolean;
var
  Query: TFDQuery;
  lDeleted: Boolean;
begin
  Query := FFactoryConnection.Query;

  try
    Query.SQL.Add('DELETE FROM Endereco E');
    Query.SQL.Add(' WHERE E.idEndereco = :idEndereco');
    Query.ParamByName('idEndereco').AsLargeInt := aId;
    Query.ExecSQL;
    lDeleted := True;
  finally
     Result := lDeleted;
     Query.Free;

  end;
end;

destructor TEnderecoDAO.Destroy;
begin
  inherited;
end;

function TEnderecoDAO.Get(aId: Int64): TObject;
var
  Query: TFDQuery;
  E: TEndereco;
begin
  Query := FFactoryConnection.Query;
  E := TEndereco.Create;
  try
    Query.SQL.Add('SELECT E.IDEndereco,');
    Query.SQL.Add('       E.dscep,');
    Query.SQL.Add('       E.idpessoa,');
    Query.SQL.Add('       EI.dscomplemento,');
    Query.SQL.Add('       EI.dsuf,');
    Query.SQL.Add('       EI.nmbairro,');
    Query.SQL.Add('	      EI.nmcidade,');
    Query.SQL.Add('       EI.nmlogradouro');
    Query.SQL.Add('  FROM Endereco E,');
    Query.SQL.Add('       Endereco_Integracao EI');
    Query.SQL.Add('  WHERE E.idendereco = EI.idendereco');
    Query.SQL.Add('    AND E.idpessoa = :idpessoa');
    Query.ParamByName('idpessoa').AsLargeInt := aId;
    Query.Open;
    E.idEndereco := Query.FieldByName('idEndereco').AsLargeInt;
    E.dsCEP := Query.FieldByName('dsCEP').AsString;
    E.IdPessoa := Query.FieldByName('idPessoa').AsLargeInt;
    E.dsUF := Query.FieldByName('dsUF').AsString;
    E.nmCidade := Query.FieldByName('nmCidade').AsString;
    E.nmBairro := Query.FieldByName('nmBairro').AsString;
    E.nmLogradouro := Query.FieldByName('nmLogradouro').AsString;
    E.dsComplemento := Query.FieldByName('dsComplemento').AsString;
    Result := E;
  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.GetLast: Int64;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('SELECT MAX(idEndereco) LastId FROM Endereco');
    Query.Open;
    Result := Query.FieldByName('LastId').AsLargeInt;
  finally
    Query.Free;
  end;
end;

procedure TEnderecoDAO.Insert(aObjeto: TObject);
var
  Query: TFDQuery;
  idEndereco: Int64;
begin
  Query := FFactoryConnection.Query;
  try
    idEndereco := GetLast +1;
    Query.SQL.Add('INSERT INTO Endereco(idEndereco, idPessoa, dsCEP) ');
    Query.SQL.Add('VALUES(:idEndereco, :idPessoa, :dsCEP)');
    Query.ParamByName('idEndereco').AsLargeInt := idEndereco;
    Query.ParamByName('idPessoa').AsLargeInt := TEndereco(aObjeto).IdPessoa;
    Query.ParamByName('dsCEP').AsString := TEndereco(aObjeto).dsCEP;
    Query.ExecSQL;

    Query.SQL.Clear;
    Query.SQL.Add('INSERT INTO Endereco_Integracao');
    Query.SQL.Add('(idEndereco, dsUf, nmCidade, nmBairro, nmlogradouro, dsComplemento) ');
    Query.SQL.Add('VALUES(:idEndereco, :dsUf, :nmCidade, :nmBairro, :nmlogradouro, :dsComplemento)');
    Query.ParamByName('idEndereco').AsLargeInt := idEndereco;
    Query.ParamByName('dsUf').AsString := TEndereco(aObjeto).dsUF;
    Query.ParamByName('nmCidade').AsString := TEndereco(aObjeto).nmCidade;
    Query.ParamByName('nmBairro').AsString := TEndereco(aObjeto).nmBairro;
    Query.ParamByName('nmLogradouro').AsString := TEndereco(aObjeto).nmLogradouro;
    Query.ParamByName('dsComplemento').AsString := TEndereco(aObjeto).dsComplemento;
    Query.ExecSQL;

  finally
    Query.Free;
  end;
end;

function TEnderecoDAO.LoadData: TDataset;
begin
//
end;

procedure TEnderecoDAO.Update(aObjeto: TObject);
var
  Query: TFDQuery;
  idEndereco: Int64;
  Endereco: TObject;
begin
  Query := FFactoryConnection.Query;
  try
    idEndereco := GetLast +1;
    Query.SQL.Add('UPDATE Endereco SET dsCEP = :dsCEP ');
    Query.SQL.Add(' WHERE idPessoa = :idPessoa');
    Query.ParamByName('idPessoa').AsLargeInt := TEndereco(aObjeto).IdPessoa;
    Query.ParamByName('dsCEP').AsString := TEndereco(aObjeto).dsCEP;
    Query.ExecSQL;

    Endereco := Get(TEndereco(aObjeto).IdPessoa);

    Query.SQL.Clear;
    Query.SQL.Add('UPDATE Endereco_Integracao SET ');
    Query.SQL.Add('  dsUf = :dsUf, nmCidade = :nmCidade, ');
    Query.SQL.Add('nmBairro = :nmBairro, nmlogradouro = :nmlogradouro, dsComplemento = :dsComplemento ');
    Query.SQL.Add(' WHERE idEndereco = :idEndereco');
    Query.ParamByName('idEndereco').AsLargeInt := TEndereco(Endereco).IdEndereco;
    Query.ParamByName('dsUf').AsString := TEndereco(aObjeto).dsUF;
    Query.ParamByName('nmCidade').AsString := TEndereco(aObjeto).nmCidade;
    Query.ParamByName('nmBairro').AsString := TEndereco(aObjeto).nmBairro;
    Query.ParamByName('nmLogradouro').AsString := TEndereco(aObjeto).nmLogradouro;
    Query.ParamByName('dsComplemento').AsString := TEndereco(aObjeto).dsComplemento;
    Query.ExecSQL;

  finally
    Query.Free;
  end;

end;

end.
