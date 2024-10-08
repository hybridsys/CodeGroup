unit Util.Consulta;

interface
  uses
    Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Comp.Client, System.Classes, REST.Client,
    System.JSON, IPPeerClient, System.SysUtils;

  type
    TUtilConsulta = class
    public
      class function GetEnderecoPeloCEP( aCEP: String): TStringList;
    end;
implementation

{ TUtilConsulta }

class function TUtilConsulta.GetEnderecoPeloCEP(aCEP: String): TStringList;
const
  URL = 'https://viacep.com.br/ws/';
var
  Endereco: TStringList;
  DadosEndereco: TJSONObject;
  rCliente: TRESTClient;
  rRequisicao: TRESTRequest;
  rResposta: TRESTResponse;
begin
  Endereco := TStringList.Create;
  rCliente := TRESTClient.Create(nil);
  rRequisicao := TRESTRequest.Create(nil);
  rResposta := TRESTResponse.Create(nil);
  rRequisicao.Client := rCliente;
  rRequisicao.Response := rResposta;
  rCliente.BaseURL := URL + aCEP + '/json';
  try
    try
      rRequisicao.Execute;
    Except
      on E: Exception do
        raise Exception.Create('Erro no carregamento dos dados do endereço! ' + E.Message);

    end;
    DadosEndereco := rResposta.JSONValue as TJSONObject;
    if Assigned(DadosEndereco.Values['erro']) then
      raise Exception.Create('Error Message');
    Endereco.Add(DadosEndereco.Values['logradouro'].Value);
    Endereco.Add(DadosEndereco.Values['complemento'].Value);
    Endereco.Add(DadosEndereco.Values['bairro'].Value);
    Endereco.Add(DadosEndereco.Values['localidade'].Value);
    Endereco.Add(DadosEndereco.Values['uf'].Value);
    Endereco.Add(DadosEndereco.Values['estado'].Value);
  finally
    FreeAndNil(DadosEndereco);
    FreeAndNil(rCliente);
    FreeAndNil(rRequisicao);
  end;
  Result := Endereco;
end;

end.
