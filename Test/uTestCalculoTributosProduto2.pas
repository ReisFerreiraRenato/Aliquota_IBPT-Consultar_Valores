unit uTestCalculoTributosProduto2;

interface

uses
  TestFramework, uCalculoTributosProduto, uProduto, uProdutoTributacao,
  uRepositorioProduto, uRepositorioProdutoTributacao, uConexaoBanco,
  System.SysUtils, System.Types, Classes, Variants, uConfiguracao,
  uVariaveisGlobais;

type
  // Classe de teste para TCalculoTributosProduto
  TesteCalculoTributosProduto = class(TTestCase)
  private
    FCalculoTributosProduto: TCalculoTributosProduto;
    FConexaoBanco: TConexaoBanco;
    FRepositorioProduto: TRepositorioProduto;
    FRepositorioProdutoTributacao: TRepositorioProdutoTributacao;
    ListaDeProdutos: TList;
    ListaDeTributacoes: TList;
  protected
    /// <summary>
    /// M�todo executado antes de cada teste.
    /// </summary>
    procedure SetUp; override;
    /// <summary>
    /// M�todo executado ap�s cada teste.
    /// </summary>
    procedure TearDown; override;
  public
    /// <summary>
    /// M�todo de teste para cen�rio de sucesso.
    /// </summary>
    procedure TestCalcularTributosProduto_Sucesso;
    /// <summary>
    /// M�todo de teste para produto n�o encontrado.
    /// </summary>
    procedure TestCalcularTributosProduto_ProdutoNaoEncontrado;
    /// <summary>
    /// M�todo de teste para tributa��o n�o encontrada.
    /// </summary>
    procedure TestCalcularTributosProduto_TributacaoNaoEncontrada;
    /// <summary>
    /// M�todo de teste para valor do produto igual a zero.
    /// </summary>
    procedure TestCalcularTributosProduto_ValorZero;
     /// <summary>
    /// M�todo de teste para NCM inv�lido.
    /// </summary>
    procedure TestCalcularTributosProduto_NCMInvalido;
  end;

implementation

uses
  uArquivoCSVLinhaProduto, uConstantesGerais, uLogErro; // Adicionado uConstantesGerais e uLogErro

// M�todo executado antes de cada teste
procedure TesteCalculoTributosProduto.SetUp;
var
  Produto: TProduto;
  ProdutoTributacao: TProdutoTributacao;
begin
  // Carrega a configura��o do banco de dados
  CarregarConfiguracao;
  FConexaoBanco := gConexaoBanco; // Usa a conex�o global configurada

  // Cria inst�ncias dos reposit�rios
  FRepositorioProduto := TRepositorioProduto.Create(FConexaoBanco);
  FRepositorioProdutoTributacao := TRepositorioProdutoTributacao.Create(FConexaoBanco.Conexao);

  // Cria inst�ncia da classe a ser testada
  FCalculoTributosProduto := TCalculoTributosProduto.Create(FConexaoBanco);

  // Popula o banco de dados com dados de teste (use TList para facilitar a limpeza)
  ListaDeProdutos := TList.Create;
  ListaDeTributacoes := TList.Create;

  // Produto 1
  Produto := TProduto.Create;
  Produto.Codigo := 1;
  Produto.Descricao := 'Produto Teste 1';
  Produto.Ncm := '12345678';
  FRepositorioProduto.Inserir(Produto);
  ListaDeProdutos.Add(Produto);

  // Produto 2
  Produto := TProduto.Create;
  Produto.Codigo := 2;
  Produto.Descricao := 'Produto Teste 2';
  Produto.Ncm := '98765432';
  FRepositorioProduto.Inserir(Produto);
  ListaDeProdutos.Add(Produto);

  // Tributa��o para o Produto 1 em SP
  ProdutoTributacao := TProdutoTributacao.Create;
  ProdutoTributacao.CODIGOPRODUTO := 1;
  ProdutoTributacao.UF := 'SP';
  ProdutoTributacao.TRIBNACIONALFEDERAL := 10.0;
  ProdutoTributacao.TRIBIMPORTADOSFEDERAL := 5.0;
  ProdutoTributacao.TRIBESTADUAL := 2.0;
  ProdutoTributacao.TRIBMUNICIPAL := 1.0;
  ProdutoTributacao.VIGENCIAINICIO := EncodeDate(2024, 1, 1);
  ProdutoTributacao.VIGENCIAFIM := EncodeDate(2024, 12, 31);
  ProdutoTributacao.CHAVE := 'CHAVE123';
  ProdutoTributacao.VERSAO := '1.0';
  ProdutoTributacao.FONTE := 'Fonte Teste';
  FRepositorioProdutoTributacao.InserirProdutoTributacao(ProdutoTributacao);
  ListaDeTributacoes.Add(ProdutoTributacao);

  // Tributa��o para o Produto 2 em RJ
  ProdutoTributacao := TProdutoTributacao.Create;
  ProdutoTributacao.CODIGOPRODUTO := 2;
  ProdutoTributacao.UF := 'RJ';
  ProdutoTributacao.TRIBNACIONALFEDERAL := 8.0;
  ProdutoTributacao.TRIBIMPORTADOSFEDERAL := 3.0;
  ProdutoTributacao.TRIBESTADUAL := 4.0;
  ProdutoTributacao.TRIBMUNICIPAL := 2.0;
  ProdutoTributacao.VIGENCIAINICIO := EncodeDate(2024, 1, 1);
  ProdutoTributacao.VIGENCIAFim := EncodeDate(2024, 12, 31);
  ProdutoTributacao.CHAVE := 'CHAVE456';
  ProdutoTributacao.VERSAO := '1.0';
  ProdutoTributacao.FONTE := 'Fonte Teste';
  FRepositorioProdutoTributacao.InserirProdutoTributacao(ProdutoTributacao);
  ListaDeTributacoes.Add(ProdutoTributacao);
