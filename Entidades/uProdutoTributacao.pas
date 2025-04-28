unit uProdutoTributacao;

interface

type

  /// <summary>
  /// Classe que representa os dados de tributa��o de um produto.
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
    /// Inicializa os campos com valores padr�o.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Destrutor da classe TProdutoTributacao.
    /// Libera os recursos da classe.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Obt�m e define a UF do produto.
    /// </summary>
    property UF: string read cUF write cUF;

    /// <summary>
    /// Obt�m e define o c�digo do produto (chave estrangeira).
    /// </summary>
    property CODIGOPRODUTO: Integer read cCODIGOPRODUTO write cCODIGOPRODUTO;

    /// <summary>
    /// Obt�m e define o EX do produto.
    /// </summary>
    property EX: Integer read cEX write cEX;

    /// <summary>
    /// Obt�m e define o tipo do produto.
    /// </summary>
    property TIPO: Integer read cTIPO write cTIPO;

    /// <summary>
    /// Obt�m e define o valor da tributa��o nacional federal.
    /// </summary>
    property TRIBNACIONALFEDERAL: Currency read cTRIBNACIONALFEDERAL write cTRIBNACIONALFEDERAL;

    /// <summary>
    /// Obt�m e define o valor da tributa��o de importados federal.
    /// </summary>
    property TRIBIMPORTADOSFEDERAL: Currency read cTRIBIMPORTADOSFEDERAL write cTRIBIMPORTADOSFEDERAL;

    /// <summary>
    /// Obt�m e define o valor da tributa��o estadual.
    /// </summary>
    property TRIBESTADUAL: Currency read cTRIBESTADUAL write cTRIBESTADUAL;

    /// <summary>
    /// Obt�m e define o valor da tributa��o municipal.
    /// </summary>
    property TRIBMUNICIPAL: Currency read cTRIBMUNICIPAL write cTRIBMUNICIPAL;

    /// <summary>
    /// Obt�m e define a data de in�cio da vig�ncia da tributa��o.
    /// </summary>
    property VIGENCIAINICIO: TDateTime read cVIGENCIAINICIO write cVIGENCIAINICIO;

    /// <summary>
    /// Obt�m e define a data de fim da vig�ncia da tributa��o.
    /// </summary>
    property VIGENCIAFIM: TDateTime read cVIGENCIAFIM write cVIGENCIAFIM;

    /// <summary>
    /// Obt�m e define a chave da tributa��o.
    /// </summary>
    property CHAVE: string read cCHAVE write cCHAVE;

    /// <summary>
    /// Obt�m e define a vers�o da tributa��o.
    /// </summary>
    property VERSAO: string read cVERSAO write cVERSAO;

    /// <summary>
    /// Obt�m e define a fonte da tributa��o.
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
