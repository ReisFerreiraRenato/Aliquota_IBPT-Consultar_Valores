unit uArquivoCSVLinha;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Types,
  System.Classes;

type
  /// <summary>
  /// Classe para representar uma linha de dados do arquivo CSV.
  /// Esta classe mapeia diretamente as colunas do CSV para propriedades.
  /// </summary>
  TArquivoCSVLinha = class
  private
    FIdLinha: Integer;
    FCodigoNCM: Integer;
    FEx: Integer;
    FTipo: Integer;
    FDescricao: string;
    FNacionalFederal: Currency;
    FImportadosFederal: Currency;
    FEstadual: Currency;
    FMunicipal: Currency;
    FVigenciaInicio: TDateTime;
    FVigenciaFim: TDateTime;
    FChave: string;
    FVersao: string;
    FFonte: string;
  public
    /// <summary>
    /// Cria uma nova instância da classe TArquivoCSVLinha.
    /// </summary>
    constructor Create;
    /// <summary>
    /// Destrói a instância da classe TArquivoCSVLinha.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Obtém e define o id produto.
    /// </summary>
    property ID: Integer read FIdLinha write FIdLinha;

    /// <summary>
    /// Obtém e define o código do produto.
    /// </summary>
    property CodigoNCM: Integer read FCodigoNCM write FCodigoNCM;
    /// <summary>
    /// Obtém e define o EX do produto.
    /// </summary>
    property Ex: Integer read FEx write FEx;
    /// <summary>
    /// Obtém e define o tipo do produto.
    /// </summary>
    property Tipo: Integer read FTipo write FTipo;
    /// <summary>
    /// Obtém e define a descrição do produto.
    /// </summary>
    property Descricao: string read FDescricao write FDescricao;
    /// <summary>
    /// Obtém e define o valor nacional/federal do produto.
    /// </summary>
    property NacionalFederal: Currency read FNacionalFederal write FNacionalFederal;
    /// <summary>
    /// Obtém e define o valor importados federal do produto.
    /// </summary>
    property ImportadosFederal: Currency read FImportadosFederal write FImportadosFederal;
    /// <summary>
    /// Obtém e define o valor estadual do produto.
    /// </summary>
    property Estadual: Currency read FEstadual write FEstadual;
    /// <summary>
    /// Obtém e define o valor municipal do produto.
    /// </summary>
    property Municipal: Currency read FMunicipal write FMunicipal;
      /// <summary>
    /// Obtém e define a data de início da vigência.
    /// </summary>
    property VigenciaInicio: TDateTime read FVigenciaInicio write FVigenciaInicio;
    /// <summary>
    /// Obtém e define a data de fim da vigência.
    /// </summary>
    property VigenciaFim: TDateTime read FVigenciaFim write FVigenciaFim;
    /// <summary>
    /// Obtém e define a chave do produto.
    /// </summary>
    property Chave: string read FChave write FChave;
    /// <summary>
    /// Obtém e define a versão do produto.
    /// </summary>
    property Versao: string read FVersao write FVersao;
    /// <summary>
    /// Obtém e define a fonte do produto.
    /// </summary>
    property Fonte: string read FFonte write FFonte;

    /// <summary>
    /// Atribui os valores das propriedades da linha a partir de um array de strings.
    /// </summary>
    /// <param name="Valores">Array de strings contendo os valores da linha.</param>
    procedure AtribuirValores(const pValores: TArray<string>);
  end;

implementation

uses uConstantesGerais;

{ TArquivoCSVLinha }

constructor TArquivoCSVLinha.Create;
begin
  FIdLinha := INT_ZERO;
  FCodigoNCM := INT_ZERO;
  FEx := INT_ZERO;
  FTipo := INT_ZERO;
  FDescricao := STRING_VAZIO;
  FNacionalFederal := CURRENCY_ZERO;
  FImportadosFederal := CURRENCY_ZERO;
  FEstadual := CURRENCY_ZERO;
  FMunicipal := CURRENCY_ZERO;
  FVigenciaInicio := DATETIME_VAZIO;
  FVigenciaFim := DATETIME_VAZIO;
  FChave := STRING_VAZIO;
  FVersao := STRING_VAZIO;
  FFonte := STRING_VAZIO;
end;

destructor TArquivoCSVLinha.Destroy;
begin
  inherited;
end;

procedure TArquivoCSVLinha.AtribuirValores(const pValores: TArray<string>);
begin
  if Length(pValores) >= INT_1 then
    FIdLinha := StrToIntDef(pValores[INT_ZERO], INT_ZERO);
  if Length(pValores) >= INT_2 then
    FCodigoNCM := StrToIntDef(pValores[INT_1], INT_ZERO);
  if Length(pValores) >= INT_3 then
    FEx := StrToIntDef(pValores[INT_2], INT_ZERO);
  if Length(pValores) >= INT_4 then
    FTipo := StrToIntDef(pValores[INT_3], INT_ZERO);
  if Length(pValores) >= INT_5 then
    FDescricao := pValores[INT_4];
  if Length(pValores) >= INT_6 then
    FNacionalFederal := StrToCurrDef(pValores[INT_5], CURRENCY_ZERO);
  if Length(pValores) >= INT_7 then
    FImportadosFederal := StrToCurrDef(pValores[INT_6], CURRENCY_ZERO);
  if Length(pValores) >= INT_8 then
    FEstadual := StrToCurrDef(pValores[INT_7], CURRENCY_ZERO);
  if Length(pValores) >= INT_9 then
    FMunicipal := StrToCurrDef(pValores[INT_8], CURRENCY_ZERO);
  if Length(pValores) >= INT_10 then
    FVigenciaInicio :=  StrToDateDef(pValores[9], DATETIME_VAZIO);
  if Length(pValores) >= INT_11 then
    FVigenciaFim := StrToDateDef(pValores[10], DATETIME_VAZIO);
  if Length(pValores) >= INT_12 then
    FChave := pValores[INT_11];
  if Length(pValores) >= INT_13 then
    FVersao := pValores[INT_12];
  if Length(pValores) >= INT_14 then
    FFonte := pValores[INT_13];
end;

end.
