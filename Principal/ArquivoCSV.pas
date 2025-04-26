unit ArquivoCSV;

interface

uses
  System.SysUtils,
  System.IOUtils,
  System.Types,
  System.Classes,
  Data.DB,
  FireDAC.Comp.Client,
  uFuncoes, uArquivoCSVLinha;

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
    function GetDados(): TFDMemTable;
  public
    /// <summary>
    /// Cria uma nova instância da classe TArquivoCSV.
    /// </summary>
    /// <param name="ANomeArquivo">O nome do arquivo CSV.</param>
    /// <param name="ADelimitador">O delimitador usado no arquivo CSV (padrão: ';').</param>
    constructor Create(const pCaminhoArquivo: string; const pDelimitador: Char = ';'; pEncoding: TEncoding = nil);
    /// <summary>
    /// Destrói a instância da classe TArquivoCSV.
    /// </summary>
    destructor Destroy; override;
    /// <summary>
    /// Lê o arquivo CSV.
    /// </summary>
    procedure LerArquivo();
    /// <summary>
    /// Escreve os dados no arquivo CSV.
    /// </summary>
    ///  <param name="ANomeArquivo">O nome do arquivo CSV.</param>
    /// <param name="AIncluirCabecalho">Indica se deve incluir o cabeçalho no arquivo (padrão: True).</param>
    procedure EscreverArquivo(const ANomeArquivo: string; const AIncluirCabecalho: Boolean = True);

    /// <summary>
    /// Obtém os dados do arquivo CSV como um TFDMemTable.
    /// </summary>
    property Dados: TFDMemTable read GetDados;

  end;

implementation

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
begin
  if not FileExists(FNomeArquivo) then
  begin
    raise Exception.Create('Arquivo CSV não encontrado: ' + FNomeArquivo);
  end;

  FDados.FieldDefs.Clear;
  FDados.FieldDefs.Add('ID', ftInteger);
  FDados.FieldDefs.Add('Codigo', ftInteger);
  FDados.FieldDefs.Add('Ex', ftInteger);
  FDados.FieldDefs.Add('Tipo', ftInteger);
  FDados.FieldDefs.Add('Descricao', ftString, 100);
  FDados.FieldDefs.Add('NacionalFederal', ftCurrency);
  FDados.FieldDefs.Add('ImportadosFederal', ftCurrency);
  FDados.FieldDefs.Add('Estadual', ftCurrency);
  FDados.FieldDefs.Add('Municipal', ftCurrency);
  FDados.FieldDefs.Add('VigenciaInicio', ftDateTime);
  FDados.FieldDefs.Add('VigenciaFim', ftDateTime);
  FDados.FieldDefs.Add('Chave', ftString, 255);
  FDados.FieldDefs.Add('Versao', ftString, 20);
  FDados.FieldDefs.Add('Fonte', ftString, 255);
  FDados.CreateDataSet;
  FDados.Open;

  try
    var
      leitor := TStreamReader.Create(FNomeArquivo, FEncoding);
    try
      // Lê o cabeçalho, mas não o utiliza para popular o FDMemTable neste caso, pois as colunas são fixas.
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
          FDados.FieldByName('ID').AsInteger := CSVLinha.ID;
          FDados.FieldByName('Codigo').AsInteger := CSVLinha.CodigoNCM;
          FDados.FieldByName('Ex').AsInteger := CSVLinha.Ex;
          FDados.FieldByName('Tipo').AsInteger := CSVLinha.Tipo;
          FDados.FieldByName('Descricao').AsString := CSVLinha.Descricao;
          FDados.FieldByName('NacionalFederal').AsCurrency := CSVLinha.NacionalFederal;
          FDados.FieldByName('ImportadosFederal').AsCurrency := CSVLinha.ImportadosFederal;
          FDados.FieldByName('Estadual').AsCurrency := CSVLinha.Estadual;
          FDados.FieldByName('Municipal').AsCurrency := CSVLinha.Municipal;
          FDados.FieldByName('VigenciaInicio').AsDateTime := CSVLinha.VigenciaInicio;
          FDados.FieldByName('VigenciaFim').AsDateTime := CSVLinha.VigenciaFim;
          FDados.FieldByName('Chave').AsString := CSVLinha.Chave;
          FDados.FieldByName('Versao').AsString := CSVLinha.Versao;
          FDados.FieldByName('Fonte').AsString := CSVLinha.Fonte;
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
      raise Exception.Create('Erro ao ler arquivo CSV: ' + FNomeArquivo + #13#10 + E.Message);
  end;
end;

procedure TArquivoCSV.EscreverArquivo(const ANomeArquivo: string; const AIncluirCabecalho: Boolean);
var
  Escritor: TStreamWriter;
begin
  try
    Escritor := TStreamWriter.Create(ANomeArquivo, False, TEncoding.UTF8);
    try
      if AIncluirCabecalho then
      begin
        Escritor.Write('Codigo' + FDelimitador);
        Escritor.Write('Ex' + FDelimitador);
        Escritor.Write('Tipo' + FDelimitador);
        Escritor.Write('Descricao' + FDelimitador);
        Escritor.Write('NacionalFederal' + FDelimitador);
        Escritor.Write('ImportadosFederal' + FDelimitador);
        Escritor.Write('Estadual' + FDelimitador);
        Escritor.Write('Municipal' + FDelimitador);
        Escritor.Write('VigenciaInicio' + FDelimitador);
        Escritor.Write('VigenciaFim' + FDelimitador);
        Escritor.Write('Chave' + FDelimitador);
        Escritor.Write('Versao' + FDelimitador);
        Escritor.Write('Fonte');
        Escritor.WriteLine();
      end;

      FDados.First;
      while not FDados.Eof do
      begin
        Escritor.Write(FDados.FieldByName('Codigo').AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName('Ex').AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName('Tipo').AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName('Descricao').AsString + FDelimitador);
        Escritor.Write(FormatFloat('0.00', FDados.FieldByName('NacionalFederal').AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat('0.00', FDados.FieldByName('ImportadosFederal').AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat('0.00', FDados.FieldByName('Estadual').AsCurrency) + FDelimitador);
        Escritor.Write(FormatFloat('0.00', FDados.FieldByName('Municipal').AsCurrency) + FDelimitador);
        Escritor.Write(FormatDateTime('YYYY-MM-DD HH:MM:SS', FDados.FieldByName('VigenciaInicio').AsDateTime) + FDelimitador);
        Escritor.Write(FormatDateTime('YYYY-MM-DD HH:MM:SS', FDados.FieldByName('VigenciaFim').AsDateTime) + FDelimitador);
        Escritor.Write(FDados.FieldByName('Chave').AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName('Versao').AsString + FDelimitador);
        Escritor.Write(FDados.FieldByName('Fonte').AsString);
        Escritor.WriteLine();
        FDados.Next;
      end;
    finally
      Escritor.Free;
    end;
  except
    on E: Exception do
      raise Exception.Create('Erro ao escrever arquivo CSV: ' + ANomeArquivo + #13#10 + E.Message);
  end;
end;

function TArquivoCSV.GetDados(): TFDMemTable;
begin
  Result := FDados;
end;

end.

