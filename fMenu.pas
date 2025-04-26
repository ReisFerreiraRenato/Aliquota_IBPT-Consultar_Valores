unit fMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons;

type
  TMenu = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure CarregarVariaveisGlobais;
    procedure TratarErro(const pParametroVazio: String);
  public
    { Public declarations }
  end;

var
  Menu: TMenu;

implementation

{$R *.dfm}

uses
  System.IniFiles, uConfiguracao, uConexaoBanco, uVariaveisGlobais,
  uConstantesGerais, uLogErro, uConstantesBaseDados;

{ TMenu }

procedure TMenu.CarregarVariaveisGlobais;
const
  PASTANOME_ARQUIVO = 'Config\config.ini';
var
    ArquivoIni: TIniFile;
    caminhoArquivo,
    tipoBaseDados, enderecoIp, nomeBancoDados, usuarioBancoDados,
    senhaBancoDados: string;
begin
  caminhoArquivo := ExtractFilePath(ParamStr(0)).Replace('Win32\Debug\','');
  caminhoArquivo := IncludeTrailingPathDelimiter(caminhoArquivo) + PASTANOME_ARQUIVO;

  if not FileExists(caminhoArquivo) then
  begin
    ShowMessage(ARQUIVO_CONFIGURACAO_NAO_ENCONTRADO + caminhoArquivo);
    Halt(1);
  end;


  ArquivoIni := TIniFile.Create(caminhoArquivo);
  caminhoArquivo := ArquivoIni.ToString;
  try
    tipoBaseDados :=
      ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, TIPO_BASE_DADOS, STRING_VAZIO);
    if tipoBaseDados = STRING_VAZIO then
      TratarErro(TIPO_BASE_DADOS);

    enderecoIp :=
      ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, ENDERECO_BASE_DADOS, STRING_VAZIO);
    if enderecoIp = STRING_VAZIO then
      TratarErro(ENDERECO_BASE_DADOS);

    nomeBancoDados :=
      ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, NOME_BASE_DADOS, STRING_VAZIO);
    if nomeBancoDados = STRING_VAZIO then
      TratarErro(NOME_BASE_DADOS);

    usuarioBancoDados :=
      ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, USUARIO_BASE_DADOS, STRING_VAZIO);
    if usuarioBancoDados = STRING_VAZIO then
      TratarErro(USUARIO_BASE_DADOS);

    senhaBancoDados :=
      ArquivoIni.ReadString(SECAO_INI_BASE_DADOS, SENHA_BASE_DADOS, STRING_VAZIO);
    if senhaBancoDados = STRING_VAZIO then
      TratarErro(SENHA_BASE_DADOS);

    //criar conexao
    gConexaoBanco := TConexaoBanco.Create(enderecoIp, nomeBancoDados,
      usuarioBancoDados, senhaBancoDados, tipoBaseDados);
  finally
    ArquivoIni.Free;
  end;

end;

procedure TMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //destruir conexao
  gConexaoBanco.Destroy;
end;

procedure TMenu.FormCreate(Sender: TObject);
begin
  CarregarVariaveisGlobais;
end;

procedure TMenu.SpeedButton1Click(Sender: TObject);
begin
  if gConexaoBanco.TestarConexao then
    ShowMessage('Conexão testada com sucesso')
  else
    ShowMessage('Conexão com erro');
end;

procedure TMenu.TratarErro(const pParametroVazio: String);
begin
  RegistrarErro(ERRO_PARAMETRO_VAZIO + pParametroVazio);
end;

end.
