unit uTestuRepositorioProduto;
{

  Delphi DUnit Test Case
  ----------------------
  Esta unidade testa os métodos da classe TRepositorioProdutos.

}

interface

uses
  TestFramework, uConstantesGerais, uIRepositorioProduto, System.Types,
  uRepositorioProduto, System.SysUtils, System.Generics.Collections, uConexaoBanco,
  uFuncoes, uProduto, Data.DB, uConfiguracao, uVariaveisGlobais, FireDAC.DApt,
  FireDAC.Stan.Async, FireDAC.Comp.Client, FireDAC.Comp.UI, FireDAC.Stan.Def,
  FireDAC.Stan.Error, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Pool, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, uConstantesTeste;

type

  TestTRepositorioProduto = class(TTestCase)
  strict private
    FRepositorioProduto: TRepositorioProduto;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestBuscarPorCodigo;
    procedure TestBuscarPorDescricao;
    procedure TestBuscarPorNcm;
    procedure TestBuscarPorCodigo_ProdutoNaoEncontrado;
    procedure TestBuscarPorDescricao_ProdutoNaoEncontrado;
    procedure TestBuscarPorNcm_ProdutoNaoEncontrado;
  end;

implementation

{ TestTRepositorioProduto }

procedure TestTRepositorioProduto.SetUp;
begin
  CarregarConfiguracao;
  FRepositorioProduto := TRepositorioProduto.Create(gConexaoBanco);
end;

procedure TestTRepositorioProduto.TearDown;
begin
  FRepositorioProduto.Free;
  FRepositorioProduto := nil;
  gConexaoBanco.FecharConexao;
  gConexaoBanco.Free;
  gConexaoBanco := nil;
end;

procedure TestTRepositorioProduto.TestBuscarPorCodigo;
var
  ReturnValue: TProduto;
  codigo: Integer;
begin
  // Arrange: Configura os dados de teste
  codigo := CODIGO_BUSCAR_POR_CODIGO;

  // Act: Chama o método a ser testado
  ReturnValue := FRepositorioProduto.BuscarPorCodigo(codigo);

  // Assert: Verifica se o resultado é o esperado
  Check(Assigned(ReturnValue), PRODUTO_NAO_ENCONTRADO_CODIGO + IntToStr(codigo));
  if Assigned(ReturnValue) then
  begin
    CheckEquals(codigo, ReturnValue.Codigo, CODIGO_PRODUTO_INCORRETO);
  end;
end;

procedure TestTRepositorioProduto.TestBuscarPorDescricao;
var
  ReturnValue: TArray<TProduto>;
  descricao: string;
begin
  // Arrange: Configura os dados de teste
  descricao := DESCRICAO_TESTE_PADRAO;

  // Act: Chama o método a ser testado
  ReturnValue := FRepositorioProduto.BuscarPorDescricao(descricao);

  // Assert: Verifica se o resultado é o esperado
  Check(Length(ReturnValue) > 0, PRODUTO_NAO_ENCONTRADO_DESCRICAO + QuotedStr(descricao));

end;

procedure TestTRepositorioProduto.TestBuscarPorNcm;
var
  ReturnValue: TArray<TProduto>;
  ncm: string;
begin
  // Arrange: Configura os dados de teste
  ncm := NCM_BUSCAR_POR_NCM;

  // Act: Chama o método a ser testado
  ReturnValue := FRepositorioProduto.BuscarPorNcm(ncm);

  // Assert: Verifica se o resultado é o esperado
  Check(Length(ReturnValue) > 0, PRODUTO_NAO_ENCONTRADO_NCM + QuotedStr(ncm));
  if Length(ReturnValue) > 0 then
  begin
    CheckEquals(ncm, ReturnValue[0].Ncm, NCM_PRODUTO_INCORRETO);
  end;

end;

procedure TestTRepositorioProduto.TestBuscarPorCodigo_ProdutoNaoEncontrado;
var
  codigo: Integer;
  returnValue : TProduto;
begin
  // Arrange: Configura os dados de teste para um produto que NÃO existe
  codigo := CODIGO_PRODUTO_NAO_ENCONTRADO;

  // Act: Chama o método a ser testado
  returnValue := FRepositorioProduto.BuscarPorCodigo(codigo);

  // Assert: Verifica se o resultado é o esperado
  Check(not Assigned(ReturnValue), PRODUTO_NAO_ENCONTRADO_CODIGO + IntToStr(codigo));
end;

procedure TestTRepositorioProduto.TestBuscarPorDescricao_ProdutoNaoEncontrado;
var
  returnValue: TArray<TProduto>;
  descricao: string;
begin
  // Arrange: Configura os dados para buscar uma descrição que não existe
  descricao := DESCRICAO_PRODUTO_INEXISTENTE;

  // Act
  returnValue := FRepositorioProduto.BuscarPorDescricao(descricao);

  // Assert
  Check(Length(returnValue) = 0, PRODUTO_NAO_ENCONTRADO_DESCRICAO + QuotedStr(descricao));
end;

procedure TestTRepositorioProduto.TestBuscarPorNcm_ProdutoNaoEncontrado;
var
  returnValue: TArray<TProduto>;
  ncm: string;
begin
  // Arrange
  ncm := NCM_BUSCAR_NCM_NAO_ENCONTRADO;

  // Act
  returnValue := FRepositorioProduto.BuscarPorNcm(ncm);

  // Assert
  Check(Length(returnValue) = 0, PRODUTO_NAO_ENCONTRADO_NCM + ncm);
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTRepositorioProduto.Suite);
end.

