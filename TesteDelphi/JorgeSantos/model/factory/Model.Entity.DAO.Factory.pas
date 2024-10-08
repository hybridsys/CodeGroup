unit Model.Entity.DAO.Factory;

interface

uses
  Model.Entity.DAO.Interfaces, Model.Entity.DAO.Factory.Interfaces;

type
  TEntityDAOFactory = class(TInterfacedObject, IEntityDAOFactory)
  public
    function PessoaDAO: IEntityDAO;
    function EnderecoDAO: IEntityDAO;

  end;

implementation

{ TEntityDAOFactory }

function TEntityDAOFactory.EnderecoDAO: IEntityDAO;
begin

end;

function TEntityDAOFactory.PessoaDAO: IEntityDAO;
begin

end;

end.
