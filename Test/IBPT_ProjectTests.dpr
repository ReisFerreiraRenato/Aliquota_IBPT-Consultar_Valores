program IBPT_ProjectTests;
{

  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.

}

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  DUnitTestRunner,
  uRepositorioProduto in '..\Infra\Persistence\uRepositorioProduto.pas',
  uConstantesGerais in '..\Utils\uConstantesGerais.pas',
  uFuncoes in '..\Utils\uFuncoes.pas',
  uLogErro in '..\Utils\uLogErro.pas',
  uVariaveisGlobais in '..\Utils\uVariaveisGlobais.pas',
  uConstantesBaseDados in '..\Utils\uConstantesBaseDados.pas',
  uIRepositorioProduto in '..\Infra\Persistence\uIRepositorioProduto.pas',
  uProduto in '..\Entidades\uProduto.pas',
  uConfiguracao in '..\Config\uConfiguracao.pas',
  uTestuRepositorioProduto in 'uTestuRepositorioProduto.pas',
  uConstantesTeste in 'uConstantesTeste.pas',
  uTestRepositorioProdutoTributacao in 'uTestRepositorioProdutoTributacao.pas',
  uRepositorioProdutoTributacao in '..\Infra\Persistence\uRepositorioProdutoTributacao.pas',
  uProdutoTributacao in '..\Entidades\uProdutoTributacao.pas',
  uIRepositorioProdutoTributacao in '..\Infra\Persistence\uIRepositorioProdutoTributacao.pas',
  uImportadorTabelas in '..\Adapters\uImportadorTabelas.pas',
  uTestArquivoCSV in 'uTestArquivoCSV.pas',
  uArquivoCSV in '..\Comum\uArquivoCSV.pas',
  uArquivoCSVLinha in '..\Entidades\uArquivoCSVLinha.pas',
  uTestImportadorTabelas in 'uTestImportadorTabelas.pas',
  uConexaoBanco in '..\Infra\Persistence\uConexaoBanco.pas',
  uCalculoTributosProduto in '..\UseCase\uCalculoTributosProduto.pas',
  uTestuCalculoTributosProduto in 'uTestuCalculoTributosProduto.pas';

{$R *.RES}

begin
  DUnitTestRunner.RunRegisteredTests;
end.

