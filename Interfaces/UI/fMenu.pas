unit fMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Data.DB, Datasnap.DBClient;

type
  TMenu = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
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

procedure TMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //destruir conexao
  gConexaoBanco.Destroy;
end;

procedure TMenu.FormCreate(Sender: TObject);
begin
  CarregarConfiguracao;
end;

procedure TMenu.SpeedButton1Click(Sender: TObject);
begin
  if gConexaoBanco.TestarConexao then
    ShowMessage('Conexão testada com sucesso')
  else
    ShowMessage('Conexão com erro');
end;

end.
