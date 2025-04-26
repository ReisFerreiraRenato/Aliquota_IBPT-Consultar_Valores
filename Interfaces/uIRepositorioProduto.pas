unit uIRepositorioProduto;

interface

uses
  System.SysUtils,
  System.Types,
  uProduto;

type
  /// <summary>
  /// Interface para o repositório de produtos.
  /// Define as operações para acessar os dados dos produtos.
  /// </summary>
  IRepositorioProduto = interface
    ['{12345678-1234-1234-1234-123456789012}'] // Substitua por um GUID único
    /// <summary>
    /// Busca um produto pelo código.
    /// </summary>
    /// <param name="pCodigo">O código do produto.</param>
    /// <returns>O produto encontrado ou nil se não encontrado.</returns>
    function BuscarPorCodigo(pCodigo: Integer): TProduto;
    /// <summary>
    /// Busca produtos pela descrição.
    /// </summary>
    /// <param name="pDescricao">A descrição do produto.</param>
    /// <returns>Uma lista de produtos que correspondem à descrição.</returns>
    function BuscarPorDescricao(pDescricao: string): TArray<TProduto>;
    /// <summary>
    /// Busca produtos pelo NCM.
    /// </summary>
    /// <param name="pNcm">O NCM do produto.</param>
    /// <returns>Uma lista de produtos que correspondem ao NCM.</returns>
    function BuscarPorNcm(pNcm: string): TArray<TProduto>;
  end;

implementation

end.
