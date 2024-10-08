unit Model.Order;

interface

type
  TOrder = class
  private
    FID: Integer;
    FIdCliente: Integer;
    FDataEmissao: TDate;
    FValorTotal: Double;
  public
    property ID: Integer read FID write FID;
    property IdCliente: Integer read FIdCliente write FIdCliente;
    property DataEmissao: TDate read FDataEmissao write FDataEmissao;
    property ValorTotal: Double read FValorTotal write FValorTotal;
  end;
implementation
end.
