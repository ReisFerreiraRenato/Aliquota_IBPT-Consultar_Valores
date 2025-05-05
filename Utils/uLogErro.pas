unit uLogErro;

interface

/// <summary>Registra o erro no arquivo de log</summary>
/// <param name="pMensagem" type="string">Mensagem a ser gravada no arquivo de log.</param>
procedure RegistrarErro(const pMensagem: string);

implementation

uses
  System.SysUtils, System.IOUtils;

const
  NOME_ARQUIVO_LOG = 'conexao_banco_de_dados.log';

procedure RegistrarErro(const pMensagem: string);
begin
  try
    TFile.AppendAllText(NOME_ARQUIVO_LOG, DateTimeToStr(Now) + ' - ' + pMensagem + sLineBreak);
  except
    Writeln('Erro ao gravar no arquivo de log: ' + pMensagem);
  end;
end;

end.
