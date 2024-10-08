unit Model.Factory.Connection.Interfaces;

interface

uses
  FireDAC.Comp.Client;
type
  IFactoryConnection = interface
    ['{7392457D-8FFD-4A7D-B813-3A1209AB960C}']
    function Connection: TFDConnection;
    function Query: TFDQuery;
  end;
implementation

end.