end;

// M�todo executado ap�s cada teste
procedure TesteCalculoTributosProduto.TearDown;
var
  Produto: TProduto;
  ProdutoTributacao: TProdutoTributacao;
begin
  // Limpa o banco de dados (remove os dados de teste)
  for Produto in ListaDeProdutos do
    FRepositorioProduto.Excluir(Produto.Codigo);
  ListaDeProdutos.Free;

  for ProdutoTributacao in ListaDeTributacoes do
    FRepositorioProdutoTributacao.ExcluirProdutoTributacao(ProdutoTributacao.CODIGOPRODUTO);
  ListaDeTributacoes.Free;

  // Libera as inst�ncias
  FCalculoTributosProduto.Free;
  FRepositorioProduto.Free;
  FRepositorioProdutoTributacao.Free;
  // A conex�o com o banco � global e ser� liberada em outro lugar, n�o aqui.
  // FConexaoBanco.Free;
end;

// M�todo de teste para cen�rio de sucesso
procedure TesteCalculoTributosProduto.TestCalcularTributosProduto_Sucesso;
var
  Resultado: TArquivoCSVLinhaProduto;
  ValorProduto: Currency;
begin
  ValorProduto := 100.00;
  Resultado := FCalculoTributosProduto.CalcularTributosProduto(1, 'SP', ValorProduto);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(VarIsEmpty(Resultado.Mensagem), 'A mensagem deve estar vazia em caso de sucesso.');
  Check(Resultado.CodigoProduto = 1, 'C�digo do produto incorreto.');
  Check(Resultado.Descricao = 'Produto Teste 1', 'Descri��o do produto incorreta.');
  Check(Resultado.CodigoNCM = 12345678, 'C�digo NCM incorreto.');
  Check(Resultado.UF = 'SP', 'UF incorreta.');
  Check(Resultado.ValorTribNacionalFederal = 10.00, 'Valor do tributo nacional federal incorreto.');
  Check(Resultado.ValorTribImportadosFederal = 5.00, 'Valor do tributo de importados federal incorreto.');
  Check(Resultado.ValorTribEstadual = 2.00, 'Valor do tributo estadual incorreto.');
  Check(Resultado.ValorTribMunicipal = 1.00, 'Valor do tributo municipal incorreto.');
  Check(Resultado.SomaTributacaoValor = 18.00, 'Soma da tributa��o incorreta.');
  Check(Resultado.ValorLiquido = 82.00, 'Valor l�quido incorreto.');
  Resultado.Free;

  ValorProduto := 200;
  Resultado := FCalculoTributosProduto.CalcularTributosProduto(2, 'RJ', ValorProduto);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(VarIsEmpty(Resultado.Mensagem), 'A mensagem deve estar vazia em caso de sucesso.');
  Check(Resultado.CodigoProduto = 2, 'C�digo do produto incorreto.');
  Check(Resultado.Descricao = 'Produto Teste 2', 'Descri��o do produto incorreta.');
  Check(Resultado.CodigoNCM = 98765432, 'C�digo NCM incorreto.');
  Check(Resultado.UF = 'RJ', 'UF incorreta.');
  Check(Resultado.ValorTribNacionalFederal = 16.00, 'Valor do tributo nacional federal incorreto.');
  Check(Resultado.ValorTribImportadosFederal = 6.00, 'Valor do tributo de importados federal incorreto.');
  Check(Resultado.ValorTribEstadual = 8.00, 'Valor do tributo estadual incorreto.');
  Check(Resultado.ValorTribMunicipal = 4.00, 'Valor do tributo municipal incorreto.');
  Check(Resultado.SomaTributacaoValor = 34.00, 'Soma da tributa��o incorreta.');
  Check(Resultado.ValorLiquido = 166.00, 'Valor l�quido incorreto.');
  Resultado.Free;
