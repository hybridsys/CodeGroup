unit Model.Endereco;

interface
type
  TEndereco = class
  private
    FidEndereco: Int64;
    FIdPessoa: Int64;
    FdsCEP: String;
    FdsUF: String;
    FnmCidade: String;
    FnmBairro: String;
    FnmLogradouro: String;
    FdsComplemento: String;
  public
    property idEndereco: Int64 read FidEndereco write FidEndereco;
    property IdPessoa: Int64 read FIdPessoa write FIdPessoa;
    property dsCEP: String read FdsCEP write FdsCEP;
    property dsUF: String read FdsUF write FdsUF;
    property nmCidade: String read FnmCidade write FnmCidade;
    property nmBairro: String read FnmBairro write FnmBairro;
    property nmLogradouro: String read FnmLogradouro write FnmLogradouro;
    property dsComplemento: String read FdsComplemento write FdsComplemento;
  end;
implementation

end.
