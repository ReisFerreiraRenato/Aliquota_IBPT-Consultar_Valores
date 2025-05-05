unit uBuscarCalculoTributosProduto;

interface

uses
  uProduto, uProdutoTributacao, uConstantesGerais, uVariaveisGlobais,
  uConstantesBaseDados, System.SysUtils, uRepositorioProdutoTributacao, uLogErro,
  FireDAC.Stan.Error, uArquivoCSVLinhaProduto, uCalculoTributosProduto;

  /// <summary>Obtém o registro de tributação de produto mais recente por código do produto e UF. Considera a data de validade (cVIGENCIAFIM) mais recente. </summary>
  /// <param name="pCodigoProduto" type="Integer">Código do produto. </param>
  /// <param name="pUf" type="string">UF do produto. </param>
  /// <param name="pValor" type="Currency">Valor do produto. </param>
  /// <returns>Objeto com os dados da tributação do produto mais recente, ou nil se não encontrado.</returns>
  function BuscarProdutoTributacao
    (const pCodigoProduto: Integer; const pUf: string; const pValor: Currency): TArquivoCSVLinhaProduto;

implementation

function BuscarProdutoTributacao
    (const pCodigoProduto: Integer; const pUf: string; const pValor: Currency): TArquivoCSVLinhaProduto;
var
  produtoCompleto: TArquivoCSVLinhaProduto;
  reposisorioCalculoProduto: TCalculoTributosProduto;
begin
  produtoCompleto := TArquivoCSVLinhaProduto.Create;
  reposisorioCalculoProduto := TCalculoTributosProduto.Create(gConexaoBanco);
  try
    produtoCompleto.Clone(reposisorioCalculoProduto.CalcularTributosProduto
      (pCodigoProduto, pUf, pValor));
    Result := produtoCompleto;
  finally
    reposisorioCalculoProduto.Free;
  end;
end;

end.
