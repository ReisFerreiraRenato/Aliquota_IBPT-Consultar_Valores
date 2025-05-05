unit uThreadImportarArquivos;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

type
  /// <summary>Classe para importar os arquivos com as tabelas</summary>
  TThreadImportarArquivos = class(TThread)
  private
    FMensagem: AnsiString;
    FErro: Boolean;
  protected
    procedure Execute; override;
  public
    /// <summary>Cria uma instância da classe. </summary>
    /// <param name="pCriarSuspenso" type="Boolean">Para criar ou não a classe suspensa. </param>
    /// <param name="pMensagem" type="string">Para adicionar ou não a mensagem. </param>
    constructor Create(pCriarSuspenso: Boolean; pMensagem: string = '');

    /// <summary>Obtém e define se houve erro. </summary>
    property Erro: Boolean read FErro write FErro;

    /// <summary>Obtém e define mensagem. </summary>
    property Mensagem: AnsiString read FMensagem write FMensagem;
  end;

implementation

{ TMyThread }

uses uImportadorTabelas, uConstantesGerais;

constructor TThreadImportarArquivos.Create(pCriarSuspenso: Boolean; pMensagem: string);
begin
  inherited Create(pCriarSuspenso);
  if pMensagem <> '' then
    FMensagem := AnsiString(pMensagem);
  FErro := False;
  FreeOnTerminate := True;
end;

procedure TThreadImportarArquivos.Execute;
begin
  inherited;
  try
    Synchronize(
      procedure()
      var
        importarTodasTabelas: TImportadorTabelas;
      begin
        importarTodasTabelas := TImportadorTabelas.Create;
        try
          Self.FMensagem := ERRO_AO_IMPORTAR_TABELAS;
          Self.FErro := importarTodasTabelas.ImportarTabelas;
          if not FErro then
            Self.FMensagem := TABELAS_IMPORTADA_COM_SUCESSO
        finally
          importarTodasTabelas.Free;
        end;
      end);
  except
    on E: Exception do
      Synchronize(
        procedure()
        begin
          Self.FErro := True;
          Self.FMensagem := ERRO_AO_IMPORTAR_TABELAS;
        end);
  end;
end;

end.
