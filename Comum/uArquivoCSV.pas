unit uArquivoCSV;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Types,
  System.Classes,
  Data.DB,
  FireDAC.Comp.Client,
  uFuncoes,
  uArquivoCSVLinha,
  uConstantesGerais,
  uLogErro,
  uConstantesBaseDados;

type

  /// <summary>
  /// Classe para manipular arquivos CSV.
  /// </summary>
  TArquivoCSV = class
  private
    FNomeArquivo: string;
    FDelimitador: Char;
    FEncoding: TEncoding;
    FDados: TFDMemTable;

    /// <summary>
    /// funcao que retorna os dados do arquivo
    /// </summary>
    /// <result:>TFDMemTable</result>
    function GetDados(): TFDMemTable;

    /// <summary>
    /// Extrai a Sigla do nome do arquivo
    /// </summary>
    /// <param name="pNomeArquivo">O nome do arquivo.</param>
    function ExtrairSiglaNomeArquivo(const pNomeArquivo: string): string;

  public
    /// <summary>
    /// Cria uma nova instância da classe TArquivoCSV.
    /// </summary>
    /// <param name="pUF">Sigla do estado</param>
    /// <param name="pDelimitador">O delimitador usado no arquivo CSV (padrão: ';').</param>
    constructor Create(const pUF: string; const pDelimitador: Char = ';'; pEncoding: TEncoding = nil); overload;

    /// <summary>
    /// Destrói a instância da classe TArquivoCSV.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Busca automaticamente a planilha do estado
    /// </summary>
    /// <param name="pNomeArquivo">O nome do arquivo.</param>
    /// <result>caminho + nome do arquivo</result>
    function BuscarCarregarPlanilhaEstado(const pSiglaEstado: string): Boolean;

    /// <summary>
    /// Lê o arquivo CSV.
    /// </summary>
    procedure LerArquivo();

    /// <summary>
    /// Escreve os dados no arquivo CSV.
    /// </summary>
    ///  <param name="pNomeArquivo">O nome do arquivo CSV.</param>
    /// <param name="pIncluirCabecalho">Indica se deve incluir o cabeçalho no arquivo (padrão: True).</param>
    procedure EscreverArquivo(const pNomeArquivo: string; const pIncluirCabecalho: Boolean = True);

    /// <summary>
    /// Obtém os dados do arquivo CSV como um TFDMemTable.
    /// </summary>
    property Dados: TFDMemTable read GetDados;

    /// <summary>
    /// Obtém o nome do arquivo CSV.
    /// </summary>
    property NomeArquivo: string read FNomeArquivo write FNomeArquivo;

  end;

implementation

function TArquivoCSV.BuscarCarregarPlanilhaEstado(const pSiglaEstado: string): Boolean;
var
  diretorio: string;
  nomeArquivo: string;
  arquivoEncontrado: string;
  nomeCompleto: string;
  siglaExtraida: string;
begin
  Result := False;
  arquivoEncontrado := STRING_VAZIO;
  diretorio := (GetCurrentDir).Replace(STRING_DEBUG, STRING_VAZIO).Replace('\Test\Win32\Debug','');
  diretorio := System.IOUtils.TPath.Combine(diretorio, DIRETORIO_TABELAS_IBPT);

  if not DirectoryExists(diretorio) then
  begin
    RegistrarErro(ERRO_AO_BUSCAR_DIRETORIO + DIRETORIO_TABELAS_IBPT);
    Exit;
  end;

  arquivoEncontrado := STRING_VAZIO;

  try
    for nomeArquivo in TDirectory.GetFiles(diretorio) do
    begin
      nomeCompleto := System.IOUtils.TPath.Combine(diretorio, nomeArquivo);

      if SameText(System.IOUtils.TPath.GetExtension(nomeCompleto), EXTENSAO_CSV) or
         SameText(System.IOUtils.TPath.GetExtension(nomeCompleto), EXTENSAO_XLS) or
         SameText(System.IOUtils.TPath.GetExtension(nomeCompleto), EXTENSAO_XLSX) then
      begin
        siglaExtraida := ExtrairSiglaNomeArquivo(nomeArquivo);

        if SameText(siglaExtraida, pSiglaEstado) then
        begin
          arquivoEncontrado := nomeCompleto;
          Break;
        end;
      end;
    end;

    if arquivoEncontrado <> STRING_VAZIO then
    begin
      FNomeArquivo := ArquivoEncontrado;
      LerArquivo;
      Result := True;
    end;
  except
    on E: Exception do
      RegistrarErro(ERRO_AO_BUSCAR_PLANILHA + E.Message);
  end;
