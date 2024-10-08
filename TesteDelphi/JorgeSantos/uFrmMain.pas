unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Model.Factory.Connection, Vcl.ComCtrls,
  Vcl.StdCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient,
  Controller.Pessoa, Datasnap.Provider, Vcl.Buttons, Model.Pessoa, Vcl.Mask,
  Vcl.ExtCtrls, Vcl.DBCtrls, Controller.Pessoa.Interfaces;

type
  TfrmMain = class(TForm)
    lblId: TLabel;
    lblPrimeiroNome: TLabel;
    lblSobrenome: TLabel;
    lblDocumento: TLabel;
    lblNatureza: TLabel;
    lblDtRegistro: TLabel;
    dbgPessoa: TDBGrid;
    dsMain: TDataSource;
    lblCEP: TLabel;
    lblCidade: TLabel;
    lblUF: TLabel;
    lblEndereco: TLabel;
    lblBairro: TLabel;
    lblComplemento: TLabel;
    cdsPessoa: TClientDataSet;
    cdsPessoaflnatureza: TSmallintField;
    cdsPessoadsdocumento: TStringField;
    cdsPessoanmprimeiro: TStringField;
    cdsPessoanmsegundo: TStringField;
    cdsPessoadtregistro: TDateField;
    cdsPessoaidpessoa: TLargeintField;
    btIncluir: TSpeedButton;
    btExcluir: TSpeedButton;
    btSalvar: TSpeedButton;
    btCancelar: TSpeedButton;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    dbEdtCEP: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    cdsPessoaCEP: TStringField;
    cdsPessoaUF: TStringField;
    cdsPessoanmCidade: TStringField;
    cdsPessoanmlogradouro: TStringField;
    cdsPessoadsComplemento: TStringField;
    cdsPessoanmBairro: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure dbEdtCEPExit(Sender: TObject);
    procedure btIncluirClick(Sender: TObject);
    procedure cdsUpdateButtons(DataSet: TDataSet);
    procedure btSalvarClick(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
  private
    FFactoryConnection: TFactoryConnection;
    FPessoaController : IPessoaController;
    procedure LoadData;
    procedure UpdateButtons;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.Generics.Collections, Util.Consulta, Model.Endereco;


{$R *.dfm}

procedure TfrmMain.btSalvarClick(Sender: TObject);
var
  pessoa: TPessoa;
  endereco: TEndereco;
  isEditing: Boolean;
begin

  try
    isEditing := cdsPessoa.State = dsEdit;
    cdsPessoa.Post;
    if cdsPessoa.FieldByName('CEP').AsString = '' then
    begin
      LoadData;
      raise Exception.Create('Informe um CEP válido antes de continuar.');
    end;

    pessoa := TPessoa.Create;
    pessoa.IdPessoa := cdsPessoa.FieldByName('idPessoa').AsLargeInt;
    pessoa.FlNatureza := cdsPessoa.FieldByName('FlNatureza').AsInteger;
    pessoa.DsDocumento := cdsPessoa.FieldByName('DsDocumento').AsString;
    pessoa.NmPrimeiro := cdsPessoa.FieldByName('NmPrimeiro').AsString;
    pessoa.NmSegundo := cdsPessoa.FieldByName('NmSegundo').AsString;
    pessoa.DtRegistro := cdsPessoa.FieldByName('DtRegistro').AsDateTime;

    endereco := TEndereco.Create;
    endereco.IdPessoa := cdsPessoa.FieldByName('idPessoa').AsLargeInt;
    endereco.dsCEP := cdsPessoa.FieldByName('CEP').AsString;
    endereco.dsUF := cdsPessoa.FieldByName('UF').AsString;
    endereco.nmCidade := cdsPessoa.FieldByName('nmCidade').AsString;
    endereco.nmBairro := cdsPessoa.FieldByName('nmBairro').AsString;
    endereco.nmLogradouro := cdsPessoa.FieldByName('nmLogradouro').AsString;
    endereco.dsComplemento := cdsPessoa.FieldByName('dsComplemento').AsString;
    if not isEditing then
    begin
      pessoa.IdPessoa := FPessoaController.GetLastPessoa +1;
      endereco.IdPessoa := pessoa.IdPessoa;
      FPessoaController.AddPessoa(pessoa);
      FPessoaController.AddEndereco(endereco);
    end
    else
      begin
      FPessoaController.UpdatePessoa(pessoa);
      FPessoaController.UpdateEndereco(endereco);

      end;
    LoadData;
  finally
    FreeAndNil(pessoa);
  end;
end;

procedure TfrmMain.cdsUpdateButtons(DataSet: TDataSet);
begin
  UpdateButtons;
end;

procedure TfrmMain.dbEdtCEPExit(Sender: TObject);
var
  Endereco: TStringList;
begin
  if cdsPessoa.State in [dsInsert, dsEdit] then
  begin
    if (cdsPessoa.FieldByName('CEP').AsString <> '') and
       (cdsPessoa.FieldByName('CEP').AsString <> cdsPessoa.FieldByName('CEP').OldValue) then
    begin
      try
        Endereco := TUtilConsulta.GetEnderecoPeloCEP(cdsPessoa.FieldByName('CEP').AsString);
        cdsPessoa.FieldByName('UF').AsString := Endereco[4];
        cdsPessoa.FieldByName('nmcidade').AsString := Endereco[3];
        cdsPessoa.FieldByName('nmlogradouro').AsString := Endereco[0];
        cdsPessoa.FieldByName('dscomplemento').AsString := Endereco[1];
        cdsPessoa.FieldByName('nmbairro').AsString := Endereco[2];
      finally
        FreeAndNil(Endereco);

      end;
    end;

  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FPessoaController := TPessoaController.Create;
  LoadData;

end;

procedure TfrmMain.LoadData;
var
  ListaPessoas: TList<TPessoa>;
  Endereco: TEndereco;
  I: Integer;
begin
  cdsPessoa.Close;
  cdsPessoa.CreateDataSet;
  cdsPessoa.Open;
  cdsPessoa.AfterScroll := nil;
  try
    Endereco := TEndereco.Create;
    ListaPessoas := FPessoaController.GetAll;
    for I := 0 to ListaPessoas.Count-1 do
    begin
      cdsPessoa.Append;
      cdsPessoa.FieldByName('idpessoa').AsLargeInt := ListaPessoas[I].IdPessoa;
      cdsPessoa.FieldByName('flNatureza').AsInteger := ListaPessoas[I].flNatureza;
      cdsPessoa.FieldByName('dsDocumento').AsString := ListaPessoas[I].DsDocumento;
      cdsPessoa.FieldByName('nmPrimeiro').AsString := ListaPessoas[I].NmPrimeiro;
      cdsPessoa.FieldByName('nmSegundo').AsString := ListaPessoas[I].NmSegundo;
      cdsPessoa.FieldByName('dtRegistro').AsDateTime := ListaPessoas[I].DtRegistro;
      Endereco := FPessoaController.GetEnderecoById(ListaPessoas[I].IdPessoa);
      cdsPessoa.FieldByName('CEP').AsString := Endereco.dsCEP;
      cdsPessoa.FieldByName('UF').AsString := Endereco.dsUF;
      cdsPessoa.FieldByName('nmCidade').AsString := Endereco.nmCidade;
      cdsPessoa.FieldByName('nmLogradouro').AsString := Endereco.nmLogradouro;
      cdsPessoa.FieldByName('dsComplemento').AsString := Endereco.dsComplemento;
      cdsPessoa.FieldByName('nmBairro').AsString := Endereco.nmBairro;
      cdsPessoa.Post;
    end;
  finally
    Endereco.Free;
    ListaPessoas.Free;
  end;
  UpdateButtons;
end;

procedure TfrmMain.btCancelarClick(Sender: TObject);
begin
  cdsPessoa.Cancel;
end;

procedure TfrmMain.btExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Você tem certeza que deseja excluir este pedido selecionado?', 'Confirmação', MB_ICONQUESTION or MB_YESNO) = IDYES then
  begin
    FPessoaController.DeletePessoa(cdsPessoa.FieldByName('idpessoa').AsLargeInt);
  end;
  LoadData;
end;

procedure TfrmMain.btIncluirClick(Sender: TObject);
begin
  cdsPessoa.Append;
end;

procedure TfrmMain.UpdateButtons;
begin
  btIncluir.Enabled := not(cdsPessoa.State in [dsInsert, dsEdit]);
  btExcluir.Enabled := not(cdsPessoa.State in [dsInsert, dsEdit]) and (not cdsPessoa.IsEmpty);
  btSalvar.Enabled := (cdsPessoa.State in [dsInsert, dsEdit]) and (not cdsPessoa.IsEmpty);
  btCancelar.Enabled := (cdsPessoa.State in [dsInsert, dsEdit]) and (not cdsPessoa.IsEmpty);

end;

end.
