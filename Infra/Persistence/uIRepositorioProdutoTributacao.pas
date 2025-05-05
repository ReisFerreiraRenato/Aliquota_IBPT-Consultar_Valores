unit uIRepositorioProdutoTributacao;

interface

uses
  System.SysUtils,
  System.Types,
  uProdutoTributacao,
  System.Generics.Collections;

type
  /// <summary>
  /// Interface para o reposit�rio de dados de tributa��o de produtos.
  /// Define os m�todos para acessar e manipular os dados na tabela PRODUTOTRIBUTACAO.
  /// </summary>
  IRepositorioProdutoTributacao = interface
    ['{98765432-10FE-DCBA-9876-543210FEDCBA}']
    /// <summary>Insere um novo registro de tributa��o de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto contendo os dados da tributa��o do produto.</param>
    procedure InserirProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Obt�m um registro de tributa��o de produto pelo c�digo do produto. </summary>
    /// <param name="pCodigoProduto" type="Integer">C�digo do produto para buscar a tributa��o.</param>
    /// <returns>Objeto com os dados da tributa��o do produto, ou nil se n�o encontrado.</returns>
    function ObterProdutoTributacao(const pCodigoProduto: Integer): TProdutoTributacao; overload;

    /// <summary>Obt�m o registro de tributa��o de produto mais recente por c�digo do produto, NCM e UF. A busca considera a data de validade (VigenciaFim) mais recente. </summary>
    /// <param name="pCodigoProduto" type="string">C�digo do produto.</param>
    /// <param name="pNcm" type="string">C�digo NCM do produto.</param>
    /// <param name="pUf" type="string">UF do produto.</param>
    /// <returns>Objeto com os dados da tributa��o do produto mais recente, ou nil se n�o encontrado.</returns>
    function ObterProdutoTributacao(const pCodigoProduto: Integer; const pUf: string): TProdutoTributacao; overload;

    /// <summary>Atualiza um registro de tributa��o de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto com os dados da tributa��o do produto a serem atualizados.</param>
    procedure AtualizarProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Exclui um registro de tributa��o de produto pelo c�digo do produto. </summary>
    /// <param name="pCodigoProduto" type="Integer">C�digo do produto para excluir a tributa��o.</param>
    procedure ExcluirProdutoTributacao(const pCodigoProduto: Integer);

    /// <summary>Obt�m todos os registros de tributa��o de produtos do banco de dados. </summary>
    /// <returns>Lista de objetos contendo os dados de tributa��o dos produtos.</returns>
    function ObterTodosProdutosTributacao: TList<TProdutoTributacao>;
  end;

implementation

end.
