unit uImportadorTabelas;

interface

uses
  System.SysUtils,
  System.Types,
  System.IOUtils,
  System.Classes,
  System.Generics.Collections,
  uArquivoCSV,
  uRepositorioProduto,
  uRepositorioProdutoTributacao,
  uConexaoBanco,
  uProduto,
  uProdutoTributacao,
  uLogErro,
  FireDAC.Comp.Client,
  uConstantesGerais,
  uConstantesBaseDados,
  uVariaveisGlobais;

type
  ///<summary>Classe para importar as tabelas para a base de dados. </summary>
  TImportadorTabelas = class(TObject)
  private
    /// <summary>Repositório de produtos utilizados na importação dos arquivos. </summary>
    FRepositorioProduto: TRepositorioProduto;
    /// <summary>Repositorio de tributacao utilizado na importação dos arquivos. </summary>
    FRepositorioProdutoTributacao: TRepositorioProdutoTributacao;
    /// <summary>Conexão com o banco de dados utilizada. </summary>
    FConexaoBanco: TConexaoBanco;
    /// <summary>Atributo com a lista de arquivos para serem importados. </summary>
    FArquivosCSV: TList<TArquivoCSV>;


    /// <summary>Importa os dados de tributação de produtos a partir de arquivos CSV. Este método agora busca e importa todos os arquivos CSV dos estados./// </summary>
    procedure ImportarTodasTabelas;

    /// <summary>Método para reaproveitar o código, importa as tabelas que estão no atributo FArquivosCSV</summary>
    procedure ImportarArquivosCSV;
  public

    /// <summary>Cria uma nova instância do importador de tabelas.</summary>
    constructor Create;

    /// <summary>Destrói a instância do importador de tabelas.</summary>
    destructor Destroy; override;

    /// <summary>Importa os dados de tributação de produtos a partir da pasta configurada automáticamente no software.</summary>
    /// <Returns type="Boolean">True se a importação for bem-sucedida, False se ocorrer um erro.</returns>
    function ImportarTabelas: Boolean; overload;

    /// <summary>Importa os dados de tributação de produtos a partir de um arquivo CSV específico.</summary>
    /// <Param name="pCaminhoArquivo" type="String">O caminho completo para o arquivo CSV a ser importado.</param>
    /// <Returns type="Boolean">True se a importação for bem-sucedida, False se ocorrer um erro.</returns>
    function ImportarTabela(pCaminhoArquivo: string): Boolean;
  end;

implementation

constructor TImportadorTabelas.Create;
begin
  // Cria a conexão com o banco de dados.
  FConexaoBanco := gConexaoBanco;
  FConexaoBanco.AbrirConexao;

  // Cria os repositórios para acessar os dados.
  FRepositorioProduto := TRepositorioProduto.Create(FConexaoBanco);
  FRepositorioProdutoTributacao := TRepositorioProdutoTributacao.Create
    (FConexaoBanco.Conexao);
  FArquivosCSV := TList<TArquivoCSV>.Create;
  // Inicializa a lista de arquivos CSV.
end;

destructor TImportadorTabelas.Destroy;
begin
  // Libera os recursos.
  FRepositorioProduto.Free;
  FRepositorioProdutoTributacao.Free;
  for var ArquivoCSV in FArquivosCSV do // Libera cada arquivo CSV na lista.
    ArquivoCSV.Free;
  FArquivosCSV.Free; // Libera a lista em si.
  inherited;
end;

procedure TImportadorTabelas.ImportarArquivosCSV;
var
  ArquivoCSV: TArquivoCSV;
  Produto: TProduto;
  ProdutoTributacao: TProdutoTributacao;
  CodigoProduto: Integer;
  UF, caminho: string;
  ncm: string;
