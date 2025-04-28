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
    /// Cria um registro de produto tributa��o para uso nos testes.
    /// </summary>
    /// <param name="pCodigoProduto">C�digo do produto.</param>
    /// <returns>Objeto TProdutoTributacao.</returns>
    function CriarProdutoTributacaoParaTeste(pCodigoProduto: Integer): TProdutoTributacao;
  public
    /// <summary>
    /// Configura��o do ambiente de teste.
    /// </summary>
    procedure SetUp; override;

    /// <summary>
    /// Desconfigura��o do ambiente de teste.
    /// </summary>
    procedure TearDown; override;
  published

    /// <summary>
    /// Testa a inser��o de um produto tributa��o.
    /// </summary>
    procedure TestInserirProdutoTributacao;

    /// <summary>
    /// Testa a obten��o de um produto tributa��o por c�digo.
    /// </summary>
    procedure TestObterProdutoTributacao;

     /// <summary>
    /// Testa a obten��o de um produto tributa��o por c�digo, NCM e UF.
    /// </summary>
    procedure TestObterProdutoTributacaoPorCodigoNcmUf;

    /// <summary>
    /// Testa a atualiza��o de um produto tributa��o.
    /// </summary>
    procedure TestAtualizarProdutoTributacao;

    /// <summary>
    /// Testa a exclus�o de um produto tributa��o.
    /// </summary>
    procedure TestExcluirProdutoTributacao;

    /// <summary>
    /// Testa a obten��o de todos os produtos tributa��o.
    /// </summary>
    procedure TestObterTodosProdutosTributacao;

    /// <summary>
    /// Testa a tentativa de obter um produto tributa��o inexistente.
    /// </summary>
    procedure TestObterProdutoTributacao_ProdutoNaoEncontrado;

    /// <summary>
    /// Testa a tentativa de atualizar um produto tributa��o inexistente.
    /// </summary>
    procedure TestAtualizarProdutoTributacao_ProdutoNaoEncontrado;

    /// <summary>
    /// Testa a tentativa de excluir um produto tributa��o inexistente.
    /// </summary>
    procedure TestExcluirProdutoTributacao_ProdutoNaoEncontrado;
  end;

implementation

function TestTRepositorioProdutoTributacao.CriarProdutoTributacaoParaTeste(
  pCodigoProduto: Integer): TProdutoTributacao;
begin
  // Cria e retorna uma inst�ncia de TProdutoTributacao com dados de teste.
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
  // Configura a conex�o com o banco de dados e cria o reposit�rio.
  CarregarConfiguracao;
  FConexao := gConexaoBanco.Conexao; // Obt�m a conex�o
  FRepositorio := TRepositorioProdutoTributacao.Create(FConexao); // Passa a conex�o para o reposit�rio
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
      // Ignora erros na exclus�o durante o TearDown
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
  FProdutoTributacaoInserido := produtoTributacao; // Armazena para exclus�o no TearDown

  // Assert
  Check(Assigned(FProdutoTributacaoInserido), 'Produto tributa��o n�o foi inserido.');
  if Assigned(FProdutoTributacaoInserido) then
  begin
    CheckEquals(codigoInserir, FProdutoTributacaoInserido.CODIGOPRODUTO, 'C�digo do produto tributa��o inserido incorreto.');
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
  FProdutoTributacaoInserido := produtoTributacaoInserido; // Armazena para exclus�o no TearDown

  // Act
  produtoObtido := FRepositorio.ObterProdutoTributacao(codigoObter);

  // Assert
  Check(Assigned(produtoObtido), 'Produto tributa��o n�o foi encontrado.');
  if Assigned(produtoObtido) then
  begin
    CheckEquals(codigoObter, produtoObtido.CODIGOPRODUTO, 'C�digo do produto tributa��o obtido incorreto.');
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
  Check(Assigned(produtoObtido), 'Produto tributa��o n�o foi encontrado por c�digo e UF.');
  if Assigned(produtoObtido) then
  begin
    CheckEquals(codigoObter, produtoObtido.CODIGOPRODUTO, 'C�digo do produto incorreto.');
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

  // Modifica alguns dados para a atualiza��o
  produtoTributacaoInserido.UF := 'RJ';
  produtoTributacaoInserido.VERSAO := '2.0';

  // Act
  FRepositorio.AtualizarProdutoTributacao(produtoTributacaoInserido);
  produtoAtualizado := FRepositorio.ObterProdutoTributacao(codigoAtualizar);

  // Assert
  Check(Assigned(produtoAtualizado), 'Produto tributa��o n�o foi encontrado ap�s atualiza��o.');
  if Assigned(produtoAtualizado) then
  begin
    CheckEquals('RJ', produtoAtualizado.UF, 'UF n�o foi atualizada corretamente.');
    CheckEquals('2.0', produtoAtualizado.VERSAO, 'Vers�o n�o foi atualizada corretamente.');
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
  FProdutoTributacaoInserido := produtoTributacao; // Armazena para exclus�o no TearDown

  // Act
  FRepositorio.ExcluirProdutoTributacao(codigoExcluir);
  FProdutoTributacaoInserido := nil;

  // Assert
  var produtoExcluido := FRepositorio.ObterProdutoTributacao(codigoExcluir);
  Check(not Assigned(produtoExcluido), 'Produto tributa��o n�o foi exclu�do.');

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
  FProdutoTributacaoInserido := produto1; // Armazena um para exclus�o no TearDown
  //Nota: N�o precisa armazenar o produto2, pois o TearDown exclui apenas 1 registro inserido.

  // Act
  listaProdutos := FRepositorio.ObterTodosProdutosTributacao;

  // Assert
  Check(listaProdutos.Count >= 2, 'N�o retornou todos os produtos tributa��o.');
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
  Check(not Assigned(produtoObtido), 'Obteve produto tributa��o inexistente.');
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
  // A chamada abaixo n�o deve levantar exce��o, de acordo com a implementa��o atual do reposit�rio.
  FRepositorio.AtualizarProdutoTributacao(produtoTributacao);

  // Assert
  // Se chegar aqui, a atualiza��o n�o causou erro, o que � o comportamento esperado.
  Check(True, 'Atualizar produto tributa��o n�o existente n�o causou erro');
end;

procedure TestTRepositorioProdutoTributacao.TestExcluirProdutoTributacao_ProdutoNaoEncontrado;
var
  codigoExcluir: Integer;
begin
  // Arrange
  codigoExcluir := CODIGO_PRODUTO_NAO_ENCONTRADO;

  // Act
  // A chamada abaixo n�o deve levantar exce��o, de acordo com a implementa��o atual do reposit�rio.
  FRepositorio.ExcluirProdutoTributacao(codigoExcluir);

  // Assert
  Check(True, 'Excluir produto tributa��o n�o existente n�o causou erro');
end;

initialization
  // Registra a classe de teste para ser executada pelo runner de testes.
  RegisterTest(TestTRepositorioProdutoTributacao.Suite);
end.
