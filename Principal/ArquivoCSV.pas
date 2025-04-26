unit ArquivoCSV;

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
  uLogErro;

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
    /// <param name="pNomeArquivo">O nome do arquivo CSV.</param>
    /// <param name="pDelimitador">O delimitador usado no arquivo CSV (padrão: ';').</param>
    constructor Create(const pCaminhoArquivo: string; const pDelimitador: Char = ';'; pEncoding: TEncoding = nil);

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

  end;

implementation

const
  cUF = 'UF';
  cCodigo = 'Codigo';
  cEx = 'Ex';
  cTipo = 'Tipo';
  cDescricao = 'Descricao';
  cNacionalFederal = 'NacionalFederal';
  cImportadosFederal = 'ImportadosFederal';
  cEstadual = 'Estadual';
  cMunicipal = 'Municipal';
  cVigenciaInicio = 'VigenciaInicio';
  cVigenciaFim = 'VigenciaFim';
  cChave = 'Chave';
  cVersao = 'Versao';
  cFonte = 'Fonte';

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
  diretorio := GetCurrentDir.Replace(STRING_DEBUG, STRING_VAZIO);
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

constructor TArquivoCSV.Create(const pCaminhoArquivo: string; const pDelimitador: Char; pEncoding: TEncoding);
begin
  FNomeArquivo := pCaminhoArquivo;
  FDelimitador := pDelimitador;
  FEncoding := IfThen(pEncoding = nil, TEncoding.UTF8, pEncoding);
  FDados := TFDMemTable.Create(nil);
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
begin
  if not FileExists(FNomeArquivo) then
  begin
    RegistrarErro(ARQUIVO_NAO_ENCONTRADO + FNomeArquivo);
    Exit;
  end;

  siglaEstado := ExtrairSiglaNomeArquivo(FNomeArquivo);

  FDados.FieldDefs.Clear;
  FDados.FieldDefs.Add(cUF, ftString, INT_2);
  FDados.FieldDefs.Add(cCodigo, ftInteger);
  FDados.FieldDefs.Add(cEx, ftInteger);
  FDados.FieldDefs.Add(cTipo, ftInteger);
  FDados.FieldDefs.Add(cDescricao, ftString, INT_100);
  FDados.FieldDefs.Add(cNacionalFederal, ftCurrency);
  FDados.FieldDefs.Add(cImportadosFederal, ftCurrency);
  FDados.FieldDefs.Add(cEstadual, ftCurrency);
  FDados.FieldDefs.Add(cMunicipal, ftCurrency);
  FDados.FieldDefs.Add(cVigenciaInicio, ftDateTime);
  FDados.FieldDefs.Add(cVigenciaFim, ftDateTime);
  FDados.FieldDefs.Add(cChave, ftString, INT_255);
  FDados.FieldDefs.Add(cVersao, ftString, INT_20);
  FDados.FieldDefs.Add(cFonte, ftString, INT_255);
  FDados.CreateDataSet;
  FDados.Open;

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
        CSVLinha := TArquivoCSVLinha.Create;
        try
          CSVLinha.AtribuirValores(Valores);
          FDados.Append;
          FDados.FieldByName(cUF).AsString := siglaEstado;
          FDados.FieldByName(cCodigo).AsInteger := CSVLinha.CodigoNCM;
          FDados.FieldByName(cEx).AsInteger := CSVLinha.Ex;
          FDados.FieldByName(cTipo).AsInteger := CSVLinha.Tipo;
          FDados.FieldByName(cDescricao).AsString := CSVLinha.Descricao;
          FDados.FieldByName(cNacionalFederal).AsCurrency := CSVLinha.NacionalFederal;
          FDados.FieldByName(cImportadosFederal).AsCurrency := CSVLinha.ImportadosFederal;
          FDados.FieldByName(cEstadual).AsCurrency := CSVLinha.Estadual;
          FDados.FieldByName(cMunicipal).AsCurrency := CSVLinha.Municipal;
          FDados.FieldByName(cVigenciaInicio).AsDateTime := CSVLinha.VigenciaInicio;
          FDados.FieldByName(cVigenciaFim).AsDateTime := CSVLinha.VigenciaFim;
          FDados.FieldByName(cChave).AsString := CSVLinha.Chave;
          FDados.FieldByName(cVersao).AsString := CSVLinha.Versao;
          FDados.FieldByName(cFonte).AsString := CSVLinha.Fonte;
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
        Escritor.Write(cCodigo + FDelimitador);
        Escritor.Write(cEx + FDelimitador);
        Escritor.Write(cTipo + FDelimitador);
        Escritor.Write(cDescricao + FDelimitador);
        Escritor.Write(cNacionalFederal + FDelimitador);
        Escritor.Write(cImportadosFederal + FDelimitador);
        Escritor.Write(cEstadual + FDelimitador);
        Escritor.Write(cMunicipal + FDelimitador);
        Escritor.Write(cVigenciaInicio + FDelimitador);
        Escritor.Write(cVigenciaFim + FDelimitador);
        Escritor.Write(cChave + FDelimitador);
        Escritor.Write(cVersao + FDelimitador);
        Escritor.Write(cFonte);
        Escritor.WriteLine();
      end;

      FDados.First;
      while not FDados.Eof do
      begin
        Escritor.Write(FDados.FieldByName(cCodigo).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cEx).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cTipo).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cDescricao).AsString + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cNacionalFederal).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cImportadosFederal).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cEstadual).AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat(DECIMAL_DOIS_DIGITOS, FDados.FieldByName(cMunicipal).AsCurrency) + FDelimitador);
        Escritor.Write(FormatDateTime(DATA_YYYY_MM_DD, FDados.FieldByName(cVigenciaInicio).AsDateTime) + FDelimitador);
        Escritor.Write(FormatDateTime(DATA_YYYY_MM_DD, FDados.FieldByName(cVigenciaFim).AsDateTime) + FDelimitador);
        Escritor.Write(FDados.FieldByName(cChave).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cVersao).AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName(cFonte).AsString);
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

