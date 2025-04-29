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
    FCodigoNCM: integer;

  public

    /// <summary>
    /// Cria uma nova instância da classe TArquivoCSVLinha.
    /// </summary>
    constructor Create; virtual;

    /// <summary>
    /// Destrói a instância da classe TArquivoCSVLinha.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Clona a classe passada por parâmetro
    /// </summary>
    /// <param name="pObjeto">TArquivoCSVLinha</param>
    procedure Clone(const pObjeto: TArquivoCSVLinha); overload;

    /// <summary>
    /// Obtém e define o código do produto.
    /// </summary>
    property CodigoNCM: integer read FCodigoNCM write FCodigoNCM;

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
    procedure AtribuirValores(const pValores: TArray<string>); virtual;
  end;

implementation

uses uConstantesGerais, uFuncoes;

{ TArquivoCSVLinha }

procedure TArquivoCSVLinha.Clone(const pObjeto: TArquivoCSVLinha);
begin
  if Assigned(pObjeto) then
  begin
    Self.FCodigoNCM := pObjeto.FCodigoNCM;
    Self.FEx := pObjeto.FEx;
    Self.FTipo := pObjeto.FTipo;
    Self.FDescricao := pObjeto.FDescricao;
    Self.FNacionalFederal := pObjeto.FNacionalFederal;
    Self.FImportadosFederal := pObjeto.FImportadosFederal;
    Self.FEstadual := pObjeto.FEstadual;
    Self.FMunicipal := pObjeto.FMunicipal;
    Self.FVigenciaInicio := pObjeto.FVigenciaInicio;
    Self.FVigenciaFim := pObjeto.FVigenciaFim;
    Self.FChave := pObjeto.FChave;
    Self.FVersao := pObjeto.FVersao;
    Self.FFonte := pObjeto.FFonte;
  end;
end;

constructor TArquivoCSVLinha.Create;
begin
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
    FCodigoNCM := StrToIntDef(pValores[INT_ZERO], INT_ZERO);
  if Length(pValores) >= INT_2 then
    FEx := StrToIntDef(pValores[INT_1], INT_ZERO);
  if Length(pValores) >= INT_3 then
    FTipo := StrToIntDef(pValores[INT_2], INT_ZERO);
  if Length(pValores) >= INT_4 then
    FDescricao := pValores[INT_3];
  if Length(pValores) >= INT_5 then
    FNacionalFederal := StringParaCurrencyDef(pValores[INT_4]);
  if Length(pValores) >= INT_6 then
    FImportadosFederal := StringParaCurrencyDef(pValores[INT_5]);
  if Length(pValores) >= INT_7 then
    FEstadual := StringParaCurrencyDef(pValores[INT_6]);
  if Length(pValores) >= INT_8 then
    FMunicipal := StringParaCurrencyDef(pValores[INT_7]);
  if Length(pValores) >= INT_9 then
    FVigenciaInicio :=  StrToDateDef(pValores[INT_8], DATETIME_VAZIO);
  if Length(pValores) >= INT_10 then
    FVigenciaFim := StrToDateDef(pValores[INT_9], DATETIME_VAZIO);
  if Length(pValores) >= INT_11 then
    FChave := pValores[INT_10];
  if Length(pValores) >= INT_12 then
    FVersao := pValores[INT_11];
  if Length(pValores) >= INT_13 then
    FFonte := pValores[INT_12];
end;

end.
