unit Model.OrderProduct;

interface

type
  TOrderProduct = class
  private
    FID: Integer;
    FIDOrder: Integer;
    FIdProduct: Integer;
    FAmount: Integer;
    FUnitValue: Real;
    FTotalValue: Real;
  public
    property Id: Integer read FID write FID;
    property IDOrder: Integer read FIDOrder write FIDOrder;
    property IdProduct: Integer read FIdProduct write FIdProduct;
    property Amount: Integer read FAmount write FAmount;
    property UnitValue: Real read FUnitValue write FUnitValue;
    property TotalValue: Real read FTotalValue write FTotalValue;

  end;
implementation

end.
