unit uBuscarProduto;

interface

uses System.SysUtils, uProduto, uRepositorioProduto, uVariaveisGlobais, uLogErro,
     uConstantesGerais, FireDAC.Stan.Error;

/// <summary>Obtém o produto por descricao. </summary>
/// <param name="pDescricao" type="String">Descrição para buscar o produto</param>
/// <returns>Retorna os produtos(TArray<TProduto>).</returns>
function BuscarProdutosPorDescricao(pDescricao: string): TArray<TProduto>;

/// <summary>Obtém o produto por codigo. </summary>
/// <param name="pCodigo" type="Integer">Código para buscar o produto</param>
/// <returns>Retorna o produto(TProduto).</returns>
function BuscarProdutoPorCodigo(pCodigo: integer): TProduto;

/// <summary>Obtém o produto por descricao. </summary>
/// <param name="pNCM" type="Integer">Código NCM para buscar o produto</param>
/// <returns>Retorna os produtos (TArray<TProduto>).</returns>
function BuscarProdutoPorNCM(pNCM: string): TArray<TProduto>;

implementation

uses uFuncoes;

function BuscarProdutosPorDescricao(pDescricao: string): TArray<TProduto>;
var
  produtos: TArray<TProduto>;
  reposisorioProdutos: TRepositorioProduto;
begin
  reposisorioProdutos := nil;
  try
    try
      reposisorioProdutos := TRepositorioProduto.Create(gConexaoBanco);
      produtos := reposisorioProdutos.BuscarPorDescricao(pDescricao);
      Result := produtos;
    except
      on E: EFDDBEngineException do
      begin
        TratarErroConexao(E);
        raise Exception.Create(ERRO_CONECTAR_BASE_DADOS + MENSAGEM_ENTRE_EM_CONTATO_SUPORTE);
        Result := nil;
      end;
      on E: Exception do
      begin
        TratarErro(E);
        Result := nil;
      end;
    end;
  finally
    if Assigned(reposisorioProdutos) then
      reposisorioProdutos.Destroy;
  end;
end;

function BuscarProdutoPorCodigo(pCodigo: integer): TProduto;
var
  produto: TProduto;
  reposisorioProdutos: TRepositorioProduto;
begin
  reposisorioProdutos := nil;
  try
    try
      reposisorioProdutos := TRepositorioProduto.Create(gConexaoBanco);
      produto := reposisorioProdutos.BuscarPorCodigo(pCodigo);
      Result := produto;
    except
      on E: EFDDBEngineException do
      begin
        TratarErroConexao(E);
        raise Exception.Create(ERRO_CONECTAR_BASE_DADOS + MENSAGEM_ENTRE_EM_CONTATO_SUPORTE);
        Result := nil;
      end;
      on E: Exception do
      begin
        TratarErro(E);
        Result := nil;
      end;
    end;
  finally
    if Assigned(reposisorioProdutos) then
      reposisorioProdutos.Destroy;
  end;
end;

function BuscarProdutoPorNCM(pNCM: string): TArray<TProduto>;
var
  produtos: TArray<TProduto>;
  reposisorioProdutos: TRepositorioProduto;
begin
  reposisorioProdutos := nil;
  produtos := nil;
  try
    try
      reposisorioProdutos := TRepositorioProduto.Create(gConexaoBanco);
      produtos := reposisorioProdutos.BuscarPorNcm(pNCM);
      Result := produtos;
    except
      on E: EFDDBEngineException do
      begin
        TratarErroConexao(E);
        raise Exception.Create(ERRO_CONECTAR_BASE_DADOS + MENSAGEM_ENTRE_EM_CONTATO_SUPORTE);
        Result := nil;
      end;
      on E: Exception do
      begin
        TratarErro(E);
        Result := nil;
      end;
    end;
  finally
    if Assigned(reposisorioProdutos) then
      reposisorioProdutos.Destroy;
  end;
end;

end.
