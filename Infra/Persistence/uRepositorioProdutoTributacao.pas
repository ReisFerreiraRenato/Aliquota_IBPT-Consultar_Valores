unit uRepositorioProdutoTributacao;

interface

uses
  System.SysUtils,
  System.Types,
  uProduto,
  uIRepositorioProduto,
  uConexaoBanco,
  FireDAC.Comp.Client,
  System.Generics.Collections,
  FireDAC.Stan.Param,
  Data.DB,
  uConstantesGerais,
  uFuncoes,
  uVariaveisGlobais,
  uProdutoTributacao,
  uIRepositorioProdutoTributacao,
  uConstantesBaseDados;

type

  /// <summary>
  /// Classe responsável por realizar operações de banco de dados
  /// relacionadas à tabela PRODUTOTRIBUTACAO.
  /// </summary>
  TRepositorioProdutoTributacao = class(TInterfacedObject, IRepositorioProdutoTributacao)
  private
    FConexao: TFDConnection; // Removido TFDConnection

  public
    /// <summary>
    /// Construtor da classe TRepositorioProdutoTributacao.
    /// Recebe a conexão com o banco de dados por injeção de dependência.
    /// </summary>
    /// <param name="pConexao">A conexão com o banco de dados.</param>
    constructor Create(pConexao: TFDConnection);  //Modificado para TFDConnection
    /// <summary>
    /// Destrutor da classe TRepositorioProdutoTributacao.
    /// Libera os recursos utilizados.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Insere um novo registro de tributação de produto no banco de dados.
    /// </summary>
    /// <param name="pProdutoTributacao">Objeto contendo os dados da tributação do produto.</param>
    procedure InserirProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>
    /// Obtém um registro de tributação de produto pelo código do produto.
    /// </summary>
    /// <param name="pCodigoProduto">Código do produto para buscar a tributação.</param>
    /// <returns>Objeto com os dados da tributação do produto, ou nil se não encontrado.</returns>
    function ObterProdutoTributacao
      (const pCodigoProduto: Integer): TProdutoTributacao; overload;

    /// <summary>
    /// Obtém o registro de tributação de produto mais recente por código do produto, NCM e UF.
    /// A busca considera a data de validade (cVIGENCIAFIM) mais recente.
    /// </summary>
    /// <param name="pCodigoProduto">Código do produto.</param>
    /// <param name="pNcm">NCM do produto.</param>
    /// <param name="pUf">UF do produto.</param>
    /// <returns>Objeto com os dados da tributação do produto mais recente, ou nil se não encontrado.</returns>
    function ObterProdutoTributacao
      (const pCodigoProduto: Integer; const pUf: string): TProdutoTributacao; overload;

    /// <summary>
    /// Atualiza um registro de tributação de produto no banco de dados.
    /// </summary>
    /// <param name="pProdutoTributacao">Objeto com os dados da tributação do produto a serem atualizados.</param>
    procedure AtualizarProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>
    /// Exclui um registro de tributação de produto pelo código do produto.
    /// </summary>
    /// <param name="pCodigoProduto">Código do produto para excluir a tributação.</param>
    procedure ExcluirProdutoTributacao(const pCodigoProduto: Integer);

    /// <summary>
    /// Obtém todos os registros de tributação de produtos do banco de dados.
    /// </summary>
    /// <returns>Lista de objetos contendo os dados de tributação dos produtos.</returns>
    function ObterTodosProdutosTributacao: TList<TProdutoTributacao>;

  private
    /// <summary>
    /// Cria um objeto TProdutoTributacao a partir dos dados de um leitor (query).
    /// </summary>
    /// <param name="pFDQuery">Leitor (query) contendo os dados do produto tributação.</param>
    /// <returns>Objeto TProdutoTributacao preenchido com os dados do leitor.</returns>
    function ObterProdutoTributacaoDoLeitor(pFDQuery: TFDQuery): TProdutoTributacao;
  end;

implementation

const
  SQL_PADRAO_PRODUTO_TRIBUTACAO =
    'SELECT '+
    cUF +', '+
    cCCODIGOPRODUTO +', '+
    cEX +', '+
    cTIPO +', '+
    cTRIBNACIONALFEDERAL + ', '+
    cTRIBIMPORTADOSFEDERAL +', ' +
    cTRIBESTADUAL + ', '+
    cTRIBMUNICIPAL + ', '+
    cVIGENCIAINICIO +', '+
    cVIGENCIAFIM +', '+
    cCHAVE +', '+
    cVERSAO+', '+
    cFONTE +
    ' FROM PRODUTOTRIBUTACAO ';
  SQL_WHERE_CCCODIGOPRODUTO =  ' WHERE cCODIGOPRODUTO = :CodigoProduto ';

constructor TRepositorioProdutoTributacao.Create(pConexao: TFDConnection);
begin
  FConexao := pConexao;
end;

destructor TRepositorioProdutoTributacao.Destroy;
begin
  inherited;