end;

// M�todo de teste para produto n�o encontrado
procedure TesteCalculoTributosProduto.TestCalcularTributosProduto_ProdutoNaoEncontrado;
var
  Resultado: TArquivoCSVLinhaProduto;
begin
  Resultado := FCalculoTributosProduto.CalcularTributosProduto(999, 'SP', 100.00);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(not VarIsEmpty(Resultado.Mensagem), 'A mensagem n�o deve estar vazia.');
  Check(Resultado.Mensagem = 'Produto n�o encontrado', 'Mensagem de erro incorreta.');
  Resultado.Free;
end;

// M�todo de teste para tributa��o n�o encontrada
procedure TesteCalculoTributosProduto.TestCalcularTributosProduto_TributacaoNaoEncontrada;
var
  Resultado: TArquivoCSVLinhaProduto;
begin
  Resultado := FCalculoTributosProduto.CalcularTributosProduto(1, 'RJ', 100.00);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(not VarIsEmpty(Resultado.Mensagem), 'A mensagem n�o deve estar vazia.');
  Check(Resultado.Mensagem = 'Tributa��o n�o encontrada para o produto e UF informados', 'Mensagem de erro incorreta.');
  Resultado.Free;
end;

// M�todo de teste para valor do produto igual a zero
procedure TesteCalculoTributosProduto.TestCalcularTributosProduto_ValorZero;
var
  Resultado: TArquivoCSVLinhaProduto;
begin
  Resultado := FCalculoTributosProduto.CalcularTributosProduto(1, 'SP', 0.00);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(VarIsEmpty(Resultado.Mensagem), 'A mensagem deve estar vazia.');
  Check(Resultado.ValorLiquido = 0.00, 'Valor l�quido incorreto para valor zero.');
  Check(Resultado.SomaTributacaoPorcentagem = 0, 'Porcentagem de tributa��o incorreta para valor zero');
  Resultado.Free;
end;

procedure TesteCalculoTributosProduto.TestCalcularTributosProduto_NCMInvalido;
var
  Resultado: TArquivoCSVLinhaProduto;
  Produto: TProduto;
begin
   // Altera o NCM do produto 1 para um valor inv�lido
  Produto := FRepositorioProduto.BuscarPorCodigo(1);
  Produto.Ncm := 'ABCDEFGH';
  FRepositorioProduto.Atualizar(Produto);

  Resultado := FCalculoTributosProduto.CalcularTributosProduto(1, 'SP', 100.00);
  Check(Assigned(Resultado), 'O resultado n�o deve ser nulo.');
  Check(not VarIsEmpty(Resultado.Mensagem), 'A mensagem n�o deve estar vazia.');
  Check(Resultado.Mensagem = 'NCM do produto inv�lido: ABCDEFGH', 'Mensagem de erro incorreta para NCM inv�lido.');
  Resultado.Free;

  // Restaura o NCM para um valor v�lido para n�o afetar outros testes
  Produto := FRepositorioProduto.BuscarPorCodigo(1);
  Produto.Ncm := '12345678';
  FRepositorioProduto.Atualizar(Produto);
end;

// Registra a classe de teste para ser executada
initialization
  RegisterTest(TesteCalculoTributosProduto.Suite);
end.

