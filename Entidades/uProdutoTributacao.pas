unit uProdutoTributacao;

interface

type

  /// <summary>
  /// Classe que representa os dados de tributação de um produto.
  /// Mapeia os campos da tabela PRODUTOTRIBUTACAO.
  /// </summary>
  TProdutoTributacao = class
  private
    cUF: string;
    cCODIGOPRODUTO: Integer;
    cEX: Integer;
    cTIPO: Integer;
    cTRIBNACIONALFEDERAL: Currency;
    cTRIBIMPORTADOSFEDERAL: Currency;
    cTRIBESTADUAL: Currency;
    cTRIBMUNICIPAL: Currency;
    cVIGENCIAINICIO: TDateTime;
    cVIGENCIAFIM: TDateTime;
    cCHAVE: string;
    cVERSAO: string;
    cFONTE: string;

  public
    /// <summary>
    /// Construtor da classe TProdutoTributacao.
    /// Inicializa os campos com valores padrão.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Destrutor da classe TProdutoTributacao.
    /// Libera os recursos da classe.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Obtém e define a UF do produto.
    /// </summary>
    property UF: string read cUF write cUF;

    /// <summary>
    /// Obtém e define o código do produto (chave estrangeira).
    /// </summary>
    property CODIGOPRODUTO: Integer read cCODIGOPRODUTO write cCODIGOPRODUTO;

    /// <summary>
    /// Obtém e define o EX do produto.
    /// </summary>
    property EX: Integer read cEX write cEX;

    /// <summary>
    /// Obtém e define o tipo do produto.
    /// </summary>
    property TIPO: Integer read cTIPO write cTIPO;

    /// <summary>
    /// Obtém e define o valor da tributação nacional federal.
    /// </summary>
    property TRIBNACIONALFEDERAL: Currency read cTRIBNACIONALFEDERAL write cTRIBNACIONALFEDERAL;

    /// <summary>
    /// Obtém e define o valor da tributação de importados federal.
    /// </summary>
    property TRIBIMPORTADOSFEDERAL: Currency read cTRIBIMPORTADOSFEDERAL write cTRIBIMPORTADOSFEDERAL;

    /// <summary>
    /// Obtém e define o valor da tributação estadual.
    /// </summary>
    property TRIBESTADUAL: Currency read cTRIBESTADUAL write cTRIBESTADUAL;

    /// <summary>
    /// Obtém e define o valor da tributação municipal.
    /// </summary>
    property TRIBMUNICIPAL: Currency read cTRIBMUNICIPAL write cTRIBMUNICIPAL;

    /// <summary>
    /// Obtém e define a data de início da vigência da tributação.
    /// </summary>
    property VIGENCIAINICIO: TDateTime read cVIGENCIAINICIO write cVIGENCIAINICIO;

    /// <summary>
    /// Obtém e define a data de fim da vigência da tributação.
    /// </summary>
    property VIGENCIAFIM: TDateTime read cVIGENCIAFIM write cVIGENCIAFIM;

    /// <summary>
    /// Obtém e define a chave da tributação.
    /// </summary>
    property CHAVE: string read cCHAVE write cCHAVE;

    /// <summary>
    /// Obtém e define a versão da tributação.
    /// </summary>
    property VERSAO: string read cVERSAO write cVERSAO;

    /// <summary>
    /// Obtém e define a fonte da tributação.
    /// </summary>
    property FONTE: string read cFONTE write cFONTE;

  end;

implementation

{ TProdutoTributacao }

uses uConstantesGerais;

constructor TProdutoTributacao.Create;
begin
  inherited;
  cUF := STRING_VAZIO;
  cCODIGOPRODUTO := INT_ZERO;
  cEX := INT_ZERO;
  cTIPO := INT_ZERO;
  cTRIBNACIONALFEDERAL := CURRENCY_VAZIO;
  cTRIBIMPORTADOSFEDERAL := CURRENCY_VAZIO;
  cTRIBESTADUAL := CURRENCY_VAZIO;
  cTRIBMUNICIPAL := CURRENCY_VAZIO;
  cVIGENCIAINICIO := DATETIME_VAZIO;
  cVIGENCIAFIM := DATETIME_VAZIO;
  cCHAVE := STRING_VAZIO;
  cVERSAO := STRING_VAZIO;
  cFONTE := STRING_VAZIO;
end;

destructor TProdutoTributacao.Destroy;
begin
  inherited;
end;

end.