begin
  try
    for ArquivoCSV in FArquivosCSV do
    begin

      ArquivoCSV.Dados.First;
      while not ArquivoCSV.Dados.Eof do
      begin
        // Obtém os valores dos campos da linha atual.
        UF := ArquivoCSV.Dados.FieldByName(cUF).AsString;
        CodigoProduto := ArquivoCSV.Dados.FieldByName(cCodigo).AsInteger;
        ncm := ArquivoCSV.Dados.FieldByName(cCODIGONCM).AsString;
        caminho := ArquivoCSV.NomeArquivo;

        // Busca o produto pelo código.
        Produto := FRepositorioProduto.BuscarPorCodigo(CodigoProduto);

        // Verifica se o produto existe.
        if not Assigned(Produto) then
        begin
          // Produto não existe, cria um novo produto.
          Produto := TProduto.Create(CodigoProduto,
            ArquivoCSV.Dados.FieldByName(cDESCRICAO).AsString, ncm);
          FRepositorioProduto.Inserir(Produto);
          Produto.Free;
        end;

        // Busca a tributação do produto pelo código e UF.
        ProdutoTributacao := FRepositorioProdutoTributacao.
          ObterProdutoTributacao(CodigoProduto, UF);

        // Cria ou atualiza a tributação do produto.
        if Assigned(ProdutoTributacao) then
        begin
          // ProdutoTributacao existe, atualiza os dados.
          ProdutoTributacao.EX := ArquivoCSV.Dados.FieldByName(cEX).AsInteger;
          ProdutoTributacao.UF := UF;
          ProdutoTributacao.TIPO := ArquivoCSV.Dados.FieldByName(cTIPO)
            .AsInteger;
          ProdutoTributacao.TRIBNACIONALFEDERAL :=
            ArquivoCSV.Dados.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency;
          ProdutoTributacao.TRIBIMPORTADOSFEDERAL :=
            ArquivoCSV.Dados.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency;
          ProdutoTributacao.TRIBESTADUAL := ArquivoCSV.Dados.FieldByName
            (cTRIBESTADUAL).AsCurrency;
          ProdutoTributacao.TRIBMUNICIPAL := ArquivoCSV.Dados.FieldByName
            (cTRIBMUNICIPAL).AsCurrency;
          ProdutoTributacao.VIGENCIAINICIO := ArquivoCSV.Dados.FieldByName
            (cVIGENCIAINICIO).AsDateTime;
          ProdutoTributacao.VIGENCIAFIM := ArquivoCSV.Dados.FieldByName
            (cVIGENCIAFIM).AsDateTime;
          ProdutoTributacao.CHAVE := ArquivoCSV.Dados.FieldByName
            (cCHAVE).AsString;
          ProdutoTributacao.VERSAO := ArquivoCSV.Dados.FieldByName
            (cVERSAO).AsString;
          ProdutoTributacao.FONTE := ArquivoCSV.Dados.FieldByName
            (cFONTE).AsString;
          FRepositorioProdutoTributacao.AtualizarProdutoTributacao
            (ProdutoTributacao);
          ProdutoTributacao.Free;
        end
        else
        begin
          // ProdutoTributacao não existe, cria um novo registro.
          try
            ProdutoTributacao := TProdutoTributacao.Create;
            ProdutoTributacao.CodigoProduto := CodigoProduto;
            ProdutoTributacao.UF := UF;
            ProdutoTributacao.Ex := ArquivoCSV.Dados.FieldByName(cEX).AsInteger;
            ProdutoTributacao.Tipo := ArquivoCSV.Dados.FieldByName(cTIPO)
              .AsInteger;
            ProdutoTributacao.TribNacionalFederal :=
              ArquivoCSV.Dados.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency;
            ProdutoTributacao.TribImportadosFederal :=
              ArquivoCSV.Dados.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency;
            ProdutoTributacao.TribEstadual := ArquivoCSV.Dados.FieldByName
              (cTRIBESTADUAL).AsCurrency;
            ProdutoTributacao.TribMunicipal := ArquivoCSV.Dados.FieldByName
              (cTRIBMUNICIPAL).AsCurrency;
            ProdutoTributacao.VigenciaInicio := ArquivoCSV.Dados.FieldByName
              (cVIGENCIAINICIO).AsDateTime;
            ProdutoTributacao.VigenciaFim := ArquivoCSV.Dados.FieldByName
              (cVIGENCIAFIM).AsDateTime;
            ProdutoTributacao.Chave := ArquivoCSV.Dados.FieldByName
              (cCHAVE).AsString;
            ProdutoTributacao.Versao := ArquivoCSV.Dados.FieldByName
              (cVERSAO).AsString;
            ProdutoTributacao.Fonte := ArquivoCSV.Dados.FieldByName
              (cFONTE).AsString;
            FRepositorioProdutoTributacao.InserirProdutoTributacao
              (ProdutoTributacao);
          finally
            ProdutoTributacao.Free;
          end;
        end;
        UF := STRING_VAZIO;
        ArquivoCSV.Dados.Next;
      end;
    end;

  except
    on E: Exception do
    begin
      // Registra o erro
      RegistrarErro('Erro ao importar tabela do arquivo: ' + caminho + ' - ' +
        E.Message);
    end;
  end;
end;

function TImportadorTabelas.ImportarTabela(pCaminhoArquivo: string): Boolean;
var
  ArquivoCSV: TArquivoCSV;
begin
  try
    // Cria uma instância do TArquivoCSV com o caminho fornecido.
    ArquivoCSV := TArquivoCSV.Create();
    ArquivoCSV.NomeArquivo := pCaminhoArquivo;
    ArquivoCSV.LerArquivo;

    FArquivosCSV.Add(ArquivoCSV);
    // Adiciona o arquivo à lista para posterior liberação

    ImportarArquivosCSV;

    Result := True;
  except
    on E: Exception do
    begin
      // Registra o erro
      RegistrarErro('Erro ao importar tabela do arquivo: ' + pCaminhoArquivo +
        ' - ' + E.Message);
      Result := False;
    end;
  end;
end;

function TImportadorTabelas.ImportarTabelas: Boolean;
begin
  Result := False;
  try
    ImportarTodasTabelas;
    Result := True;
  except
    on E: Exception do
    begin
      RegistrarErro('');
    end;
  end;
end;

procedure TImportadorTabelas.ImportarTodasTabelas;
var
  ArquivoCSV: TArquivoCSV;
  SiglaEstado: string;
begin
  // Itera sobre as siglas dos estados para buscar os arquivos CSV.
  for SiglaEstado in SIGLA_ESTADOS do
  begin
    try
      // Busca o arquivo CSV para o estado atual.
      ArquivoCSV := TArquivoCSV.Create(SiglaEstado);
      FArquivosCSV.Add(ArquivoCSV);
    except
      on E: Exception do
      begin
        // Registra o erro e continua com o próximo estado.
        RegistrarErro(ERRO_AO_BUSCAR_PLANILHA + E.Message);
        Continue;
      end;
    end;
  end;

  ImportarArquivosCSV;
end;

end.
