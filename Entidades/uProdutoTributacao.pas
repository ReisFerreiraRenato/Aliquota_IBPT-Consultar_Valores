unit uProdutoTributacao;

interface

type

  /// <summary>
  /// Classe que representa os dados de tributa��o de um produto.
  /// Mapeia os campos da tabela PRODUTOTRIBUTACAO.
  /// </summary>
  TProdutoTributacao = class
  private
    FUf: string;
    FCodigoProduto: Integer;
    FEx: Integer;
    FTipo: Integer;
    FTribNacionalFederal: Currency;
    FTribImportadosFederal: Currency;
    FTribEstadual: Currency;
    FTribMunicipal: Currency;
    FVigenciaInicio: TDateTime;
    FVigenciaFim: TDateTime;
    FChave: string;
    FVersao: string;
    FFonte: string;

  public
    /// <summary>Construtor da classe TProdutoTributacao. Inicializa os campos com valores padr�o. </summary>
    constructor Create;

    /// <summary>Destrutor da classe TProdutoTributacao. Libera os recursos da classe. </summary>
    destructor Destroy; override;

    /// <summary>Obt�m e define a UF do produto. </summary>
    property UF: string read FUf write FUf;

    /// <summary>Obt�m e define o c�digo do produto (chave estrangeira). </summary>
    property CodigoProduto: Integer read FCodigoProduto write FCodigoProduto;

    /// <summary>Obt�m e define o EX do produto. </summary>
    property Ex: Integer read FEx write FEx;

    /// <summary>Obt�m e define o tipo do produto. </summary>
    property Tipo: Integer read FTipo write FTipo;

    /// <summary>Obt�m e define o valor da tributa��o nacional federal. </summary>
    property TribNacionalFederal: Currency read FTribNacionalFederal write FTribNacionalFederal;

    /// <summary>Obt�m e define o valor da tributa��o de importados federal. </summary>
    property TribImportadosFederal: Currency read FTribImportadosFederal write FTribImportadosFederal;

    /// <summary>Obt�m e define o valor da tributa��o estadual. </summary>
    property TribEstadual: Currency read FTribEstadual write FTribEstadual;

    /// <summary>Obt�m e define o valor da tributa��o municipal. </summary>
    property TribMunicipal: Currency read FTribMunicipal write FTribMunicipal;

    /// <summary>Obt�m e define a data de in�cio da vig�ncia da tributa��o. </summary>
    property VigenciaInicio: TDateTime read FVigenciaInicio write FVigenciaInicio;

    /// <summary>Obt�m e define a data de fim da vig�ncia da tributa��o. </summary>
    property VigenciaFim: TDateTime read FVigenciaFim write FVigenciaFim;

    /// <summary>Obt�m e define a chave da tributa��o. </summary>
    property Chave: string read FChave write FChave;

    /// <summary>Obt�m e define a vers�o da tributa��o. </summary>
    property Versao: string read FVersao write FVersao;

    /// <summary>Obt�m e define a fonte da tributa��o. </summary>
    property Fonte: string read FFonte write FFonte;

  end;

implementation

{ TProdutoTributacao }

uses uConstantesGerais;

constructor TProdutoTributacao.Create;
begin
  inherited;
  FUf := STRING_VAZIO;
  FCodigoProduto := INT_ZERO;
  FEx := INT_ZERO;
  FTipo := INT_ZERO;
  FTribNacionalFederal := CURRENCY_VAZIO;
  FTribImportadosFederal := CURRENCY_VAZIO;
  FTribEstadual := CURRENCY_VAZIO;
  FTribMunicipal := CURRENCY_VAZIO;
  FVigenciaInicio := DATETIME_VAZIO;
  FVigenciaFim := DATETIME_VAZIO;
  FChave := STRING_VAZIO;
  FVersao := STRING_VAZIO;
  FFonte := STRING_VAZIO;
end;

destructor TProdutoTributacao.Destroy;
begin
  inherited;
end;

end.
