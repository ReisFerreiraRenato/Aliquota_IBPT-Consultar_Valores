unit uIRepositorioProdutoTributacao;

interface

uses
  System.SysUtils,
  System.Types,
  uProdutoTributacao,
  System.Generics.Collections;

type
  /// <summary>
  /// Interface para o repositório de dados de tributação de produtos.
  /// Define os métodos para acessar e manipular os dados na tabela PRODUTOTRIBUTACAO.
  /// </summary>
  IRepositorioProdutoTributacao = interface
    ['{98765432-10FE-DCBA-9876-543210FEDCBA}']
    /// <summary>Insere um novo registro de tributação de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto contendo os dados da tributação do produto.</param>
    procedure InserirProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Obtém um registro de tributação de produto pelo código do produto. </summary>
    /// <param name="pCodigoProduto" type="Integer">Código do produto para buscar a tributação.</param>
    /// <returns>Objeto com os dados da tributação do produto, ou nil se não encontrado.</returns>
    function ObterProdutoTributacao(const pCodigoProduto: Integer): TProdutoTributacao; overload;

    /// <summary>Obtém o registro de tributação de produto mais recente por código do produto, NCM e UF. A busca considera a data de validade (VigenciaFim) mais recente. </summary>
    /// <param name="pCodigoProduto" type="string">Código do produto.</param>
    /// <param name="pNcm" type="string">Código NCM do produto.</param>
    /// <param name="pUf" type="string">UF do produto.</param>
    /// <returns>Objeto com os dados da tributação do produto mais recente, ou nil se não encontrado.</returns>
    function ObterProdutoTributacao(const pCodigoProduto: Integer; const pUf: string): TProdutoTributacao; overload;

    /// <summary>Atualiza um registro de tributação de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto com os dados da tributação do produto a serem atualizados.</param>
    procedure AtualizarProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Exclui um registro de tributação de produto pelo código do produto. </summary>
    /// <param name="pCodigoProduto" type="Integer">Código do produto para excluir a tributação.</param>
    procedure ExcluirProdutoTributacao(const pCodigoProduto: Integer);

    /// <summary>Obtém todos os registros de tributação de produtos do banco de dados. </summary>
    /// <returns>Lista de objetos contendo os dados de tributação dos produtos.</returns>
    function ObterTodosProdutosTributacao: TList<TProdutoTributacao>;
  end;

implementation

end.
