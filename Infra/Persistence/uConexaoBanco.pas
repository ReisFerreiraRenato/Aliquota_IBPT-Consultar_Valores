unit uConexaoBanco;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Def,
  FireDAC.Phys.FB;

type
  /// <summary>Classe para encapsular a l�gica de conex�o com o banco de dados. </summary>
  TConexaoBanco = class
  private
    FConexao: TFDConnection;
    FEnderecoIP: string;
    FNomeBancoDados: string;
    FUsuarioBanco: string;
    FSenhaBanco: string;
    FTipoBaseDados: string;
  public
    /// <summary>Obt�m a conex�o. </summary>
    property Conexao: TFDConnection read FConexao;

    /// <summary>Obt�m ou define o endereco IP. </summary>
    property EnderecoIP: string read FEnderecoIP write FEnderecoIP;

    /// <summary>Obt�m ou define o nome/caminho base dados. </summary>
    property NomeBancoDados: string read FNomeBancoDados write FNomeBancoDados;

    /// <summary>Obt�m ou define o usuario da base de dados. </summary>
    property Usuario: string read FUsuarioBanco write FUsuarioBanco;

    /// <summary>Obt�m ou define a senha do usuario da base de dados. </summary>
    property Senha: string read FSenhaBanco write FSenhaBanco;

    /// <summary>Obt�m ou define o tipo da base de dados. </summary>
    property TipoBaseDados: string read FTipoBaseDados write FTipoBaseDados;

    /// <summary>Cria uma nova inst�ncia da classe TConexaoBanco. </summary>
    constructor Create; overload;

    /// <summary>Cria e configura uma nova inst�ncia da classe TConexaoBanco. </summary>
    /// <Param name="pEnderecoIP" type="String">Endere�o IP da base de dados.</param>
    /// <Param name="pNomeBancoDados" type="String">Nome da base de dados.</param>
    /// <Param name="pUsuarioBanco" type="String">Nome do usu�rio da base de dados.</param>
    /// <Param name="pSenhaBanco" type="String">Senha do usu�rio de dados.</param>
    /// <Param name="pTipoBaseDados" type="String">Tipo da base de dados.</param>
    constructor Create(pEnderecoIP, pNomeBancoDados, pUsuarioBanco, pSenhaBanco,
       pTipoBaseDados: string); overload;

    /// <summary>Destr�i a inst�ncia da classe. </summary>
    destructor Destroy; override;

    /// <summary>Abre a conex�o com o banco de dados. </summary>
    procedure AbrirConexao;

    /// <summary>Configura a conex�o com o banco de dados. </summary>
    procedure ConfigurarConexao;

    /// <summary>Fecha a conex�o com o banco de dados. </summary>
    procedure FecharConexao;

    /// <summary>Testa a conex�o com o banco de dados. </summary>
    /// <returns>True se a conex�o for bem-sucedida, False caso contr�rio.</returns>
    function TestarConexao: Boolean;

    /// <summary>Obt�m o objeto de conex�o TFDConnection. </summary>
    /// <returns>O objeto TFDConnection.</returns>
    function ObterConexao: TFDConnection;
  end;

implementation

uses
  uConfiguracao, uConstantesGerais, uLogErro;

procedure TConexaoBanco.ConfigurarConexao;
begin
  FConexao.DriverName := 'FB';
  FConexao.Params.Clear;
  FConexao.Params.Add('DriverID=FB');
  FConexao.Params.AddPair('Database', FNomeBancoDados);
  FConexao.Params.AddPair('User_Name', FUsuarioBanco);
  FConexao.Params.AddPair('Password', FSenhaBanco);
end;

constructor TConexaoBanco.Create(pEnderecoIP, pNomeBancoDados, pUsuarioBanco,
  pSenhaBanco, pTipoBaseDados: string);
begin
  Create;
  FEnderecoIP := pEnderecoIP;
  FNomeBancoDados := pNomeBancoDados;
  FUsuarioBanco := pUsuarioBanco;
  FSenhaBanco := pSenhaBanco;
  FTipoBaseDados := pTipoBaseDados;
  ConfigurarConexao;
end;

constructor TConexaoBanco.Create;
begin
  FConexao := TFDConnection.Create(nil);
end;

destructor TConexaoBanco.Destroy;
begin
  FecharConexao;
  FConexao.Free;
  inherited;
end;

procedure TConexaoBanco.AbrirConexao;
begin
  try
    FConexao.Open;
  except
    on E: Exception do
      raise Exception.CreateFmt('Erro ao abrir conex�o: %s', [E.Message]);
  end;
end;

procedure TConexaoBanco.FecharConexao;
begin
  if FConexao.Connected then
    FConexao.Close;
end;

function TConexaoBanco.TestarConexao: Boolean;
begin
  Result := False;
  try
    try
      if not FConexao.Connected then
        FConexao.Open;
      Result := True;
    except
      on E: Exception do
      begin
        Writeln('Erro ao testar conex�o: ' + E.Message);
      end;
    end;
  finally
    FecharConexao;
  end;
end;

function TConexaoBanco.ObterConexao: TFDConnection;
begin
  Result := FConexao;
end;

end.