end;

procedure TRepositorioProdutoTributacao.InserirProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);
const
  SQL_INSERT_PRODUTO_TRIBUTACAO =
    'INSERT INTO PRODUTOTRIBUTACAO (' +
    'UF, cCODIGOPRODUTO, EX, TIPO, TRIBNACIONALFEDERAL, TRIBIMPORTADOSFEDERAL, ' +
    'TRIBESTADUAL, TRIBMUNICIPAL, VIGENCIAINICIO, VIGENCIAFIM, CHAVE, ' +
    'VERSAO, FONTE) ' +
    ' VALUES (:UF, :CodigoProduto, :Ex, :Tipo, :TribNacionalFederal, ' +
    ':TribImportadosFederal, :TribEstadual, :TribMunicipal, :VigenciaInicio, ' +
    ':VigenciaFim, :Chave, :Versao, :Fonte)';
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_INSERT_PRODUTO_TRIBUTACAO;
    FDQuery.Params.ParamByName(cUF).AsString := pProdutoTributacao.UF;
    FDQuery.Params.ParamByName(cCODIGOPRODUTO).AsInteger := pProdutoTributacao.CODIGOPRODUTO;
    FDQuery.Params.ParamByName(cEX).AsInteger := pProdutoTributacao.EX;
    FDQuery.Params.ParamByName(cTIPO).AsInteger := pProdutoTributacao.TIPO;
    FDQuery.Params.ParamByName(cTRIBNACIONALFEDERAL).AsCurrency := pProdutoTributacao.TRIBNACIONALFEDERAL;
    FDQuery.Params.ParamByName(cTRIBIMPORTADOSFEDERAL).AsCurrency := pProdutoTributacao.TRIBIMPORTADOSFEDERAL;
    FDQuery.Params.ParamByName(cTRIBESTADUAL).AsCurrency := pProdutoTributacao.TRIBESTADUAL;
    FDQuery.Params.ParamByName(cTRIBMUNICIPAL).AsCurrency := pProdutoTributacao.TRIBMUNICIPAL;
    FDQuery.Params.ParamByName(cVIGENCIAINICIO).AsDateTime := pProdutoTributacao.VIGENCIAINICIO;
    FDQuery.Params.ParamByName(cVIGENCIAFIM).AsDateTime := pProdutoTributacao.VIGENCIAFIM;
    FDQuery.Params.ParamByName(cCHAVE).AsString := pProdutoTributacao.CHAVE;
    FDQuery.Params.ParamByName(cVERSAO).AsString := pProdutoTributacao.VERSAO;
    FDQuery.Params.ParamByName(cFONTE).AsString := pProdutoTributacao.FONTE;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProdutoTributacao.ObterProdutoTributacao(const pCodigoProduto: Integer): TProdutoTributacao;

var
  FDQuery: TFDQuery;
begin
  Result := nil;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO_TRIBUTACAO + SQL_WHERE_CCCODIGOPRODUTO;
    FDQuery.Params.ParamByName(cCODIGOPRODUTO).AsInteger := pCodigoProduto;
    FDQuery.Open;
    if not FDQuery.IsEmpty then
    begin
      Result := ObterProdutoTributacaoDoLeitor(FDQuery);
    end;
  finally
    FDQuery.Free;
  end;
end;

procedure TRepositorioProdutoTributacao.AtualizarProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);
const
  SQL_UPDATE_PRODUTOTRIBUTACAO =
    'UPDATE PRODUTOTRIBUTACAO SET ' +
    'UF = :UF, '+
    'EX = :Ex, '+
    'TIPO = :Tipo, ' +
    'TRIBNACIONALFEDERAL = :TribNacionalFederal, ' +
    'TRIBIMPORTADOSFEDERAL = :TribImportadosFederal, ' +
    'TRIBESTADUAL = :TribEstadual, ' +
    'TRIBMUNICIPAL = :TribMunicipal, ' +
    'VIGENCIAINICIO = :VigenciaInicio, ' +
    'VIGENCIAFIM = :VigenciaFim, ' +
    'CHAVE = :Chave, ' +
    'VERSAO = :Versao, '+
    'FONTE = :Fonte ' ;
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_UPDATE_PRODUTOTRIBUTACAO + SQL_WHERE_CCCODIGOPRODUTO;
    FDQuery.Params.ParamByName(cCODIGOPRODUTO).AsInteger := pProdutoTributacao.CODIGOPRODUTO;
    FDQuery.Params.ParamByName(cUF).AsString := pProdutoTributacao.UF;
    FDQuery.Params.ParamByName(cEX).AsInteger := pProdutoTributacao.EX;
    FDQuery.Params.ParamByName(cTIPO).AsInteger := pProdutoTributacao.TIPO;
    FDQuery.Params.ParamByName(cTRIBNACIONALFEDERAL).AsCurrency := pProdutoTributacao.TRIBNACIONALFEDERAL;
    FDQuery.Params.ParamByName(cTRIBIMPORTADOSFEDERAL).AsCurrency := pProdutoTributacao.TRIBIMPORTADOSFEDERAL;
    FDQuery.Params.ParamByName(cTRIBESTADUAL).AsCurrency := pProdutoTributacao.TRIBESTADUAL;
    FDQuery.Params.ParamByName(cTRIBMUNICIPAL).AsCurrency := pProdutoTributacao.TRIBMUNICIPAL;
    FDQuery.Params.ParamByName(cVIGENCIAINICIO).AsDateTime := pProdutoTributacao.VIGENCIAINICIO;
    FDQuery.Params.ParamByName(cVIGENCIAFIM).AsDateTime := pProdutoTributacao.VIGENCIAFim;
    FDQuery.Params.ParamByName(cCHAVE).AsString := pProdutoTributacao.CHAVE;
    FDQuery.Params.ParamByName(cVERSAO).AsString := pProdutoTributacao.VERSAO;
    FDQuery.Params.ParamByName(cFONTE).AsString := pProdutoTributacao.FONTE;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

