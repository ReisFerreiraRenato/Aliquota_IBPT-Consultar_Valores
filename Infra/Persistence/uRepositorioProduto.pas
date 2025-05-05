unit uRepositorioProduto;

interface

uses
  System.SysUtils,
  System.Types,
  uProduto,
  uIRepositorioProduto,
  uConexaoBanco,
  FireDAC.Comp.Client,
  Firedac.DApt,
  FireDAC.Stan.Async,
  System.Generics.Collections,
  FireDAC.Stan.Param,
  Data.DB,
  uConstantesGerais,
  uFuncoes,
  uVariaveisGlobais,
  uConstantesBaseDados;

type
  /// <summary>Implementa��o do reposit�rio de produtos para o banco de dados. </summary>
  TRepositorioProduto = class(TInterfacedObject, IRepositorioProduto)
  private
    FConexaoBanco: TConexaoBanco;

    /// <summary>Obt�m o produto do leitor de dados. </summary>
    /// <param name="pFDQuery">Objeto TFDQuery com os dados do produto.</param>
    /// <returns>Retorna o produto.</returns>
    function ObterProdutoDoLeitor(pFDQuery: TFDQuery): TProduto;

  public
    /// <summary>Cria uma nova inst�ncia da classe TRepositorioProdutoFirebird. </summary>
    /// <param name="pConexaoBanco" type="TConexaoBanco">A conex�o com o banco de dados Firebird.</param>
    constructor Create(pConexaoBanco: TConexaoBanco);

    /// <summary>Destr�i a inst�ncia da classe TRepositorioProdutoFirebird. </summary>
    destructor Destroy; override;

    /// <summary>Busca um produto pelo c�digo. </summary>
    /// <param name="pCodigo" type="Integer">O c�digo do produto.</param>
    /// <returns>O produto encontrado ou nil se n�o encontrado.</returns>
    function BuscarPorCodigo(pCodigo: Integer): TProduto;

    /// <summary>Busca produtos pela descri��o. </summary>
    /// <param name="pDescricao" type="string">A descri��o do produto.</param>
    /// <returns>Uma lista de produtos que correspondem � descri��o.</returns>
    function BuscarPorDescricao(pDescricao: string): TArray<TProduto>;

    /// <summary>Busca produtos pelo NCM. </summary>
    /// <param name="pNcm" type="string">Codigo NCM do produto.</param>
    /// <returns>Uma lista de produtos que correspondem ao NCM.</returns>
    function BuscarPorNcm(pNcm: string): TArray<TProduto>;

    /// <summary>Insere um novo produto no banco de dados. </summary>
    /// <param name="pProduto" type="TProduto">Objeto TProduto a ser inserido.</param>
    procedure Inserir(const pProduto: TProduto);

    /// <summary>Exclui um produto do banco de dados pelo c�digo. </summary>
    /// <param name="pCodigo" type="Integer">C�digo do produto a ser exclu�do.</param>
    procedure Excluir(pCodigo: Integer);

    /// <summary>Atualiza os dados de um produto no banco de dados. </summary>
    /// <param name="pProduto" type="TProduto">Objeto TProduto com os novos dados.</param>
    procedure Atualizar(const pProduto: TProduto);
  end;

implementation

const
  SQL_PADRAO_PRODUTO =
    'SELECT '+ cCODIGO +', '+ cDESCRICAO +', '+ cNCM +' FROM PRODUTO ';

function TRepositorioProduto.ObterProdutoDoLeitor(
  pFDQuery: TFDQuery): TProduto;
begin
  Result := TProduto.Create(
    pFDQuery.FieldByName(cCODIGO).AsInteger,
    pFDQuery.FieldByName(cDESCRICAO).AsString,
    pFDQuery.FieldByName(cNCM).AsString);
end;

constructor TRepositorioProduto.Create(pConexaoBanco: TConexaoBanco);
begin
  FConexaoBanco := pConexaoBanco;
end;

destructor TRepositorioProduto.Destroy;
begin
  inherited;
end;

