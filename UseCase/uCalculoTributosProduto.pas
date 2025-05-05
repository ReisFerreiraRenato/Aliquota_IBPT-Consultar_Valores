unit uCalculoTributosProduto;

interface

uses
  uProduto,
  uProdutoTributacao,
  uRepositorioProduto,
  uRepositorioProdutoTributacao,
  uArquivoCSVLinhaProduto,
  uArquivoCSVLinha,
  System.SysUtils,
  System.Types,
  uConexaoBanco,
  uLogErro,
  uFuncoes;

type
  /// <summary>Classe para calcular os tributos do produto</summary>
  TCalculoTributosProduto = class(TObject)
  private
    FRepositorioProduto: TRepositorioProduto;
    FRepositorioProdutoTributacao: TRepositorioProdutoTributacao;
    FConexaoBanco: TConexaoBanco;

  public
    /// <summary>Cria uma instância da classe. </summary>
    ///  <param name="pConexaoBanco" type="TConexaoBanco">Instância de TConexaoBanco para acessar o banco de dados.</param>
    constructor Create(pConexaoBanco: TConexaoBanco);

    /// <summary>Destrói a instância da classe. </summary>
    destructor Destroy; override;

    /// <summary>Calcula os valores dos tributos para um produto com base no código do produto, UF e valor. </summary>
    /// <param name="pCodigoProduto" type="Integer">Código do produto.</param>
    /// <param name="pUF" type="string">UF para calcular os tributos.</param>
    /// <param name="pValor" type="Currency">Valor do produto.</param>
    /// <returns>Um TArquivoCSVprodutoCompleto contendo as informações calculadas.</returns>
    function CalcularTributosProduto(pCodigoProduto: Integer; pUF: string; pValor: Currency): TArquivoCSVLinhaProduto;
  end;

implementation

uses
  uConstantesGerais;

constructor TCalculoTributosProduto.Create(pConexaoBanco: TConexaoBanco);
begin
  inherited Create;
  FConexaoBanco := pConexaoBanco;
  FRepositorioProduto := TRepositorioProduto.Create(FConexaoBanco);
  FRepositorioProdutoTributacao := TRepositorioProdutoTributacao.Create(FConexaoBanco.Conexao);
end;

destructor TCalculoTributosProduto.Destroy;
begin
  FRepositorioProduto.Free;
  FRepositorioProdutoTributacao.Free;
  inherited Destroy;
end;

function TCalculoTributosProduto.CalcularTributosProduto(pCodigoProduto: Integer; pUF: string; pValor: Currency): TArquivoCSVLinhaProduto;
var
  Produto: TProduto;
  ProdutoTributacao: TProdutoTributacao;
  produtoCompleto: TArquivoCSVLinhaProduto;
  valorLiquido: Currency;
begin
  produtoCompleto := TArquivoCSVLinhaProduto.Create;
  result := produtoCompleto;

  if (pValor = 0) then
  begin
    produtoCompleto.Mensagem := 'Produto com valor zerado';
    Exit;
  end;

  try
    // Busca o produto no banco de dados
    Produto := FRepositorioProduto.BuscarPorCodigo(pCodigoProduto);
    if not Assigned(Produto) then
    begin
      produtoCompleto.Mensagem := 'Produto não encontrado';
      Exit;
    end;

    // Busca a tributação do produto para a UF especificada
    ProdutoTributacao := FRepositorioProdutoTributacao.ObterProdutoTributacao(pCodigoProduto, pUF);
    if not Assigned(ProdutoTributacao) then
    begin
      produtoCompleto.Mensagem := 'Tributação não encontrada para o produto e UF informados';
      Exit;
    end;

    produtoCompleto.TributacaoEncontrada := True;

    // Popula o TArquivoCSVprodutoCompleto com os dados
    produtoCompleto.CodigoProduto := Produto.Codigo;
    produtoCompleto.Descricao := Produto.Descricao;
    produtoCompleto.CodigoNCM := StringParaInt(Produto.Ncm);
    produtoCompleto.NacionalFederal := ProdutoTributacao.TRIBNACIONALFEDERAL;
    produtoCompleto.ImportadosFederal := ProdutoTributacao.TRIBIMPORTADOSFEDERAL;
    produtoCompleto.Estadual := ProdutoTributacao.TRIBESTADUAL;
    produtoCompleto.Municipal := ProdutoTributacao.TRIBMUNICIPAL;
    produtoCompleto.VigenciaInicio := ProdutoTributacao.VIGENCIAINICIO;
    produtoCompleto.VigenciaFim := ProdutoTributacao.VIGENCIAFIM;
    produtoCompleto.Chave := ProdutoTributacao.CHAVE;
    produtoCompleto.Versao := ProdutoTributacao.VERSAO;
    produtoCompleto.Fonte := ProdutoTributacao.FONTE;
    produtoCompleto.UF := ProdutoTributacao.UF;

    // Calcula os valores dos tributos
    produtoCompleto.ValorTribNacionalFederal := pValor * (ProdutoTributacao.TRIBNACIONALFEDERAL / 100);
    produtoCompleto.ValorTribImportadosFederal := pValor * (ProdutoTributacao.TRIBIMPORTADOSFEDERAL / 100);
    produtoCompleto.ValorTribEstadual := pValor * (ProdutoTributacao.TRIBESTADUAL / 100);
    produtoCompleto.ValorTribMunicipal := pValor * (ProdutoTributacao.TRIBMUNICIPAL / 100);

    // Calcula a soma dos tributos porcentagem
    produtoCompleto.SomaTributacaoPorcentagem :=
      produtoCompleto.NacionalFederal +
      produtoCompleto.ImportadosFederal +
      produtoCompleto.Estadual +
      produtoCompleto.Municipal;

    // Calcula a soma dos tributos valor
    produtoCompleto.SomaTributacaoValor :=
      produtoCompleto.ValorTribNacionalFederal +
      produtoCompleto.ValorTribImportadosFederal +
      produtoCompleto.ValorTribEstadual +
      produtoCompleto.ValorTribMunicipal;

    // Calcula o valor líquido
    valorLiquido := pValor - produtoCompleto.SomaTributacaoValor;
    produtoCompleto.ValorLiquido := valorLiquido;

    produtoCompleto.Mensagem := String.Format(
      'Código do Produto: {0}; Descrição: {1}; NCM: {2}; UF: {3}; Valor do Produto: {4:C};' +
      ' Valor Trib. Nacional Federal: {5:C}; Valor Trib. Importados Federal: {6:C};' +
      ' Valor Trib. Estadual: {7:C}; Valor Trib. Municipal: {8:C}; Soma Tributação Valor: {9:C};' +
      ' Soma Tributação %: {10:P2}; Valor Líquido: {11:C}',
      [
        Produto.Codigo, Produto.Descricao, Produto.Ncm, ProdutoTributacao.UF, pValor,
        produtoCompleto.ValorTribNacionalFederal, produtoCompleto.ValorTribImportadosFederal,
        produtoCompleto.ValorTribEstadual, produtoCompleto.ValorTribMunicipal, produtoCompleto.SomaTributacaoValor,
        produtoCompleto.SomaTributacaoPorcentagem, valorLiquido
      ]);

  except
    on E: Exception do
    begin
      RegistrarErro('Erro ao calcular tributos: ' + E.Message);
      produtoCompleto.Mensagem := 'Erro ao calcular tributos: ' + E.Message;
    end;
  end;
end;

end.

