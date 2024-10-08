unit Controller.Pessoa.Interfaces;

interface

uses
  Model.Pessoa, System.Generics.Collections, Model.Endereco;
type
  IPessoaController = interface
    ['{A896AFFC-9073-4A84-9FFC-38E6A0DA38D5}']
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
  end;
implementation

end.
