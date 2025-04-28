unit uTestuImportadorTabelas;

interface

uses
  System.SysUtils,
  System.Classes,
  // Units do projeto
  uImportadorTabelas,
  uConexaoBanco,
  uRepositorioProduto,
  uRepositorioProdutoTributacao,
  ArquivoCSV,
  uConstantesTeste,
  // DUnit
  TestFramework,
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  Vcl.Dialogs;

type
  TTesteImportador = class(TTestCase)
  private
    FImportador: TImportadorTabelas;
    FConexaoBanco: TConexaoBanco;
    FRepositorioProduto: TRepositorioProduto;
    FRepositorioProdutoTributacao: TRepositorioProdutoTributacao;
    function CriarArquivoCSVDeTeste(const ConteudoCSV: string; const NomeArquivo: string): string;
    procedure ExcluirArquivoDeTeste(const NomeArquivo: string);
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  public
    constructor Create(AName: string); override;
    destructor Destroy; override;

    procedure TestImportarTabelas_Sucesso;
    procedure TestImportarTodasTabelas_Sucesso;
    procedure TestImportarTodasTabelas_ArquivoNaoEncontrado;
  end;

implementation

uses
  System.IOUtils,
  System.StrUtils;

const
  // Constantes para configuração do teste
  CAMINHO_TESTE = '.\testes\'; // Caminho para arquivos de teste
  ARQUIVO_CSV_SUCESSO = 'produtos_tributacao_sucesso.csv';
  ARQUIVO_CSV_NAO_ENCONTRADO = 'arquivo_nao_encontrado.csv';

{ TTesteImportador }

constructor TTesteImportador.Create(AName: string);
begin
  inherited Create(AName);
  FImportador := nil;
  FConexaoBanco := nil;
  FRepositorioProduto := nil;
  FRepositorioProdutoTributacao := nil;
end;

destructor TTesteImportador.Destroy;
begin
  FreeAndNil(FImportador);
  FreeAndNil(FConexaoBanco);
  FreeAndNil(FRepositorioProduto);
  FreeAndNil(FRepositorioProdutoTributacao);
  inherited;
end;

procedure TTesteImportador.SetUp;
begin
  // Cria uma instância do TConexaoBanco para cada teste.
  FConexaoBanco := TConexaoBanco.Create;
  FConexaoBanco.AbrirConexao;

  // Inicializa os repositórios
  FRepositorioProduto := TRepositorioProduto.Create(FConexaoBanco);
  FRepositorioProdutoTributacao := TRepositorioProdutoTributacao.Create(FConexaoBanco.Conexao);

  // Garante que o diretório de testes exista
  if not TDirectory.Exists(CAMINHO_TESTE) then
    TDirectory.CreateDirectory(CAMINHO_TESTE);

  // Cria a instância do importador.
  FImportador := TImportadorTabelas.Create;
end;

procedure TTesteImportador.TearDown;
begin
  // Libera a instância do importador e a conexão com o banco.
  FreeAndNil(FImportador);
  FreeAndNil(FRepositorioProduto);
  FreeAndNil(FRepositorioProdutoTributacao);
  FConexaoBanco.FecharConexao;
  FConexaoBanco.Free;
  FConexaoBanco := nil;

  // Limpa os dados das tabelas de teste (opcional, dependendo da sua necessidade)
  // Pode ser necessário criar métodos nos repositórios para limpar os dados de teste.
  // Exemplo (adapte para seus repositórios):
  // FRepositorioProduto.ExcluirTodos();
  // FRepositorioProdutoTributacao.ExcluirTodos();
end;

function TTesteImportador.CriarArquivoCSVDeTeste(const ConteudoCSV: string; const NomeArquivo: string): string;
var
  CaminhoCompleto: string;
begin
  CaminhoCompleto := TPath.Combine(CAMINHO_TESTE, NomeArquivo);
  TFile.WriteAllText(CaminhoCompleto, ConteudoCSV);
  Result := CaminhoCompleto;
end;

procedure TTesteImportador.ExcluirArquivoDeTeste(const NomeArquivo: string);
var
  CaminhoCompleto: string;
begin
  CaminhoCompleto := TPath.Combine(CAMINHO_TESTE, NomeArquivo);
  if TFile.Exists(CaminhoCompleto) then
    TFile.Delete(CaminhoCompleto);
end;

procedure TTesteImportador.TestImportarTabelas_Sucesso;
var
  Result: Boolean;
  NomeArquivoCSV: string;
  ConteudoCSV: string;
