program TesteJorgeSantos;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  Model.Entity.DAO.Factory.Interfaces in 'model\interfaces\Model.Entity.DAO.Factory.Interfaces.pas',
  Model.Entity.DAO.Interfaces in 'model\interfaces\Model.Entity.DAO.Interfaces.pas',
  Model.Factory.Connection.Interfaces in 'model\interfaces\Model.Factory.Connection.Interfaces.pas',
  Model.Factory.Connection in 'model\factory\Model.Factory.Connection.pas',
  Model.Pessoa in 'model\classes\Model.Pessoa.pas',
  Model.Entity.DAO.Factory in 'model\factory\Model.Entity.DAO.Factory.pas',
  Pessoa.DAO in 'model\DAO\Pessoa.DAO.pas',
  Controller.Pessoa.Interfaces in 'model\interfaces\Controller.Pessoa.Interfaces.pas',
  Controller.Pessoa in 'model\Controller\Controller.Pessoa.pas',
  Model.Endereco in 'model\classes\Model.Endereco.pas',
  Endereco.DAO in 'model\DAO\Endereco.DAO.pas',
  Util.Consulta in 'Util\Util.Consulta.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
