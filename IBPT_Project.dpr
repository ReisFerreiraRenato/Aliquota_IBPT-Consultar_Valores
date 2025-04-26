program IBPT_Project;

uses
  Vcl.Forms,
  fMenu in 'fMenu.pas' {Menu},
  uConfiguracao in 'Config\uConfiguracao.pas',
  uConexaoBanco in 'Data\uConexaoBanco.pas',
  uLogErro in 'Utils\uLogErro.pas',
  ArquivoCSV in 'Principal\ArquivoCSV.pas',
  uFuncoes in 'Utils\uFuncoes.pas',
  uArquivoCSVLinha in 'Principal\uArquivoCSVLinha.pas',
  uConstantesGerais in 'Utils\uConstantesGerais.pas',
  uProduto in 'Entidades\uProduto.pas',
  uVariaveisGlobais in 'Utils\uVariaveisGlobais.pas',
  uConstantesBaseDados in 'Utils\uConstantesBaseDados.pas',
  uIRepositorioProduto in 'Interfaces\uIRepositorioProduto.pas',
  uRepositorioProduto in 'Infra\uRepositorioProduto.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMenu, Menu);
  Application.Run;
end.