begin
  // Dados de teste para o arquivo CSV.  Adapte para os nomes de colunas corretos.
  ConteudoCSV :=
    'CODIGO;DESCRICAO;NCM;UF;EX;TIPO;TRIBNACIONALFEDERAL;TRIBIMPORTADOSFEDERAL;TRIBESTADUAL;TRIBMUNICIPAL;VIGENCIAINICIO;VIGENCIAFIM;CHAVE;VERSAO;FONTE' + sLineBreak +
    '1;Produto A;12345678;SP;1;1;10.00;5.00;2.00;1.00;01/01/2023;31/12/2023;CHAVE123;1.0;FONTE1';
  NomeArquivoCSV := CriarArquivoCSVDeTeste(ConteudoCSV, ARQUIVO_CSV_SUCESSO);

  try
    // Executa o método a ser testado.
    Result := FImportador.ImportarTabelas;

    // Verifica o resultado.
    Check(Result, 'Importação de tabelas deveria ter sido bem-sucedida.');

  finally
    ExcluirArquivoDeTeste(NomeArquivoCSV);
  end;
end;

procedure TTesteImportador.TestImportarTodasTabelas_Sucesso;
var
  resultado: Boolean;
  nomeArquivoCSV1, NomeArquivoCSV2: string;
  conteudoCSV1, conteudoCSV2: string;
begin
  // Dados de teste para o arquivo CSV de SP
  conteudoCSV1 :=
    'CODIGO;DESCRICAO;NCM;UF;EX;TIPO;TRIBNACIONALFEDERAL;TRIBIMPORTADOSFEDERAL;TRIBESTADUAL;TRIBMUNICIPAL;VIGENCIAINICIO;VIGENCIAFIM;CHAVE;VERSAO;FONTE' + sLineBreak +
    '1;Produto A;12345678;SP;1;1;10.00;5.00;2.00;1.00;01/01/2023;31/12/2023;CHAVE123;1.0;FONTE1';
  nomeArquivoCSV1 := CriarArquivoCSVDeTeste(ConteudoCSV1, 'produtos_tributacao_sp.csv');

  // Dados de teste para o arquivo CSV de RJ
  conteudoCSV2 :=
    'CODIGO;DESCRICAO;NCM;UF;EX;TIPO;TRIBNACIONALFEDERAL;TRIBIMPORTADOSFEDERAL;TRIBESTADUAL;TRIBMUNICIPAL;VIGENCIAINICIO;VIGENCIAFIM;CHAVE;VERSAO;FONTE' + sLineBreak +
    '2;Produto B;98765432;RJ;2;2;20.00;10.00;4.00;2.00;01/01/2023;31/12/2023;CHAVE456;1.0;FONTE2';
  nomeArquivoCSV2 := CriarArquivoCSVDeTeste(conteudoCSV2, 'produtos_tributacao_rj.csv');

  try
    // Executa o método a ser testado.
    resultado := FImportador.ImportarTabelas;
    Check(resultado, 'Importação de tabelas deveria ter sido bem-sucedida.');

  finally
    ExcluirArquivoDeTeste(NomeArquivoCSV1);
    ExcluirArquivoDeTeste(NomeArquivoCSV2);
  end;
end;

procedure TTesteImportador.TestImportarTodasTabelas_ArquivoNaoEncontrado;
var
  resultado : Boolean;
  nomeArquivoCSV: string;
  conteudoCSV: string;
begin
  // Cria um arquivo CSV de teste
  conteudoCSV :=
    'CODIGO;DESCRICAO;NCM;UF;EX;TIPO;TRIBNACIONALFEDERAL;TRIBIMPORTADOSFEDERAL;TRIBESTADUAL;TRIBMUNICIPAL;VIGENCIAINICIO;VIGENCIAFIM;CHAVE;VERSAO;FONTE' + sLineBreak +
    '1;Produto A;12345678;SP;1;1;10.00;5.00;2.00;1.00;01/01/2023;31/12/2023;CHAVE123;1.0;FONTE1';
  nomeArquivoCSV := CriarArquivoCSVDeTeste(ConteudoCSV, ARQUIVO_CSV_SUCESSO);
  try
    try
      // Tenta importar as tabelas.  Neste caso, esperamos que ele tente importar um arquivo que não existe.
      resultado := FImportador.ImportarTabelas;
      Check(resultado, 'Importação de tabelas deveria ter sido bem-sucedida.');
    except
      on E: Exception do
      begin
        Check(E.Message.Contains(ERRO_AO_BUSCAR_PLANILHA), 'Mensagem de erro incorreta: ' + E.Message);
      end;
    end;
  finally
    ExcluirArquivoDeTeste(nomeArquivoCSV);
  end;
end;

initialization
  // Registra a classe de teste
  RegisterTest(TTesteImportador.Suite);
end.

