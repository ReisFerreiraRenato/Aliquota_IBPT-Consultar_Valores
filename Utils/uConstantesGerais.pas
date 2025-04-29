/// <summary>
/// unit para armazenar os valores constantes utilizados no software
/// </summary>

unit uConstantesGerais;

interface

type
  /// <summary>
  /// Define um tipo para um array de strings contendo as siglas dos estados brasileiros.
  /// </summary>
  TTipoSiglasEstados = array[0..26] of string;

const

  ARQUIVO_CONFIGURACAO_NAO_ENCONTRADO = 'Arquivo de configuração não encontrado: ';
  ARQUIVO_NAO_ENCONTRADO = 'Arquivo não encontrado: ';

  BANCO_DADOS_VALIDOS: array[0..3] of string = ('Firebird', 'Oracle', 'SQLServer', 'MySQL');

  CONEXAO_TESTADA_COM_SUCESSO = 'Conexão testada com sucesso';

  CURRENCY_VAZIO = - 99999.99;
  CURRENCY_ZERO = 0.0;

  DATA_YYYY_MM_DD = 'YYYY-MM-DD HH:MM:SS';
  DATETIME_VAZIO = 0;
  DECIMAL_DOIS_DIGITOS = '0.00';
  DIRETORIO_TABELAS_IBPT = 'TabelasIBPT';

  ERRO_ADICIONE_VALOR_CALCULADO = 'Adicione o valor a ser calculado. ';
  ERRO_AO_BUSCAR_PLANILHA = 'Erro ao buscar planilha: ';
  ERRO_AO_BUSCAR_PRODUTOS = 'Erro ao buscar produto(s). ';
  ERRO_AO_BUSCAR_DIRETORIO = 'Diretório não encontrado. Dir: ';
  ERRO_AO_IMPORTAR_TABELAS = 'Erro ao importar tabela(s). ';
  ERRO_AO_TESTAR_CONEXAO = 'Conexão com erro';
  ERRO_CONECTAR_BASE_DADOS = 'Erro ao conectar na base de dados. ';
  ERRO_ESCREVER_ARQUIVO = 'Erro ao escrever arquivo: ';
  ERRO_LER_ARQUIVO = 'Erro ao ler arquivo: ';
  ERRO_SELECIONAR_PRODUTO = 'Favor selecionar o produto. ';
  ERRO_VALOR_NEGATIVO = 'O valor não pode ser negativo. ';

  EXTENSAO_CSV = '.csv';
  EXTENSAO_XLS = '.xls';
  EXTENSAO_XLSX = '.xlsx';

  INT_VAZIO = -999999;
  INT_ZERO = 0;
  INT_1 = 1;
  INT_2 = 2;
  INT_3 = 3;
  INT_4 = 4;
  INT_5 = 5;
  INT_6 = 6;
  INT_7 = 7;
  INT_8 = 8;
  INT_9 = 9;
  INT_10 = 10;
  INT_11 = 11;
  INT_12 = 12;
  INT_13 = 13;
  INT_14 = 14;
  INT_15 = 15;
  INT_20 = 20;
  INT_100 = 100;
  INT_255 = 255;
  INT_99999 = 99999;
  INT_10000 = 10000;
  INT_20000 = 20000;

  MENSAGEM_ENTRE_EM_CONTATO_SUPORTE = 'Favor entrar em contato com o suporte. ';

  PRODUTOS_NAO_ENCONTADOS = 'Produto(s) não encontrado(s). ';

  /// <summary>
  /// Constante que armazena as siglas de todos os estados brasileiros e do Distrito Federal.
  /// </summary>
  SIGLA_ESTADOS: TTipoSiglasEstados =
    ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS',
     'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC',
     'SP', 'SE', 'TO');
  SIGLA_IBPTAX = 'IBPTax';
  STRING_VAZIO = '';
  STRING_DEBUG = '\Win32\Debug';
  PASTA_TEST = '\Test';

  TABELAS_IMPORTADA_COM_SUCESSO = 'Tabela(s) importada(s) com sucesso. ';

  ARQUIVO_PASTA_CONF_INI = 'Config\config.ini';

implementation

end.
