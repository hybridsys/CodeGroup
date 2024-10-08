unit Controller.Pessoa;

interface

uses
  Controller.Pessoa.Interfaces, Model.Pessoa, System.Classes,
  System.Generics.Collections, Pessoa.DAO, Endereco.DAO, Model.Endereco,
  Model.Entity.DAO.Interfaces;

type
  TPessoaController = class(TInterfacedObject, IPessoaController)
  private
    FPessoaDAO: IEntityDAO;
    FEnderecoDAO: IEntityDAO;
    FPessoaList: TObjectList<TPessoa>;
  public
    procedure AddPessoa(aPessoa: TPessoa);
    procedure AddEndereco(aEndereco: TEndereco);
    procedure UpdatePessoa(aPessoa: TPessoa);
    procedure UpdateEndereco(aEndereco: TEndereco);
    procedure DeletePessoa(aId: Int64);
    procedure DeleteEndereco(aId: Int64);
    function GetById(aId: Int64): TPessoa;
    function GetEnderecoById(aId: Int64): TEndereco;
    function GetAll: TObjectList<TPessoa>;
    function GetLastPessoa: Int64;
    function GetLastEndereco: Int64;
    constructor Create;
    destructor destroy; override;
  end;

implementation

uses
  Data.DB, System.SysUtils;

{ TPessoaController }

procedure TPessoaController.AddEndereco(aEndereco: TEndereco);
begin
  FEnderecoDAO.Insert(aEndereco);
end;

procedure TPessoaController.AddPessoa(aPessoa: TPessoa);
begin
  FPessoaDAO.Insert(aPessoa);

end;

constructor TPessoaController.Create;
begin
  FPessoaDAO := TPessoaDAO.Create;
  FEnderecoDAO := TEnderecoDAO.Create;
  FPessoaList := TObjectList<TPessoa>.Create;
end;

procedure TPessoaController.DeleteEndereco(aId: Int64);
begin

end;

procedure TPessoaController.DeletePessoa(aId: Int64);
begin
  FPessoaDAO.Delete(aId);
end;

destructor TPessoaController.destroy;
var
  I: Integer;
begin
  FreeAndNil(FPessoaList);
  inherited;
end;

function TPessoaController.GetAll: TObjectList<TPessoa>;
var
  ds: TDataset;
  I: Integer;
  PessoaList: TObjectList<TPessoa>;
begin
  ds := FPessoaDAO.LoadData;
  I := 0;
  try
    PessoaList := TObjectList<TPessoa>.Create;
    while not ds.Eof do
    begin
      PessoaList.Add(TPessoa.Create);
      PessoaList[I].IdPessoa := ds.FieldByName('idpessoa').AsLargeInt;
      PessoaList[I].flNatureza := ds.FieldByName('flNatureza').AsInteger;
      PessoaList[I].DsDocumento := ds.FieldByName('dsDocumento').AsString;
      PessoaList[I].NmPrimeiro := ds.FieldByName('nmPrimeiro').AsString;
      PessoaList[I].NmSegundo := ds.FieldByName('nmSegundo').AsString;
      PessoaList[I].DtRegistro := ds.FieldByName('dtRegistro').AsDateTime;
      ds.Next;
      Inc(I);
    end;
    Result := PessoaList;
  finally
    ds.Free;
  end;
end;

function TPessoaController.GetById(aId: Int64): TPessoa;
begin
  Result := TPessoa(FPessoaDAO.Get(aId));
end;

function TPessoaController.GetEnderecoById(aId: Int64): TEndereco;
begin
  Result := TEndereco(FEnderecoDAO.Get(aId));
end;

function TPessoaController.GetLastEndereco: Int64;
begin
  Result := FEnderecoDAO.GetLast;
end;

function TPessoaController.GetLastPessoa: Int64;
begin
  Result := FPessoaDAO.GetLast;
end;

procedure TPessoaController.UpdateEndereco(aEndereco: TEndereco);
begin
  FEnderecoDAO.Update(aEndereco);
end;

procedure TPessoaController.UpdatePessoa(aPessoa: TPessoa);
begin
  FPessoaDAO.Update(aPessoa);
end;

end.
