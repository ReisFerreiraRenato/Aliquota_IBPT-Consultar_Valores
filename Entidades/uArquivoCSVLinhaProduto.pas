unit uArquivoCSVLinhaProduto;

interface

uses
  uArquivoCSVLinha, System.SysUtils, System.Types;

type
  /// <summary>
  /// Classe para representar uma linha de dados de arquivo CSV de produto, herdando de TArquivoCSVLinha.
  /// Adiciona propriedades específicas para informações de tributação.
  /// </summary>
  TArquivoCSVLinhaProduto = class(TArquivoCSVLinha)
  private
    FCodigoProduto: Integer;
    FMensagem: string;
    FSomaTributacaoValor: Currency;
    FSomaTributacaoPorcentagem: Currency;
    FTributacaoEncontrada: Boolean;
    FUF: string;
    FValorLiquido: Currency;
    FValorTribNacionalFederal: Currency;
    FValorTribImportadosFederal: Currency;
    FValorTribEstadual: Currency;
    FValorTribMunicipal: Currency;
  public
    /// <summary>Cria uma nova instância da classe TArquivoCSVLinhaProduto. </summary>
    constructor Create; override;

    /// <summary>Destrói a instância da classe TArquivoCSVLinhaProduto. </summary>
    destructor Destroy; override;

    /// <summary>Atribui os valores das propriedades da linha a partir de um array de strings. Sobrescreve o método da classe base para incluir as novas propriedades.</summary>
    /// <param name="pValores">Array de strings contendo os valores da linha.</param>
    procedure AtribuirValores(const pValores: TArray<string>); override;

    /// <summary>Clona a classe passada por parâmetro</summary>
    /// <param name="pObjeto">TArquivoCSVLinhaProduto</param>
    procedure Clone(const pObjeto: TArquivoCSVLinhaProduto); overload;

    /// <summary>Obtém e define o ID do produto. </summary>
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;

    /// <summary>Obtém e define a UF. </summary>
    property UF: string read FUF write FUF;

    /// <summary>Obtém e define a soma da tributação em valor. </summary>
    property SomaTributacaoValor: Currency read FSomaTributacaoValor write FSomaTributacaoValor;

    /// <summary>Obtém e define a soma da tributação em porcentagem. </summary>
    property SomaTributacaoPorcentagem: Currency read FSomaTributacaoPorcentagem write FSomaTributacaoPorcentagem;

    /// <summary>Obtém e define o valor tributário nacional federal. </summary>
    property ValorTribNacionalFederal: Currency read FValorTribNacionalFederal write FValorTribNacionalFederal;

    /// <summary>Obtém e define o valor tributário de importados federal. </summary>
    property ValorTribImportadosFederal: Currency read FValorTribImportadosFederal write FValorTribImportadosFederal;

    /// <summary>Obtém e define o valor tributário estadual. </summary>
    property ValorTribEstadual: Currency read FValorTribEstadual write FValorTribEstadual;

    /// <summary>Obtém e define o valor tributário municipal. </summary>
    property ValorTribMunicipal: Currency read FValorTribMunicipal write FValorTribMunicipal;

    /// <summary>Obtém e define o valor líquido do produto. </summary>
    property ValorLiquido: Currency read FValorLiquido write FValorLiquido;

    /// <summary>Obtém e define a mensagem. </summary>
    property Mensagem: string read FMensagem write FMensagem;

    /// <summary>Obtém e define se a tributacao foi encontrada. </summary>
    property TributacaoEncontrada: Boolean read FTributacaoEncontrada write FTributacaoEncontrada;
  end;

implementation

uses uConstantesGerais;

