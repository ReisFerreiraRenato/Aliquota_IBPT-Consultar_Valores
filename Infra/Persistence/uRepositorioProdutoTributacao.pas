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
  /// Classe respons�vel por realizar opera��es de banco de dados
  /// relacionadas � tabela PRODUTOTRIBUTACAO.
  /// </summary>
  TRepositorioProdutoTributacao = class(TInterfacedObject, IRepositorioProdutoTributacao)
  private
    FConexao: TFDConnection;

  public
    /// <summary> Construtor da classe. Recebe a conex�o com o banco de dados por inje��o de depend�ncia. </summary>
    /// <param name="pConexao" type="TFDConnection">A conex�o com o banco de dados.</param>
    constructor Create(pConexao: TFDConnection);

    /// <summary>Destrutor da classe. Libera os recursos utilizados. </summary>
    destructor Destroy; override;

    /// <summary>Insere um novo registro de tributa��o de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto contendo os dados da tributa��o do produto.</param>
    procedure InserirProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Obt�m um registro de tributa��o de produto pelo c�digo do produto. </summary>
    /// <param name="pCodigoProduto" type="pCodigoProduto">C�digo do produto para buscar a tributa��o.</param>
    /// <returns>Objeto com os dados da tributa��o do produto, ou nil se n�o encontrado.</returns>
    function ObterProdutoTributacao
      (const pCodigoProduto: Integer): TProdutoTributacao; overload;

    /// <summary>Obt�m o registro de tributa��o de produto mais recente por c�digo do produto, NCM e UF. A busca considera a data de validade (VigenciaFim) mais recente. </summary>
    /// <param name="pCodigoProduto" type="Integer">C�digo do produto.</param>
    /// <param name="pNcm" type="String">Codigo NCM do produto.</param>
    /// <param name="pUf" type="string">UF do produto.</param>
    /// <returns>Objeto com os dados da tributa��o do produto mais recente, ou nil se n�o encontrado.</returns>
    function ObterProdutoTributacao
      (const pCodigoProduto: Integer; const pUf: string): TProdutoTributacao; overload;

    /// <summary>Atualiza um registro de tributa��o de produto no banco de dados. </summary>
    /// <param name="pProdutoTributacao" type="TProdutoTributacao">Objeto com os dados da tributa��o do produto a serem atualizados.</param>
    procedure AtualizarProdutoTributacao(const pProdutoTributacao: TProdutoTributacao);

    /// <summary>Exclui um registro de tributa��o de produto pelo c�digo do produto. </summary>
    /// <param name="pCodigoProduto" type="Integer">C�digo do produto para excluir a tributa��o.</param>
    procedure ExcluirProdutoTributacao(const pCodigoProduto: Integer);

    /// <summary>Obt�m todos os registros de tributa��o de produtos do banco de dados. </summary>
    /// <returns>Lista de objetos contendo os dados de tributa��o dos produtos.</returns>
    function ObterTodosProdutosTributacao: TList<TProdutoTributacao>;

  private
    /// <summary> Cria um objeto TProdutoTributacao a partir dos dados de um leitor (query). </summary>
    /// <param name="pFDQuery" type="TFDQuery">Leitor (query) contendo os dados do produto tributa��o.</param>
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
  SQL_ORDER_BY_VIGENCIA_FIM_DESC = ' ORDER BY VIGENCIAFIM DESC';

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
  Result.CodigoProduto := pFDQuery.FieldByName(cCCODIGOPRODUTO).AsInteger;
  Result.Ex := pFDQuery.FieldByName(cEX).AsInteger;
  Result.Tipo := pFDQuery.FieldByName(cTIPO).AsInteger;
  Result.TribNacionalFederal := pFDQuery.FieldByName(cTRIBNACIONALFEDERAL).AsCurrency;
  Result.TribImportadosFederal := pFDQuery.FieldByName(cTRIBIMPORTADOSFEDERAL).AsCurrency;
  Result.TribEstadual := pFDQuery.FieldByName(cTRIBESTADUAL).AsCurrency;
  Result.TribMunicipal := pFDQuery.FieldByName(cTRIBMUNICIPAL).AsCurrency;
  Result.VigenciaInicio := pFDQuery.FieldByName(cVIGENCIAINICIO).AsDateTime;
  Result.VigenciaFim := pFDQuery.FieldByName(cVIGENCIAFIM).AsDateTime;
  Result.Chave := pFDQuery.FieldByName(cCHAVE).AsString;
  Result.Versao := pFDQuery.FieldByName(cVERSAO).AsString;
  Result.Fonte := pFDQuery.FieldByName(cFONTE).AsString;
end;

end.