procedure TRepositorioProduto.Atualizar(const pProduto: TProduto);
const
  SQL_UPDATE_PRODUTO =
    'UPDATE PRODUTO SET DESCRICAO = :Descricao, NCM = :Ncm WHERE CODIGO = :Codigo';
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_UPDATE_PRODUTO;
    FDQuery.Params.ParamByName(cCODIGO).AsInteger := pProduto.Codigo;
    FDQuery.Params.ParamByName(cDESCRICAO).AsString := pProduto.Descricao;
    FDQuery.Params.ParamByName(cNCM).AsString := pProduto.Ncm;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProduto.BuscarPorCodigo(
  pCodigo: Integer): TProduto;
const
  CONDICAO_BUSCA_PRODUTO_NOME = ' WHERE CODIGO = :CODIGO';
var
  FDQuery: TFDQuery;
begin
  Result := nil;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO + CONDICAO_BUSCA_PRODUTO_NOME;
    FDQuery.Params.ParamByName(cCODIGO).AsInteger := pCodigo;
    FDQuery.Open;
    if not FDQuery.IsEmpty then
      Result := ObterProdutoDoLeitor(FDQuery);
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProduto.BuscarPorDescricao(
  pDescricao: string): TArray<TProduto>;
const
  CONDICAO_BUSCA_PRODUTO_DESCRICAO = ' WHERE UPPER(DESCRICAO) LIKE :DESCRICAO';
var
  FDQuery: TFDQuery;
  ListaProdutos: TList<TProduto>;
  Produto: TProduto;
begin
  SetLength(Result, INT_ZERO);
  FDQuery := TFDQuery.Create(nil);
  ListaProdutos := TList<TProduto>.Create;
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO + CONDICAO_BUSCA_PRODUTO_DESCRICAO;
    FDQuery.Params.ParamByName(cDESCRICAO).AsString :=
        UpperCase(ConcatenaBuscaLiteralString(pDescricao));
    FDQuery.Open;
    while not FDQuery.Eof do
    begin
      Produto := ObterProdutoDoLeitor(FDQuery);
      ListaProdutos.Add(Produto);
      FDQuery.Next;
    end;
    Result := ListaProdutos.ToArray;
  finally
    FDQuery.Free;
    ListaProdutos.Free;
  end;
end;

function TRepositorioProduto.BuscarPorNcm(pNcm: string): TArray<TProduto>;
const
  CONDICAO_BUSCAR_PRODUTO_NCM = ' WHERE NCM = :NCM';
var
  FDQuery: TFDQuery;
  ListaProdutos: TList<TProduto>;
  Produto: TProduto;
begin
  SetLength(Result, INT_ZERO);
  FDQuery := TFDQuery.Create(nil);
  ListaProdutos := TList<TProduto>.Create;
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO + CONDICAO_BUSCAR_PRODUTO_NCM;
    FDQuery.Params.ParamByName(cNCM).AsString := pNcm;
    FDQuery.Open;
    while not FDQuery.Eof do
    begin
      Produto := ObterProdutoDoLeitor(FDQuery);
      ListaProdutos.Add(Produto);
      FDQuery.Next;
    end;
    Result := ListaProdutos.ToArray;
  finally
    FDQuery.Free;
    ListaProdutos.Free;
  end;
end;

procedure TRepositorioProduto.Inserir(const pProduto: TProduto);
const
  SQL_INSERT_PRODUTO = 'INSERT INTO PRODUTO (CODIGO, DESCRICAO, NCM) VALUES (:Codigo, :Descricao, :Ncm)';
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_INSERT_PRODUTO;
    FDQuery.Params.ParamByName(cCODIGO).AsInteger := pProduto.Codigo;
    FDQuery.Params.ParamByName(cDESCRICAO).AsString := pProduto.Descricao;
    FDQuery.Params.ParamByName(cNCM).AsString := pProduto.Ncm;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

procedure TRepositorioProduto.Excluir(pCodigo: Integer);
const
  SQL_DELETE_PRODUTO = 'DELETE FROM PRODUTO WHERE CODIGO = :Codigo';
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexaoBanco.Conexao;
    FDQuery.SQL.Text := SQL_DELETE_PRODUTO;
    FDQuery.Params.ParamByName(cCODIGO).AsInteger := pCodigo;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

end.
