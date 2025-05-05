unit uBuscarTributacaoProduto;

interface

uses
  uProduto, uProdutoTributacao, uConstantesGerais, uVariaveisGlobais,
  uConstantesBaseDados, System.SysUtils, uRepositorioProdutoTributacao, uLogErro,
  FireDAC.Stan.Error, uArquivoCSVLinhaProduto;


    /// <summary>
    /// Obtém o registro de tributação de produto mais recente por código do produto e UF.
    /// A busca considera a data de validade (cVIGENCIAFIM) mais recente.
    /// </summary>
    /// <param name="pCodigoProduto" type="Integer">Código do produto.</param>
    /// <param name="pUf" type="string">UF do produto.</param>
    /// <returns>Objeto com os dados da tributação do produto mais recente, ou nil se não encontrado.</returns>
  function BuscarProdutoTributacao
    (const pCodigoProduto: Integer; const pUf: string): TArquivoCSVLinhaProduto;

implementation

function BuscarProdutoTributacao
  (const pCodigoProduto: Integer; const pUf: string): TArquivoCSVLinhaProduto;
begin
  Result := nil
end;

end.
