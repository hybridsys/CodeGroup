unit Model.Entity.DAO.Factory.Interfaces;

interface

uses
  Model.Entity.DAO.Interfaces;

type
  IEntityDAOFactory = interface
    function PessoaDAO: IEntityDAO;
    function EnderecoDAO: IEntityDAO;
  end;
implementation

end.
