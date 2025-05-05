/// <summary>
/// unit con funcoes uteis utilizadas no software
/// </summary>

unit uFuncoes;

interface

uses
  System.SysUtils,
  uConstantesGerais,
  uConstantesBaseDados,
  uLogErro,
  FireDAC.Stan.Error;

  /// <summary>Funcao para adicionar % antes e depois da string</summary>
  /// <param name="pValor" type="string">String para ser concatendada com %</param>
  /// <Returns>Type="string" - string adicionada % antes e depois da mesma</returns>
  function ConcatenaBuscaLiteralString(pValor: string): string;

  /// <summary>Funcao IntParaStr para converter com tratamento de erro </summary>
  /// <param name="pValor" type="TArray<string>">Vetor TArray<string></param>
  /// <returns>Type="string" - Todas as strings passadas por parâmetro concatenadas</returns>
  function ConcatenaStrings(const pValores: TArray<string>): string;

  /// <summary>Funcao IfThen para testar condicao</summary>
  /// <param name="pCondicao" type="Boolean">Condição</param>
  /// <param name="pTrue" type="TEncoding">TEncoding em caso de True</param>
  /// <param name="pFalse" type="TEncoding">TEncoding em caso de False</param>
  /// <returns>Type="TEncoding" </returns>
  function IfThen(pCondicao: Boolean; pTrue: TEncoding; pFalse: TEncoding): TEncoding;

  /// <summary>Funcao IntParaStr para converter com tratamento de erro</summary>
  /// <param name="pValor" type="Integer">String contendo um Inteiro para ser convertido</param>
  /// <returns>Type="string"</returns>
  function IntParaStr(pValor: Integer): string;

  /// <summary>Funcao com tratamento de erro para converter um string em datetime</summary>
  /// <param name="pValor" type="string">String contendo um TDateTime para ser convertido</param>
  /// <returns>Type="TDatetime"</returns>
  function StringParaDataTime(const pValor: string): TDateTime;

  /// <summary>Funcao com tratamento de erro para converter um string em currency</summary>
  /// <param name="pValor" type="string">String contendo um Currency para ser convertido</param>
  /// <returns>Type="TDatetime"</returns>
  function StringParaCurrency(const pValor: string): Currency;

  /// <summary>Funcao com tratamento de erro para converter um string contendo um Currency(padrão americano) em currency</summary>
  /// <param name="pValor" type="string">String contendo um Currency(padrão americano) para ser convertido</param>
  /// <returns>Type="Currency"</returns>
  function StringParaCurrencyDef(const pValor: string): Currency;

  /// <summary>Funcao com tratamento de erro para converter um string em integer</summary>
  /// <param name="pValor" type="string">String contendo um inteiro</param>
  /// <returns>Integer</returns>
  function StringParaInt(const pValor: string): Integer;

  /// <summary>Método para tratar erro genérico</summary>
  /// <param name="pE" Type="Exception">Exceção para tratamento</param>
  procedure TratarErro(const pE: Exception);

  /// <summary>Método para tratar erro genérico da clonexão</summary>
  /// <param name="pE" type="EFDDBEngineException">Execeção para tratamento do erro</param>
  procedure TratarErroConexao(const pE: EFDDBEngineException);

  /// <summary>Método para tratar erro de parâmetro vazio na configuração</summary>
  /// <param name="pParametroVazio" type="string">nome do paâmetro que está vazio</param>
  procedure TratarErroConexaoParametro(const pParametroVazio: String);

implementation

function IfThen(pCondicao: Boolean; pTrue: TEncoding; pFalse: TEncoding): TEncoding;
begin
  Result := pFalse;
  if pCondicao then
    Result := pTrue;
end;

function StringParaDataTime(const pValor: string): TDateTime;
begin
  try
    Result :=  StrToDateTime(pValor);
  except
    Result := DATETIME_VAZIO;
  end;
end;

function StringParaCurrency(const pValor: string): Currency;
begin
  try
    Result := StrToFloat(pValor);
  except
    Result := CURRENCY_VAZIO;
  end;
end;

function StringParaInt(const pValor: string): Integer;
begin
  try
    Result := StrToInt(pValor);
  except
    Result := INT_VAZIO;
  end;
end;

function ConcatenaBuscaLiteralString(pValor: string): string;
begin
  Result := '%' + pValor + '%';
end;

procedure TratarErro(const pE: Exception);
begin
  RegistrarErro(ERRO_AO_BUSCAR_PRODUTOS + pE.Message);
end;

procedure TratarErroConexaoParametro(const pParametroVazio: String);
begin
  RegistrarErro(ERRO_PARAMETRO_VAZIO + pParametroVazio);
end;

procedure TratarErroConexao(const pE: EFDDBEngineException);
begin
  RegistrarErro(ERRO_CONECTAR_BASE_DADOS + pE.Message);
end;

function IntParaStr(pValor: Integer): string;
begin
  try
    Result := IntToStr(pValor);
  except
    Result := STRING_VAZIO;
  end;
end;

function StringParaCurrencyDef(const pValor: string): Currency;
begin
  try
    Result := StringParaCurrency(pValor.Replace(',','').Replace('.',','));
  except
    Result := CURRENCY_ZERO;
  end;
end;

function ConcatenaStrings(const pValores: TArray<string>): string;
var
  contador: Integer;

begin
  for contador := Low(pValores) to High(pValores) do
  begin
    Result := Result + pValores[contador];
  end;
end;

end.
