unit uTestRepositorioProdutoTributacao;
{

  Delphi DUnit Test Case
  ----------------------
  Classe de teste para TRepositorioProdutoTributacao

}

interface

uses
  TestFramework, uIRepositorioProdutoTributacao, uRepositorioProdutoTributacao,
  System.SysUtils, System.Types, uProdutoTributacao, FireDAC.Comp.Client,
  uConexaoBanco, uConfiguracao, uVariaveisGlobais, uConstantesTeste,
  System.Generics.Collections, uConstantesGerais;

type
  /// <summary>
  /// Classe de teste para TRepositorioProdutoTributacao
  /// </summary>
  TestTRepositorioProdutoTributacao = class(TTestCase)
  strict private
    FRepositorio: TRepositorioProdutoTributacao;
    FConexao: TFDConnection;
    FProdutoTributacaoInserido: TProdutoTributacao;

    /// <summary>
    /// Cria um registro de produto tributação para uso nos testes.
    /// </summary>
    /// <param name="pCodigoProduto">Código do produto.</param>
    /// <returns>Objeto TProdutoTributacao.</returns>
    function CriarProdutoTributacaoParaTeste(pCodigoProduto: Integer): TProdutoTributacao;
  public
    /// <summary>
    /// Configuração do ambiente de teste.
    /// </summary>
    procedure SetUp; override;

    /// <summary>
    /// Desconfiguração do ambiente de teste.
    /// </summary>
    procedure TearDown; override;
  published

    /// <summary>
    /// Testa a inserção de um produto tributação.
    /// </summary>
    procedure TestInserirProdutoTributacao;

    /// <summary>
    /// Testa a obtenção de um produto tributação por código.
    /// </summary>
    procedure TestObterProdutoTributacao;

     /// <summary>
    /// Testa a obtenção de um produto tributação por código, NCM e UF.
    /// </summary>
    procedure TestObterProdutoTributacaoPorCodigoNcmUf;

    /// <summary>
    /// Testa a atualização de um produto tributação.
    /// </summary>
    procedure TestAtualizarProdutoTributacao;

    /// <summary>
    /// Testa a exclusão de um produto tributação.
    /// </summary>
    procedure TestExcluirProdutoTributacao;

    /// <summary>
    /// Testa a obtenção de todos os produtos tributação.
    /// </summary>
    procedure TestObterTodosProdutosTributacao;

    /// <summary>
    /// Testa a tentativa de obter um produto tributação inexistente.
    /// </summary>
    procedure TestObterProdutoTributacao_ProdutoNaoEncontrado;

    /// <summary>
    /// Testa a tentativa de atualizar um produto tributação inexistente.
    /// </summary>
    procedure TestAtualizarProdutoTributacao_ProdutoNaoEncontrado;

    /// <summary>
    /// Testa a tentativa de excluir um produto tributação inexistente.
    /// </summary>
    procedure TestExcluirProdutoTributacao_ProdutoNaoEncontrado;
  end;

implementation

function TestTRepositorioProdutoTributacao.CriarProdutoTributacaoParaTeste(
  pCodigoProduto: Integer): TProdutoTributacao;
begin
  // Cria e retorna uma instância de TProdutoTributacao com dados de teste.
  Result := TProdutoTributacao.Create;
  Result.CODIGOPRODUTO := pCodigoProduto;
  Result.UF := SIGLA_ESTADOS[26];
  Result.EX := INT_ZERO;
  Result.TIPO := INT_1;
  Result.TRIBNACIONALFEDERAL := CURRENCY_10_5;
  Result.TRIBIMPORTADOSFEDERAL := CURRENCY_5_2;
  Result.TRIBESTADUAL := CURRENCY_2;
  Result.TRIBMUNICIPAL := CURRENCY_ZERO;
  Result.VIGENCIAINICIO := EncodeDate(2024, 1, 1);
  Result.VIGENCIAFIM := EncodeDate(2024, 12, 31);
  Result.CHAVE := CHAVE_TESTE;
  Result.VERSAO := VERSAO_TESTE;
  Result.FONTE := FONTE_TESTE;
end;

procedure TestTRepositorioProdutoTributacao.SetUp;
begin
  // Configura a conexão com o banco de dados e cria o repositório.
  CarregarConfiguracao;
  FConexao := gConexaoBanco.Conexao; // Obtém a conexão
  FRepositorio := TRepositorioProdutoTributacao.Create(FConexao); // Passa a conexão para o repositório
  FProdutoTributacaoInserido := nil;
