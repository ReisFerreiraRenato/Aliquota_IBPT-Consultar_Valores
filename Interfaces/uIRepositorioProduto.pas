unit uIRepositorioProduto;

interface

uses
  System.SysUtils,
  System.Types,
  uProduto;

type
  /// <summary>
  /// Interface para o reposit�rio de produtos.
  /// Define as opera��es para acessar os dados dos produtos.
  /// </summary>
  IRepositorioProduto = interface
    ['{12345678-1234-1234-1234-123456789012}'] // Substitua por um GUID �nico
    /// <summary>
    /// Busca um produto pelo c�digo.
    /// </summary>
    /// <param name="pCodigo">O c�digo do produto.</param>
    /// <returns>O produto encontrado ou nil se n�o encontrado.</returns>
    function BuscarPorCodigo(pCodigo: Integer): TProduto;
    /// <summary>
    /// Busca produtos pela descri��o.
    /// </summary>
    /// <param name="pDescricao">A descri��o do produto.</param>
    /// <returns>Uma lista de produtos que correspondem � descri��o.</returns>
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