procedure TArquivoCSVLinhaProduto.Clone(const pObjeto: TArquivoCSVLinhaProduto);
begin
  if Assigned(pObjeto) then
  begin
    Self.CodigoNCM := pObjeto.CodigoNCM;
    Self.Ex := pObjeto.Ex;
    Self.Tipo := pObjeto.Tipo;
    Self.Descricao := pObjeto.Descricao;
    Self.NacionalFederal := pObjeto.NacionalFederal;
    Self.ImportadosFederal := pObjeto.ImportadosFederal;
    Self.Estadual := pObjeto.Estadual;
    Self.Municipal := pObjeto.Municipal;
    Self.VigenciaInicio := pObjeto.VigenciaInicio;
    Self.VigenciaFim := pObjeto.VigenciaFim;
    Self.Chave := pObjeto.Chave;
    Self.Versao := pObjeto.Versao;
    Self.Fonte := pObjeto.Fonte;
    Self.CodigoProduto := pObjeto.CodigoProduto;
    Self.CodigoProduto := pObjeto.CodigoProduto;
    Self.UF := pObjeto.UF;
    Self.SomaTributacaoValor := pObjeto.SomaTributacaoValor;
    Self.SomaTributacaoPorcentagem := pObjeto.SomaTributacaoPorcentagem;
    Self.ValorLiquido := pObjeto.ValorLiquido;
    Self.ValorTribNacionalFederal := pObjeto.ValorTribNacionalFederal;
    Self.ValorTribImportadosFederal := pObjeto.ValorTribImportadosFederal;
    Self.ValorTribEstadual := pObjeto.ValorTribEstadual;
    Self.ValorTribMunicipal := pObjeto.ValorTribMunicipal;
    Self.Mensagem := pObjeto.Mensagem;
    Self.TributacaoEncontrada := pObjeto.TributacaoEncontrada;
  end;
end;

constructor TArquivoCSVLinhaProduto.Create;
begin
  inherited Create;
  FCodigoProduto := INT_ZERO;
  FUF := STRING_VAZIO;
  FSomaTributacaoValor := CURRENCY_ZERO;
  FSomaTributacaoPorcentagem := CURRENCY_ZERO;
  FValorTribNacionalFederal := CURRENCY_ZERO;
  FValorTribImportadosFederal := CURRENCY_ZERO;
  FValorTribEstadual := CURRENCY_ZERO;
  FValorTribMunicipal := CURRENCY_ZERO;
  FValorLiquido := CURRENCY_ZERO;
  FMensagem := STRING_VAZIO;
  FTributacaoEncontrada := False;
end;

destructor TArquivoCSVLinhaProduto.Destroy;
begin
  inherited Destroy;
end;

procedure TArquivoCSVLinhaProduto.AtribuirValores(const pValores: TArray<string>);
begin
  inherited AtribuirValores(pValores);

  if Length(pValores) >= 14 then
    FCodigoProduto := StrToIntDef(pValores[13], INT_ZERO);
  if Length(pValores) >= 15 then
    FUF := pValores[14];
  if Length(pValores) >= 16 then
    FSomaTributacaoValor := StrToCurrDef(pValores[15], CURRENCY_ZERO);
  if Length(pValores) >= 17 then
    FSomaTributacaoPorcentagem := StrToCurrDef(pValores[16], CURRENCY_ZERO);
  if Length(pValores) >= 18 then
    FValorTribNacionalFederal := StrToCurrDef(pValores[17], CURRENCY_ZERO);
  if Length(pValores) >= 19 then
    FValorTribImportadosFederal := StrToCurrDef(pValores[18], CURRENCY_ZERO);
  if Length(pValores) >= 20 then
    FValorTribEstadual := StrToCurrDef(pValores[19], CURRENCY_ZERO);
  if Length(pValores) >= 21 then
    FValorTribMunicipal := StrToCurrDef(pValores[20], CURRENCY_ZERO);
  if Length(pValores) >= 22 then
    FValorLiquido := StrToCurrDef(pValores[21], CURRENCY_ZERO);
  if Length(pValores) >= 23 then
    FMensagem := pValores[22];
  if Length(pValores) >= 24 then
    FTributacaoEncontrada := StrToBool(pValores[23]);
end;

end.