end;

procedure TestTRepositorioProdutoTributacao.TearDown;
begin
  // Libera os recursos utilizados nos testes.
  if Assigned(FProdutoTributacaoInserido) then
  begin
    try
      FRepositorio.ExcluirProdutoTributacao(FProdutoTributacaoInserido.CODIGOPRODUTO);
    except
      // Ignora erros na exclusão durante o TearDown
    end;
    FProdutoTributacaoInserido.Free;
  end;
  FRepositorio.Free;
  gConexaoBanco.FecharConexao;
  gConexaoBanco.Free;
  gConexaoBanco := nil;
end;

procedure TestTRepositorioProdutoTributacao.TestInserirProdutoTributacao;
var
  produtoTributacao: TProdutoTributacao;
  codigoInserir: Integer;
begin
  // Arrange
  codigoInserir := INT_1;
  produtoTributacao := CriarProdutoTributacaoParaTeste(codigoInserir);

  // Act
  FRepositorio.InserirProdutoTributacao(produtoTributacao);
  FProdutoTributacaoInserido := produtoTributacao; // Armazena para exclusão no TearDown

  // Assert
  Check(Assigned(FProdutoTributacaoInserido), 'Produto tributação não foi inserido.');
  if Assigned(FProdutoTributacaoInserido) then
  begin
    CheckEquals(codigoInserir, FProdutoTributacaoInserido.CODIGOPRODUTO, 'Código do produto tributação inserido incorreto.');
  end;
end;

procedure TestTRepositorioProdutoTributacao.TestObterProdutoTributacao;
var
  produtoTributacaoInserido: TProdutoTributacao;
  produtoObtido: TProdutoTributacao;
  codigoObter: Integer;
begin
  // Arrange
  codigoObter := INT_1;
  produtoTributacaoInserido := CriarProdutoTributacaoParaTeste(codigoObter);
  FRepositorio.InserirProdutoTributacao(produtoTributacaoInserido);
  FProdutoTributacaoInserido := produtoTributacaoInserido; // Armazena para exclusão no TearDown

  // Act
  produtoObtido := FRepositorio.ObterProdutoTributacao(codigoObter);

  // Assert
  Check(Assigned(produtoObtido), 'Produto tributação não foi encontrado.');
  if Assigned(produtoObtido) then
  begin
    CheckEquals(codigoObter, produtoObtido.CODIGOPRODUTO, 'Código do produto tributação obtido incorreto.');
  end;
end;

procedure TestTRepositorioProdutoTributacao.TestObterProdutoTributacaoPorCodigoNcmUf;
var
  produtoTributacaoInserido: TProdutoTributacao;
  produtoObtido: TProdutoTributacao;
  codigoObter: Integer;
  ncm: string;
  uf: string;
begin
  // Arrange
  codigoObter := 2;
  uf :=  SIGLA_ESTADOS[26];
  produtoTributacaoInserido := CriarProdutoTributacaoParaTeste(codigoObter);
  FRepositorio.InserirProdutoTributacao(produtoTributacaoInserido);
  FProdutoTributacaoInserido := produtoTributacaoInserido;

  // Act
  produtoObtido := FRepositorio.ObterProdutoTributacao(codigoObter, uf);

  // Assert
  Check(Assigned(produtoObtido), 'Produto tributação não foi encontrado por código e UF.');
  if Assigned(produtoObtido) then
  begin
    CheckEquals(codigoObter, produtoObtido.CODIGOPRODUTO, 'Código do produto incorreto.');
    CheckEquals(uf, produtoObtido.UF, 'UF incorretos.');
  end;
end;

procedure TestTRepositorioProdutoTributacao.TestAtualizarProdutoTributacao;
var
  produtoTributacaoInserido: TProdutoTributacao;
  produtoAtualizado: TProdutoTributacao;
  codigoAtualizar: Integer;
begin
  // Arrange
  codigoAtualizar := INT_1;
  produtoTributacaoInserido := CriarProdutoTributacaoParaTeste(codigoAtualizar);
  FRepositorio.InserirProdutoTributacao(produtoTributacaoInserido);
  FProdutoTributacaoInserido := produtoTributacaoInserido;

  // Modifica alguns dados para a atualização
  produtoTributacaoInserido.UF := 'RJ';
  produtoTributacaoInserido.VERSAO := '2.0';

  // Act
  FRepositorio.AtualizarProdutoTributacao(produtoTributacaoInserido);
  produtoAtualizado := FRepositorio.ObterProdutoTributacao(codigoAtualizar);

  // Assert
  Check(Assigned(produtoAtualizado), 'Produto tributação não foi encontrado após atualização.');
  if Assigned(produtoAtualizado) then
  begin
    CheckEquals('RJ', produtoAtualizado.UF, 'UF não foi atualizada corretamente.');
    CheckEquals('2.0', produtoAtualizado.VERSAO, 'Versão não foi atualizada corretamente.');
  end;
