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
  FireDAC.Stan.Pool, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  uConstantesTeste;

type

  TestTRepositorioProduto = class(TTestCase)
  strict private
    FRepositorioProduto: TRepositorioProduto;
    FProdutoInserido: TProduto;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    /// <summary>
    /// Teste buscar produto por código
    /// </summary>
    procedure TestBuscarPorCodigo;

    /// <summary>
    /// Teste buscar por descrição
    /// </summary>
    procedure TestBuscarPorDescricao;

    /// <summary>
    /// Teste buscar produto por NCM
    /// </summary>
    procedure TestBuscarPorNcm;

    /// <summary>
    /// Teste buscar por código produto não encontrado
    /// </summary>
    procedure TestBuscarPorCodigo_ProdutoNaoEncontrado;

    /// <summary>
    /// Teste buscar por descrição produto não enconstrado
    /// </summary>
    procedure TestBuscarPorDescricao_ProdutoNaoEncontrado;

    /// <summary>
    /// Teste buscar produto por NCM produto não encontrado
    /// </summary>
    procedure TestBuscarPorNcm_ProdutoNaoEncontrado;

    /// <summary>
    /// Teste Inserir
    /// </summary>
    procedure TestInserir;

    /// <summary>
    /// Teste Excluir
    /// </summary>
    procedure TestExcluir;

    /// <summary>
    /// Teste Excluir produto não encontrado
    /// </summary>
    procedure TestExcluir_ProdutoNaoEncontrado;
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
  Check(Length(ReturnValue) > INT_ZERO, PRODUTO_NAO_ENCONTRADO_DESCRICAO + QuotedStr(descricao));

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
  Check(Length(ReturnValue) > INT_ZERO, PRODUTO_NAO_ENCONTRADO_NCM + QuotedStr(ncm));
  if Length(ReturnValue) > INT_ZERO then
  begin
    CheckEquals(ncm, ReturnValue[INT_ZERO].Ncm, NCM_PRODUTO_INCORRETO);
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
  Check(Length(returnValue) = INT_ZERO, PRODUTO_NAO_ENCONTRADO_DESCRICAO + QuotedStr(descricao));
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
  Check(Length(returnValue) = INT_ZERO, PRODUTO_NAO_ENCONTRADO_NCM + ncm);
end;

procedure TestTRepositorioProduto.TestInserir;
var
  produto: TProduto;
  codigoInserido: Integer;
begin
  // Arrange: Cria um novo produto para inserir
  codigoInserido := Random(INT_99999) + INT_10000;
  produto := TProduto.Create(codigoInserido,
                             NOME_PRODUTO_TESTE_INSERIR + IntToStr(codigoInserido),
                             CODIGO_PRODUTO_TESTE_NCM);

  // Act: Insere o produto no banco de dados
  FRepositorioProduto.Inserir(produto);
  FProdutoInserido := produto;

  // Assert: Verifica se o produto foi inserido corretamente
  Check(Assigned(FProdutoInserido), PRODUTO_NAO_INSERIDO);
  if Assigned(FProdutoInserido) then
  begin
    CheckEquals(codigoInserido, FProdutoInserido.Codigo, CODIGO_PRODUTO_INSERIO_INCORRETO);
    // Busca o produto por código para garantir que foi inserido no banco
    var produtoDoBanco := FRepositorioProduto.BuscarPorCodigo(codigoInserido);
    Check(Assigned(produtoDoBanco), PRODUTO_NAO_ENCONTRADO_APOS_INSERCAO );
    if Assigned(produtoDoBanco) then
      produtoDoBanco.Free;
  end;
end;

procedure TestTRepositorioProduto.TestExcluir;
var
  produto: TProduto;
  codigoExcluir: Integer;
begin
  // Arrange: Insere um produto para excluir
  codigoExcluir := Random(INT_99999) + INT_20000;
  produto := TProduto.Create(codigoExcluir, NOME_PRODUTO_TESTE_EXCLUIR, CODIGO_PRODUTO_TESTE_NCM2);
  FRepositorioProduto.Inserir(produto);
  FProdutoInserido := produto; // Armazena para o TearDown

  // Act: Exclui o produto
  FRepositorioProduto.Excluir(codigoExcluir);
  FProdutoInserido := nil; // Remove a referência, o produto foi excluído

  // Assert: Verifica se o produto foi excluído
  var produtoExcluido := FRepositorioProduto.BuscarPorCodigo(codigoExcluir);
  Check(not Assigned(produtoExcluido), PRODUTO_NAO_EXCLUIDO);

  produto.Free;
end;

procedure TestTRepositorioProduto.TestExcluir_ProdutoNaoEncontrado;
var
  codigoExcluir: Integer;
begin
  // Arrange: Tenta excluir um produto que não existe
  codigoExcluir := CODIGO_PRODUTO_NAO_ENCONTRADO;

  // Act: Tenta excluir o produto inexistente
  // Assert: Verifica se a exclusão não causa erro (ou causa um erro esperado)
  // Neste caso, o teste passa se a chamada não levantar uma exceção.
  try
    FRepositorioProduto.Excluir(codigoExcluir);
    // Se chegar aqui, a exclusão não causou erro, o que é o comportamento esperado.
    Check(True, EXCLUIR_PRODUTO_NAO_EXISTENTE_NAO_CAUSOU_ERRO);
  except
    on E: Exception do
    begin
      // Se chegar aqui, a exclusão causou um erro.  Você pode querer verificar
      Check(False, EXCLUIR_PRODUTO_NAO_EXISTENTE_NAO_CAUSOU_ERRO + E.Message);
    end;
  end;
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTRepositorioProduto.Suite);
end.

