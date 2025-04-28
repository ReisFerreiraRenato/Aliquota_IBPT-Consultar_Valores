unit uRepositorioProduto;

interface

uses
  System.SysUtils,
  System.Types,
  uProduto,
  uIRepositorioProduto,
  uConexaoBanco,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  FireDAC.Stan.Param,
  Data.DB,
  uConstantesGerais,
  uFuncoes,
  uVariaveisGlobais,
  uConstantesBaseDados;

type
  /// <summary>
  /// Implementação do repositório de produtos para o banco de dados Firebird.
  /// </summary>
  TRepositorioProduto = class(TInterfacedObject, IRepositorioProduto)
  private
    FConexaoBanco: TConexaoBanco;

    /// <summary>
    /// Obtém o produto do leitor de dados.
    /// </summary>
    /// <param name="pFDQuery">Objeto TFDQuery com os dados do produto.</param>
    /// <returns>Retorna o produto.</returns>
    function ObterProdutoDoLeitor(pFDQuery: TFDQuery): TProduto;

  public
    /// <summary>
    /// Cria uma nova instância da classe TRepositorioProdutoFirebird.
    /// </summary>
    /// <param name="pConexaoBanco">A conexão com o banco de dados Firebird.</param>
    constructor Create(pConexaoBanco: TConexaoBanco);

    /// <summary>
    /// Destrói a instância da classe TRepositorioProdutoFirebird.
    /// </summary>
    destructor Destroy; override;

    /// <inheritdoc />
    function BuscarPorCodigo(pCodigo: Integer): TProduto;

    /// <inheritdoc />
    function BuscarPorDescricao(pDescricao: string): TArray<TProduto>;

    /// <inheritdoc />
    function BuscarPorNcm(pNcm: string): TArray<TProduto>;

    /// <inheritdoc />
    procedure Inserir(const pProduto: TProduto);

    /// <inheritdoc />
    procedure Excluir(pCodigo: Integer);
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