procedure TRepositorioProdutoTributacao.ExcluirProdutoTributacao(const pCodigoProduto: Integer);
const
  SQL_DELETE_PRODUTOTRIBUTACAO = 'DELETE FROM PRODUTOTRIBUTACAO ';
var
  FDQuery: TFDQuery;
begin
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_DELETE_PRODUTOTRIBUTACAO + SQL_WHERE_CCCODIGOPRODUTO;
    FDQuery.Params.ParamByName(cCODIGOPRODUTO).AsInteger := pCodigoProduto;
    FDQuery.ExecSQL;
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProdutoTributacao.ObterTodosProdutosTributacao: TList<TProdutoTributacao>;
var
  FDQuery: TFDQuery;
  ProdutoTributacao: TProdutoTributacao;
begin
  Result := TList<TProdutoTributacao>.Create;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO_TRIBUTACAO;
    FDQuery.Open;
    while not FDQuery.Eof do
    begin
      ProdutoTributacao := ObterProdutoTributacaoDoLeitor(FDQuery);
      Result.Add(ProdutoTributacao);
      FDQuery.Next;
    end;
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProdutoTributacao.ObterProdutoTributacao
  (const pCodigoProduto: Integer; const pUf: string): TProdutoTributacao;
const
  SQL_AND_UF = 'AND UF = :UF ';
  SQL_ORDER_BY_VIGENCIA_FIM_DESC = 'ORDER BY VIGENCIAFIM DESC';

var
  FDQuery: TFDQuery;
begin
  Result := nil;
  FDQuery := TFDQuery.Create(nil);
  try
    FDQuery.Connection := FConexao;
    FDQuery.SQL.Text := SQL_PADRAO_PRODUTO_TRIBUTACAO + SQL_WHERE_CCCODIGOPRODUTO +
                        SQL_AND_UF + SQL_ORDER_BY_VIGENCIA_FIM_DESC;
    FDQuery.Params.ParamByName(cCODIGOPRODUTO).AsInteger := pCodigoProduto;
    FDQuery.Params.ParamByName(cUF).AsString := Trim(pUf);
    FDQuery.Open;
    if not FDQuery.IsEmpty then
    begin
      Result := ObterProdutoTributacaoDoLeitor(FDQuery);
    end;
  finally
    FDQuery.Free;
  end;
end;

function TRepositorioProdutoTributacao.ObterProdutoTributacaoDoLeitor(
  pFDQuery: TFDQuery): TProdutoTributacao;
begin
  Result := TProdutoTributacao.Create;
  Result.UF := pFDQuery.FieldByName(cUF).AsString;
  Result.CODIGOPRODUTO := pFDQuery.FieldByName(cCCODIGOPRODUTO).AsInteger;
  Result.EX := pFDQuery.FieldByName(cEX).AsInteger;
  Result.TIPO := pFDQuery.FieldByName(cTIPO).AsInteger;
  Result.TRIBNACIONALFEDERAL := pFDQuery.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency;
  Result.TRIBIMPORTADOSFEDERAL := pFDQuery.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency;
  Result.TRIBESTADUAL := pFDQuery.FieldByName(cTRIBESTADUAL).AsCurrency;
  Result.TRIBMUNICIPAL := pFDQuery.FieldByName(cTRIBMUNICIPAL).AsCurrency;
  Result.VIGENCIAINICIO := pFDQuery.FieldByName(cVIGENCIAINICIO).AsDateTime;
  Result.VIGENCIAFIM := pFDQuery.FieldByName(cVIGENCIAFIM).AsDateTime;
  Result.CHAVE := pFDQuery.FieldByName(cCHAVE).AsString;
  Result.VERSAO := pFDQuery.FieldByName(cVERSAO).AsString;
  Result.FONTE := pFDQuery.FieldByName(cFONTE).AsString;
end;

end.