end;

procedure TestTRepositorioProdutoTributacao.TestExcluirProdutoTributacao;
var
  produtoTributacao: TProdutoTributacao;
  codigoExcluir: Integer;
begin
  // Arrange
  codigoExcluir := INT_1;
  produtoTributacao := CriarProdutoTributacaoParaTeste(codigoExcluir);
  FRepositorio.InserirProdutoTributacao(produtoTributacao);
  FProdutoTributacaoInserido := produtoTributacao; // Armazena para exclusão no TearDown

  // Act
  FRepositorio.ExcluirProdutoTributacao(codigoExcluir);
  FProdutoTributacaoInserido := nil;

  // Assert
  var produtoExcluido := FRepositorio.ObterProdutoTributacao(codigoExcluir);
  Check(not Assigned(produtoExcluido), 'Produto tributação não foi excluído.');

  produtoTributacao.Free;
end;

procedure TestTRepositorioProdutoTributacao.TestObterTodosProdutosTributacao;
var
  listaProdutos: TList<TProdutoTributacao>;
  produto1, produto2: TProdutoTributacao;
  codigo1: Integer;
  codigo2: Integer;
begin
  // Arrange
  codigo1 := INT_1;
  codigo2 := INT_2;
  produto1 := CriarProdutoTributacaoParaTeste(codigo1);
  produto2 := CriarProdutoTributacaoParaTeste(codigo2);

  FRepositorio.InserirProdutoTributacao(produto1);
  FRepositorio.InserirProdutoTributacao(produto2);
  FProdutoTributacaoInserido := produto1; // Armazena um para exclusão no TearDown
  //Nota: Não precisa armazenar o produto2, pois o TearDown exclui apenas 1 registro inserido.

  // Act
  listaProdutos := FRepositorio.ObterTodosProdutosTributacao;

  // Assert
  Check(listaProdutos.Count >= 2, 'Não retornou todos os produtos tributação.');
  listaProdutos.Free;
end;

procedure TestTRepositorioProdutoTributacao.TestObterProdutoTributacao_ProdutoNaoEncontrado;
var
  codigoObter: Integer;
  produtoObtido: TProdutoTributacao;
begin
  // Arrange
  codigoObter := CODIGO_PRODUTO_NAO_ENCONTRADO;

  // Act
  produtoObtido := FRepositorio.ObterProdutoTributacao(codigoObter);

  // Assert
  Check(not Assigned(produtoObtido), 'Obteve produto tributação inexistente.');
end;

procedure TestTRepositorioProdutoTributacao.TestAtualizarProdutoTributacao_ProdutoNaoEncontrado;
var
  produtoTributacao: TProdutoTributacao;
  codigoAtualizar: Integer;
begin
  // Arrange
  codigoAtualizar := CODIGO_PRODUTO_NAO_ENCONTRADO;
  produtoTributacao := CriarProdutoTributacaoParaTeste(codigoAtualizar);

  // Act
  // A chamada abaixo não deve levantar exceção, de acordo com a implementação atual do repositório.
  FRepositorio.AtualizarProdutoTributacao(produtoTributacao);

  // Assert
  // Se chegar aqui, a atualização não causou erro, o que é o comportamento esperado.
  Check(True, 'Atualizar produto tributação não existente não causou erro');
end;

procedure TestTRepositorioProdutoTributacao.TestExcluirProdutoTributacao_ProdutoNaoEncontrado;
var
  codigoExcluir: Integer;
begin
  // Arrange
  codigoExcluir := CODIGO_PRODUTO_NAO_ENCONTRADO;

  // Act
  // A chamada abaixo não deve levantar exceção, de acordo com a implementação atual do repositório.
  FRepositorio.ExcluirProdutoTributacao(codigoExcluir);

  // Assert
  Check(True, 'Excluir produto tributação não existente não causou erro');
end;

initialization
  // Registra a classe de teste para ser executada pelo runner de testes.
  RegisterTest(TestTRepositorioProdutoTributacao.Suite);
end.
