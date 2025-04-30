program IBPT_Project;

uses
  Vcl.Forms,
  uConfiguracao in 'Config\uConfiguracao.pas',
  uLogErro in 'Utils\uLogErro.pas',
  uFuncoes in 'Utils\uFuncoes.pas',
  uConstantesGerais in 'Utils\uConstantesGerais.pas',
  uProduto in 'Entidades\uProduto.pas',
  uVariaveisGlobais in 'Utils\uVariaveisGlobais.pas',
  uConstantesBaseDados in 'Utils\uConstantesBaseDados.pas',
  uArquivoCSVLinha in 'Entidades\uArquivoCSVLinha.pas',
  uArquivoCSVLinhaProduto in 'Entidades\uArquivoCSVLinhaProduto.pas',
  uProdutoTributacao in 'Entidades\uProdutoTributacao.pas',
  uImportadorTabelas in 'Adapters\uImportadorTabelas.pas',
  uConexaoBanco in 'Infra\Persistence\uConexaoBanco.pas',
  fMenu in 'Interfaces\UI\fMenu.pas' {Menu},
  uIRepositorioProduto in 'Infra\Persistence\uIRepositorioProduto.pas',
  uIRepositorioProdutoTributacao in 'Infra\Persistence\uIRepositorioProdutoTributacao.pas',
  uRepositorioProduto in 'Infra\Persistence\uRepositorioProduto.pas',
  uRepositorioProdutoTributacao in 'Infra\Persistence\uRepositorioProdutoTributacao.pas',
  uArquivoCSV in 'Comum\uArquivoCSV.pas',
  uCalculoTributosProduto in 'UseCase\uCalculoTributosProduto.pas',
  fBuscarProduto in 'Interfaces\UI\fBuscarProduto.pas' {BuscarProduto},
  uBuscarProduto in 'UseCase\uBuscarProduto.pas',
  uBuscarTributacaoProduto in 'UseCase\uBuscarTributacaoProduto.pas',
  uBuscarcalculoTributosProduto in 'UseCase\uBuscarcalculoTributosProduto.pas',
  uThreadImportarArquivos in 'UseCase\uThreadImportarArquivos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMenu, Menu);
  Application.CreateForm(TBuscarProduto, BuscarProduto);
  Application.Run;
end.
