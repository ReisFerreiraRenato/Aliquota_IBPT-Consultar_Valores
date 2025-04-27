unit uConfiguracao;

interface

uses
  System.SysUtils,
  System.IniFiles,
  uConexaoBanco,
  uVariaveisGlobais,
  uConstantesGerais,
  uConstantesBaseDados,
  uLogErro,
  ufuncoes,
  Vcl.Forms;

procedure CarregarConfiguracao;

implementation

procedure CarregarConfiguracao;
var
  ArquivoIni: TIniFile;
  caminhoArquivo: string;
  tipoBaseDados, enderecoIp, nomeBancoDados, usuarioBancoDados, senhaBancoDados: string;
begin
  caminhoArquivo := ExtractFilePath(Application.ExeName).Replace(STRING_DEBUG, STRING_VAZIO).Replace(PASTA_TEST,STRING_VAZIO);
  caminhoArquivo := IncludeTrailingPathDelimiter(caminhoArquivo) + ARQUIVO_PASTA_CONF_INI;

  if not FileExists(caminhoArquivo) then
  begin
    RegistrarErro(ARQUIVO_CONFIGURACAO_NAO_ENCONTRADO + caminhoArquivo);
    Halt(1);
  end;

  ArquivoIni := TIniFile.Create(caminhoArquivo);
  try
    tipoBaseDados := ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, TIPO_BASE_DADOS, STRING_VAZIO);
    if tipoBaseDados = STRING_VAZIO then
      RegistrarErro(TIPO_BASE_DADOS);

    enderecoIp := ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, ENDERECO_BASE_DADOS, STRING_VAZIO);
    if enderecoIp = STRING_VAZIO then
      RegistrarErro(ENDERECO_BASE_DADOS);

    nomeBancoDados := ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, NOME_BASE_DADOS, STRING_VAZIO);
    if nomeBancoDados = STRING_VAZIO then
      RegistrarErro(NOME_BASE_DADOS);

    usuarioBancoDados := ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, USUARIO_BASE_DADOS, STRING_VAZIO);
    if usuarioBancoDados = STRING_VAZIO then
      RegistrarErro(USUARIO_BASE_DADOS);

    senhaBancoDados := ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, SENHA_BASE_DADOS, STRING_VAZIO);
    if senhaBancoDados = STRING_VAZIO then
      RegistrarErro(SENHA_BASE_DADOS);

    // Criar conexao
    gConexaoBanco := TConexaoBanco.Create(enderecoIp, nomeBancoDados,
      usuarioBancoDados, senhaBancoDados, tipoBaseDados);
  finally
    ArquivoIni.Free;
  end;
end;

end.