end;

constructor TArquivoCSV.Create(const pUF: string; const pDelimitador: Char; pEncoding: TEncoding);
begin
  FDelimitador := pDelimitador;
  FEncoding := IfThen(pEncoding = nil, TEncoding.UTF8, pEncoding);
  FDados := TFDMemTable.Create(nil);
  Self.BuscarCarregarPlanilhaEstado(pUF);
end;

destructor TArquivoCSV.Destroy;
begin
  FDados.Free;
  inherited;
end;

procedure TArquivoCSV.LerArquivo();
var
  Linha: string;
  Valores: TArray<string>;
  CSVLinha: TArquivoCSVLinha;
  siglaEstado: string;

  procedure RemoverAspas;
  var
    cont: integer;
  begin
    for cont := 0 to Length(Valores) - 1 do
    begin
      Valores[cont] := Valores[cont].Replace('"','').Replace('(','').Replace(')','');
    end;
  end;
begin
  if not FileExists(FNomeArquivo) then
  begin
    RegistrarErro(ARQUIVO_NAO_ENCONTRADO + FNomeArquivo);
    Exit;
  end;

  siglaEstado := ExtrairSiglaNomeArquivo(FNomeArquivo);

  if not FDados.Active then
  begin
    FDados.FieldDefs.Clear;
    FDados.FieldDefs.Add(cUF, ftString, INT_2);
    FDados.FieldDefs.Add(cCODIGONCM, ftInteger);
    FDados.FieldDefs.Add(cEX, ftInteger);
    FDados.FieldDefs.Add(cTIPO, ftInteger);
    FDados.FieldDefs.Add(cDESCRICAO, ftString, INT_100);
    FDados.FieldDefs.Add(cTRIBNACIONALFEDERAL, ftCurrency);
    FDados.FieldDefs.Add(cTRIBIMPORTADOSFEDERAL, ftCurrency);
    FDados.FieldDefs.Add(cTRIBESTADUAL, ftCurrency);
    FDados.FieldDefs.Add(cTRIBMUNICIPAL, ftCurrency);
    FDados.FieldDefs.Add(cVIGENCIAINICIO, ftDateTime);
    FDados.FieldDefs.Add(cVIGENCIAFIM, ftDateTime);
    FDados.FieldDefs.Add(cCHAVE, ftString, INT_255);
    FDados.FieldDefs.Add(cVERSAO, ftString, INT_20);
    FDados.FieldDefs.Add(cFONTE, ftString, INT_255);
    FDados.CreateDataSet;
    FDados.Open;
  end;

  try
    var
      leitor := TStreamReader.Create(FNomeArquivo, FEncoding);
    try
      // Lê o cabeçalho, mas não o utiliza para popular o FDMemTable neste caso,
      // pois as colunas são fixas.
      if not leitor.EndOfStream then
      begin
        leitor.ReadLine();
      end;

      while not leitor.EndOfStream do
      begin
        Linha := leitor.ReadLine();
        Valores := Linha.Split(FDelimitador);
        RemoverAspas;
        CSVLinha := TArquivoCSVLinha.Create;
        try
          CSVLinha.AtribuirValores(Valores);
          FDados.Append;
          FDados.FieldByName(cUF).AsString := siglaEstado;
          FDados.FieldByName(cCODIGONCM).AsInteger := CSVLinha.CodigoNCM;
          FDados.FieldByName(cEX).AsInteger := CSVLinha.Ex;
          FDados.FieldByName(cTIPO).AsInteger := CSVLinha.Tipo;
          FDados.FieldByName(cDESCRICAO).AsString := CSVLinha.Descricao;
          FDados.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency := CSVLinha.NacionalFederal;
          FDados.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency := CSVLinha.ImportadosFederal;
          FDados.FieldByName(cTRIBESTADUAL).AsCurrency := CSVLinha.Estadual;
          FDados.FieldByName(cTRIBMUNICIPAL).AsCurrency := CSVLinha.Municipal;
          FDados.FieldByName(cVIGENCIAINICIO).AsDateTime := CSVLinha.VigenciaInicio;
          FDados.FieldByName(cVIGENCIAFIM).AsDateTime := CSVLinha.VigenciaFim;
          FDados.FieldByName(cCHAVE).AsString := CSVLinha.Chave;
          FDados.FieldByName(cVERSAO).AsString := CSVLinha.Versao;
          FDados.FieldByName(cFONTE).AsString := CSVLinha.Fonte;
          FDados.Post;
        finally
          CSVLinha.Free;
        end;
      end;
    finally
      leitor.Free;
    end;
  except
    on E: Exception do
      RegistrarErro(ERRO_LER_ARQUIVO + FNomeArquivo + #13#10 + E.Message);
  end;
end;

procedure TArquivoCSV.EscreverArquivo(const pNomeArquivo: string; const pIncluirCabecalho: Boolean);
var
  Escritor: TStreamWriter;
begin
  try
    Escritor := TStreamWriter.Create(pNomeArquivo, False, TEncoding.UTF8);
    try
      if pIncluirCabecalho then
      begin
        Escritor.Write(cCODIGONCM + FDelimitador);
        Escritor.Write(cEX + FDelimitador);
        Escritor.Write(cTIPO + FDelimitador);
        Escritor.Write(cDESCRICAO + FDelimitador);
        Escritor.Write(cTRIBNACIONALFEDERAL + FDelimitador);
        Escritor.Write(cTRIBIMPORTADOSFEDERAL + FDelimitador);
        Escritor.Write(cTRIBESTADUAL + FDelimitador);
        Escritor.Write(cTRIBMUNICIPAL + FDelimitador);
        Escritor.Write(cVIGENCIAINICIO + FDelimitador);
        Escritor.Write(cVIGENCIAFIM + FDelimitador);
        Escritor.Write(cCHAVE + FDelimitador);
        Escritor.Write(cVERSAO + FDelimitador);
        Escritor.Write(cFONTE);
        Escritor.WriteLine();
      end;

      FDados.First;
      while not FDados.Eof do
      begin
        Escritor.Write(FDados.FieldByName(cCODIGONCM).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cEX).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cTIPO).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cDESCRICAO).AsString + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cTRIBESTADUAL).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cTRIBMUNICIPAL).AsCurrency) + FDelimitador);
        Escritor.Write(FormatDateTime(DATA_YYYY_MM_DD, FDados.FieldByName(cVIGENCIAINICIO).AsDateTime) + FDelimitador);
        Escritor.Write(FormatDateTime(DATA_YYYY_MM_DD, FDados.FieldByName(cVIGENCIAFIM).AsDateTime) + FDelimitador);
        Escritor.Write(FDados.FieldByName(cCHAVE).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cVERSAO).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cFONTE).AsString);
        Escritor.WriteLine();
        FDados.Next;
      end;
    finally
      Escritor.Free;
    end;
  except
    on E: Exception do
      RegistrarErro(ERRO_ESCREVER_ARQUIVO + pNomeArquivo + #13#10 + E.Message);
  end;
end;

function TArquivoCSV.ExtrairSiglaNomeArquivo(
  const pNomeArquivo: string): string;
var
  nomeSemExtensao: string;
  posInicioSigla,
  posFimSigla: Integer;
  siglaEncontrada: Boolean;
  cont: integer;
begin
  Result := STRING_VAZIO;
  siglaEncontrada := False;

  nomeSemExtensao := System.IOUtils.TPath.ChangeExtension(pNomeArquivo, STRING_VAZIO);
  posInicioSigla := Pos(SIGLA_IBPTAX, NomeSemExtensao) + INT_6;
  posFimSigla := Pos(SIGLA_IBPTAX, NomeSemExtensao) + INT_8;
  if posInicioSigla > INT_6 then
  begin
    if posFimSigla > posInicioSigla then
    begin
      Result := Copy(nomeSemExtensao, posInicioSigla, posFimSigla - posInicioSigla);
      for cont := Low(SIGLA_ESTADOS) to High(SIGLA_ESTADOS) do
      begin
        if Result = SIGLA_ESTADOS[cont] then
        begin
          SiglaEncontrada := True;
          Break;
        end;
      end;
      if not SiglaEncontrada then
        Result := STRING_VAZIO;
    end;
  end;
end;

function TArquivoCSV.GetDados(): TFDMemTable;
begin
  Result := FDados;
end;

end.

