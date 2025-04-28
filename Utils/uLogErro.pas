unit uLogErro;

interface

procedure RegistrarErro(const Mensagem: string);

implementation

uses
  System.SysUtils, System.IOUtils;

const
  NOME_ARQUIVO_LOG = 'conexao_banco_de_dados.log';

procedure RegistrarErro(const Mensagem: string);
begin
  try
    TFile.AppendAllText(NOME_ARQUIVO_LOG, DateTimeToStr(Now) + ' - ' + Mensagem + sLineBreak);
  except
    Writeln('Erro ao gravar no arquivo de log: ' + Mensagem);
  end;
end;

end.
