unit uBuscarTributacaoProduto;

interface

uses
  uProduto, uProdutoTributacao, uConstantesGerais, uVariaveisGlobais,
  uConstantesBaseDados, System.SysUtils, uRepositorioProdutoTributacao, uLogErro,
  FireDAC.Stan.Error, uArquivoCSVLinhaProduto;


    /// <summary>
    /// Obt�m o registro de tributa��o de produto mais recente por c�digo do produto e UF.
    /// A busca considera a data de validade (cVIGENCIAFIM) mais recente.
    /// </summary>
    /// <param name="pCodigoProduto" type="Integer">C�digo do produto.</param>
    /// <param name="pUf" type="string">UF do produto.</param>
    /// <returns>Objeto com os dados da tributa��o do produto mais recente, ou nil se n�o encontrado.</returns>
  function BuscarProdutoTributacao
    (const pCodigoProduto: Integer; const pUf: string): TArquivoCSVLinhaProduto;

implementation

function BuscarProdutoTributacao
  (const pCodigoProduto: Integer; const pUf: string): TArquivoCSVLinhaProduto;
begin
  Result := nil
end;

end.
