/// <summary>
/// unit con funcoes uteis utilizadas no software
/// </summary>

unit uFuncoes;

interface

uses
  System.SysUtils,
  uConstantesGerais;

  // <summary>
  /// Funcao para adicionar % antes e depois da string
  /// result string
  /// </summary>
  function ConcatenaBuscaLiteralString(pValor: string): string;

  /// <summary>
  /// Funcao IfThen para testar condicao
  /// result TEncoding
  /// </summary>
  function IfThen(pCondicao: Boolean; pTrue: TEncoding; pFalse: TEncoding): TEncoding;

  /// <summary>
  /// Funcao com tratamento de erro para converter um string em datetime
  /// result TDatetime
  /// </summary>
  function StringParaDataTime(const pValor: string): TDateTime;

  /// <summary>
  /// Funcao com tratamento de erro para converter um string em currency
  /// result Currency
  /// </summary>
  function StringParaCurrency(const pValor: string): Currency;

  /// <summary>
  /// Funcao com tratamento de erro para converter um string em integer
  /// result Integer
  /// </summary>
  function StringParaInt(const pValor: string): Integer;

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

end.
