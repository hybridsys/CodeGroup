unit Pessoa.DAO;

interface

uses
  Model.Entity.DAO.Interfaces, Data.DB, FireDAC.Comp.Client, Model.Factory.Connection,
  Model.Pessoa, Model.Factory.Connection.Interfaces;
  type
    TPessoaDAO = class(TInterfacedObject, IEntityDAO)
    private
      FQuery: TFDQuery;
      FFactoryConnection: IFactoryConnection;
      FLastID: Integer;
      FlLote: Boolean;
      FIdPessoaLote: Int64;
    public
      function LoadData: TDataset;
      procedure Insert(aObjeto: TObject);
      procedure Update(aObjeto: TObject);
      function Delete(aId: Int64): Boolean;
      function Get(aId: Int64): TObject;
      function GetLast: Int64;
      constructor Create;
      destructor Destroy; override;
    end;
implementation

uses
  System.SysUtils;

{ PessoaDAO }

constructor TPessoaDAO.Create;
begin
  FFactoryConnection := TFactoryConnection.Create;
  FQuery := FFactoryConnection.Query;
end;

function TPessoaDAO.Delete(aId: Int64): Boolean;
var
  lResultado: Boolean;
  Query: TFDQuery;
begin
  lResultado := False;
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('DELETE FROM pessoa p');
    Query.SQL.Add('WHERE p.idpessoa = :IDPESSOA');
    Query.ParamByName('IDPESSOA').AsLargeInt := aId;
    Query.ExecSQL;
    lResultado := True;
  finally
    Query.Free;
    Result := lResultado;
  end;
end;

destructor TPessoaDAO.Destroy;
begin
  inherited;
end;

function TPessoaDAO.Get(aId: Int64): TObject;
var
  lResultado: Boolean;
  FPessoa: TPessoa;
  Query: TFDQuery;
begin
  FPessoa := TPessoa.Create;
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('SELECT * FROM pessoa p ');
    Query.SQL.Add('WHERE p.idpessoa = :IDPESSOA');
    Query.ParamByName('IDPESSOA').AsLargeInt := aId;
    Query.Open;
    FPessoa.IdPessoa := Query.FieldByName('IdPessoa').AsLargeInt;
    FPessoa.FlNatureza := Query.FieldByName('IdPessoa').AsInteger;
    FPessoa.dsDocumento := Query.FieldByName('dsDocumento').AsString;
    FPessoa.nmPrimeiro := Query.FieldByName('nmPrimeiro').AsString;
    FPessoa.nmSegundo := Query.FieldByName('nmSegundo').AsString;
    FPessoa.dtRegistro := Query.FieldByName('dtRegistro').AsDateTime;
    Result := FPessoa;
  finally
    Query.Free;
    FPessoa.Free
  end;
end;

procedure TPessoaDAO.Insert(aObjeto: TObject);
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('INSERT INTO pessoa');
    Query.SQL.Add('(idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro)');
    Query.SQL.Add('VALUES (:idpessoa, :flnatureza, :dsdocumento, :nmprimeiro, :nmsegundo, :dtregistro)');
    if not FlLote then
      Query.ParamByName('idpessoa').AsLargeInt := GetLast + 1
    else
    begin
      FIdPessoaLote := FIdPessoaLote + 1;
      Query.ParamByName('idPessoa').AsLargeInt := FIdPessoaLote;
    end;
    Query.ParamByName('FlNatureza').AsInteger := TPessoa(aObjeto).FlNatureza;
    Query.ParamByName('dsDocumento').AsString := TPessoa(aObjeto).dsDocumento;
    Query.ParamByName('nmprimeiro').AsString := TPessoa(aObjeto).NmPrimeiro;
    Query.ParamByName('nmSegundo').AsString := TPessoa(aObjeto).NmSegundo;
    Query.ParamByName('dtRegistro').AsDateTime := TPessoa(aObjeto).DtRegistro;
    Query.ExecSQL;
  finally
    Query.Free;
  end;

end;

function TPessoaDAO.GetLast: Int64;
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('SELECT MAX(idPessoa) LastId FROM Pessoa');
    Query.Open;
    Result := Query.FieldByName('LastId').AsLargeInt;
  finally
    Query.Free;
  end;
end;

function TPessoaDAO.LoadData: TDataset;
var
  Query: TFDQuery;
begin

  Query := FFactoryConnection.Query;
  try
    Query.SQL.Add('SELECT * FROM pessoa');
    Query.Open;
    Result := Query;
  finally

  end;
end;

procedure TPessoaDAO.Update(aObjeto: TObject);
var
  Query: TFDQuery;
begin
  Query := FFactoryConnection.Query;
  try
    Query.SQL.Clear;
    Query.SQL.Add('UPDATE Pessoa SET ');
    Query.SQL.Add('flnatureza = :flnatureza, dsdocumento = :dsdocumento, ');
    Query.SQL.Add('nmprimeiro = :nmprimeiro, nmsegundo = :nmsegundo, dtregistro = :dtregistro');
    Query.SQL.Add('WHERE idPessoa = :idPessoa');
    Query.ParamByName('idPessoa').AsLargeInt := TPessoa(aObjeto).IdPessoa;
    Query.ParamByName('FlNatureza').AsInteger := TPessoa(aObjeto).FlNatureza;
    Query.ParamByName('dsDocumento').AsString := TPessoa(aObjeto).dsDocumento;
    Query.ParamByName('nmprimeiro').AsString := TPessoa(aObjeto).NmPrimeiro;
    Query.ParamByName('nmSegundo').AsString := TPessoa(aObjeto).NmSegundo;
    Query.ParamByName('dtRegistro').AsDateTime := TPessoa(aObjeto).DtRegistro;
    Query.ExecSQL;
  finally
    Query.Free;
  end;
end;

end.
