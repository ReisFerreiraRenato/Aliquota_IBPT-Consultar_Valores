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
    ['{B54ED86E-211F-4803-AF46-0586DA66C583}']
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

    /// <summary>
    /// Insere um novo produto no banco de dados.
    /// </summary>
    /// <param name="pProduto">Objeto TProduto a ser inserido.</param>
    procedure Inserir(const pProduto: TProduto);

    /// <summary>
    /// Exclui um produto do banco de dados pelo código.
    /// </summary>
    /// <param name="pCodigo">Código do produto a ser excluído.</param>
    procedure Excluir(pCodigo: Integer);

    /// <summary>
    /// Atualiza os dados de um produto no banco de dados.
    /// </summary>
    /// <param name="pProduto">Objeto TProduto com os novos dados.</param>
    procedure Atualizar(const pProduto: TProduto);
  end;

implementation

end.
