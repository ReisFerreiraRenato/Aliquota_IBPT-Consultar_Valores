unit fMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Data.DB, Datasnap.DBClient, Vcl.NumberBox, Vcl.StdCtrls,
  uProduto, Vcl.ExtCtrls, uFuncoes, uBuscarCalculoTributosProduto,
  uArquivoCSVLinhaProduto, Vcl.Mask, uThreadImportarArquivos, uConstantesGerais;

type
  TMenu = class(TForm)
    lbValor: TLabel;
    eValor: TNumberBox;
    cbUF: TComboBox;
    blUF: TLabel;
    pnProdutoSelecionado: TPanel;
    eDescricaoProdutoSelecionado: TEdit;
    eCodigoProdutoSelecionado: TNumberBox;
    eNCMProdutoSelecionado: TNumberBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    bBuscarProduto: TBitBtn;
    pnProdutoTributacao: TPanel;
    bConsultarTributacaoProduto: TBitBtn;
    bTestarConexao: TBitBtn;
    bImportarTabela: TBitBtn;
    bImportarTodasTabelas: TBitBtn;
    eCodigo: TNumberBox;
    eEx: TNumberBox;
    Label9: TLabel;
    Label10: TLabel;
    eDescricao: TEdit;
    Label15: TLabel;
    gbTributacao: TGroupBox;
    eTribNacionalFederal: TNumberBox;
    Label12: TLabel;
    Label5: TLabel;
    eTribImportadosFederal: TNumberBox;
    Label6: TLabel;
    eTribEstadual: TNumberBox;
    Label14: TLabel;
    eTribMunicipal: TNumberBox;
    gbValores: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    eValorProduto: TNumberBox;
    Label23: TLabel;
    eValorLiquido: TNumberBox;
    Label24: TLabel;
    Label25: TLabel;
    eNCM: TNumberBox;
    lbApresentacaoProduto: TLabel;
    GroupBox1: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    eFonte: TEdit;
    eVersao: TEdit;
    eChave: TEdit;
    eDataVigenciaInicio: TMaskEdit;
    eDataVigenciaFim: TMaskEdit;
    eSomaTributacao: TEdit;
    eSomaValoresTributacao: TEdit;
    eValorTributacaoMunicipal: TEdit;
    eValorTributacaoEstadual: TEdit;
    eValorTributacaoImportadosFederal: TEdit;
    eValorTributacaoNacionalFederal: TEdit;
    OpenDialog1: TOpenDialog;
    bLimparTela: TBitBtn;
    lbImportandoTabelas: TLabel;
    Timer1: TTimer;
    bSair: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure bTestarConexaoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bBuscarProdutoClick(Sender: TObject);
    procedure AparecerEsconderPainelProdutoSelecionado(pValor: Boolean);
    procedure CarregarProduto;
    procedure CarregarItensCombobox;
    procedure CarregarProdutoCompleto;
    procedure bConsultarTributacaoProdutoClick(Sender: TObject);
    procedure bImportarTabelaClick(Sender: TObject);
    procedure bImportarTodasTabelasClick(Sender: TObject);
    procedure bLimparTelaClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure bSairClick(Sender: TObject);
  private
    { Private declarations }

    /// <summary>Campo para armazenar o produto selecionado na tela BuscarProduto</summary>
    FProdutoSelecionado: Tproduto;

    /// <summary>Campo para armazenar o produto completo após a consulta e cálculos.</summary>
    FProdutoCompleto: TArquivoCSVLinhaProduto;

    /// <summary>Campo Thread utilizada para importar as planilhas para a base de dados.</summary>
    FThreadImportarArquivos: TThreadImportarArquivos;

    /// <summary>Limpa os dados e as telas.</summary>
    procedure LimparDados;

    /// <summary>Importa as tabelas em um caminho configurado internamente no software.</summary>
    procedure ThreadImportarTabelas;

    /// <summary>Atualiza e mostra a mensegem de improtar tabelas</summary>
    /// <param name="pVisible" type="Boolean">'True' mostrar, 'False' não mostrar.</param>
    /// <param name="pMensagem" type="string">Mensagem a ser mostrada na importação, não obrigatório, tem uma padrão configurada.</param>
    procedure AtualizarVerlbImportandoTabelas(
      const pVisible: Boolean; const pMensagem: string = IMPORTANDO_TABELAS);

    /// <summary>Liga ou desliga o time que verifica a trhead que importa as tabelas.</summary>
    /// <param name="pValor" type="Boolean">'True' liga, 'False' desliga.</param>
    procedure LigarDesligarTime(pValor: Boolean);
  public
    { Public declarations }
  end;

var
  Menu: TMenu;

implementation

{$R *.dfm}

uses
  System.IniFiles, uConfiguracao, uConexaoBanco, uVariaveisGlobais,
  uLogErro, uConstantesBaseDados, fBuscarProduto,
  uImportadorTabelas;

{ TMenu }

procedure TMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FThreadImportarArquivos <> nil then
  begin
    if FThreadImportarArquivos.Finished then
    begin
      Action := TCloseAction.caNone;
      ShowMessage(IMPORTACAO_TABELAS_THREAD_EM_EXECUCAO_FECHAMENTO);
    end;
  end;
  //destruir conexao
  gConexaoBanco.Destroy;
end;

procedure TMenu.FormCreate(Sender: TObject);
begin
  FThreadImportarArquivos := nil;
  CarregarConfiguracao;
  CarregarItensCombobox;
end;

procedure TMenu.LigarDesligarTime(pValor: Boolean);
begin
  Timer1.Enabled := pValor;
end;

procedure TMenu.LimparDados;
begin
  FProdutoSelecionado := nil;
  FProdutoCompleto := nil;
  pnProdutoSelecionado.Visible := False;
  pnProdutoTributacao.Visible := False;
  eValor.ValueInt := 0;
  cbUF.ItemIndex := 0;
  bBuscarProduto.SetFocus;
end;

procedure TMenu.ThreadImportarTabelas;
begin
  try
    if (FThreadImportarArquivos <> nil) and
      (FThreadImportarArquivos.Finished) then
    begin
      ShowMessage(IMPORTACAO_TABELAS_THREAD_EM_EXECUCAO);
      Exit;
    end;

    FThreadImportarArquivos := TThreadImportarArquivos.Create(True);

    FThreadImportarArquivos.Start;
  except
    on E: Exception do
    begin
      ShowMessage(ERRO_AO_IMPORTAR_TABELAS);
    end;
  end;
end;

procedure TMenu.Timer1Timer(Sender: TObject);
begin
  if (Cursor <> crDefault) then
  begin
    Cursor := crDefault;
    Refresh;
  end;

  if (FThreadImportarArquivos <> nil) then
  begin
    if (not FThreadImportarArquivos.Finished) then
    begin
      AtualizarVerlbImportandoTabelas(True);
      Exit;
    end;

    AtualizarVerlbImportandoTabelas(False);
    LigarDesligarTime(False);
    ShowMessage(TABELAS_IMPORTADA_COM_SUCESSO);
    FThreadImportarArquivos := nil;
  end;
end;

procedure TMenu.AparecerEsconderPainelProdutoSelecionado(pValor: Boolean);
begin
  pnProdutoSelecionado.Visible := pValor;
end;

procedure TMenu.AtualizarVerlbImportandoTabelas(
      const pVisible: Boolean; const pMensagem: string = IMPORTANDO_TABELAS);
begin
  lbImportandoTabelas.Caption := pMensagem;
  lbImportandoTabelas.Visible := pVisible;
  lbImportandoTabelas.Refresh;
end;

procedure TMenu.bBuscarProdutoClick(Sender: TObject);
var
  buscarProduto: TBuscarProduto;
  codigo: integer;
  descricao, ncm: string;
begin
  FProdutoSelecionado := nil;
  AparecerEsconderPainelProdutoSelecionado(False);
  buscarProduto := TBuscarProduto.Create(Self);
  try
    buscarProduto.ShowModal;
    if buscarProduto.ModalResult = mrOk then
    begin
      codigo := buscarProduto.codigoProdutoSelecionado;
      descricao := string(buscarProduto.descricaoProdutoSelecionado);
      ncm := string(buscarProduto.codigoNcmProdutoSelecionado);
      FProdutoSelecionado := TProduto.Create(codigo, descricao, ncm);
    end;
  finally
    buscarProduto.Free;
  end;

  CarregarProduto;
end;


procedure TMenu.bConsultarTributacaoProdutoClick(Sender: TObject);
begin
  if (eValor.ValueCurrency = 0) then
  begin
    ShowMessage(ERRO_ADICIONE_VALOR_CALCULADO);
    eValor.SetFocus;
    Exit;
  end;

  if (eValor.ValueCurrency < 0) then
  begin
    ShowMessage(ERRO_VALOR_NEGATIVO);
    eValor.SetFocus;
    Exit;
  end;

  if (FProdutoSelecionado = nil) then
  begin
    ShowMessage(ERRO_SELECIONAR_PRODUTO);
    bBuscarProduto.SetFocus;
    Exit;
  end;

  FProdutoCompleto := BuscarProdutoTributacao(FProdutoSelecionado.Codigo, cbUF.Text, eValor.ValueInt);
  CarregarProdutoCompleto;
end;

procedure TMenu.bImportarTabelaClick(Sender: TObject);
var
  importarTodasTabelas: TImportadorTabelas;
  nomeCaminhoArquivo: string;
begin
  importarTodasTabelas := TImportadorTabelas.Create;
  try
    if OpenDialog1.Execute then
    begin
      nomeCaminhoArquivo := OpenDialog1.FileName;
      if importarTodasTabelas.ImportarTabela(nomeCaminhoArquivo) then
        ShowMessage(TABELAS_IMPORTADA_COM_SUCESSO)
      else
        ShowMessage(ERRO_AO_IMPORTAR_TABELAS);
    end;
  finally
    importarTodasTabelas.Free;
  end;
end;

procedure TMenu.bImportarTodasTabelasClick(Sender: TObject);
begin
  LigarDesligarTime(True);
  AtualizarVerlbImportandoTabelas(True, IMPORTANDO_TABELAS);

  ThreadImportarTabelas;
end;

procedure TMenu.bLimparTelaClick(Sender: TObject);
begin
  LimparDados;
end;

procedure TMenu.bSairClick(Sender: TObject);
begin
  Close;
end;

procedure TMenu.bTestarConexaoClick(Sender: TObject);
begin
  if gConexaoBanco.TestarConexao then
    ShowMessage(CONEXAO_TESTADA_COM_SUCESSO)
  else
    ShowMessage(ERRO_AO_TESTAR_CONEXAO);
end;

procedure TMenu.CarregarItensCombobox;
var
  cont: Integer;
begin
  for cont := Low(SIGLA_ESTADOS) to High(SIGLA_ESTADOS) do
    cbUF.Items.Add(SIGLA_ESTADOS[cont]);
  cbUF.ItemIndex := 0;
end;

procedure TMenu.CarregarProduto;
begin
  if FProdutoSelecionado <> nil then
  begin
    AparecerEsconderPainelProdutoSelecionado(True);
    eDescricaoProdutoSelecionado.Text := FProdutoSelecionado.Descricao;
    eCodigoProdutoSelecionado.ValueInt := FProdutoSelecionado.Codigo;
    eNCMProdutoSelecionado.ValueInt := StringParaInt(FProdutoSelecionado.Ncm);
  end;
end;

procedure TMenu.CarregarProdutoCompleto;
const
  captionProduto = 'Produto: {0} - Valor R$ {1} - Impostos R$ {2} = Líquido R$ {3}';
begin
  if FProdutoCompleto <> nil then
  begin
    pnProdutoTributacao.Visible := True;
    lbApresentacaoProduto.Caption := String.Format(captionProduto, [FProdutoCompleto.Descricao, eValor.Text,
      FProdutoCompleto.SomaTributacaoValor.ToString, FProdutoCompleto.ValorLiquido.ToString]);

    eValorProduto.ValueCurrency := eValor.ValueCurrency;
    eDescricao.Text := FProdutoCompleto.Descricao;
    eCodigo.ValueInt := FProdutoCompleto.CodigoProduto;
    eEx.ValueInt := FProdutoCompleto.Ex;
    eSomaTributacao.Text := FProdutoCompleto.SomaTributacaoPorcentagem.ToString;
    eSomaValoresTributacao.Text := FProdutoCompleto.SomaTributacaoValor.ToString;
    eTribNacionalFederal.ValueCurrency := FProdutoCompleto.NacionalFederal;
    eTribImportadosFederal.ValueCurrency := FProdutoCompleto.ImportadosFederal;
    eTribEstadual.ValueCurrency := FProdutoCompleto.Estadual;
    eTribMunicipal.ValueCurrency := FProdutoCompleto.Municipal;
    eValorTributacaoNacionalFederal.Text := FProdutoCompleto.ValorTribNacionalFederal.ToString;
    eValorTributacaoImportadosFederal.Text := FProdutoCompleto.ValorTribImportadosFederal.ToString;
    eValorTributacaoEstadual.Text := FProdutoCompleto.ValorTribEstadual.ToString;
    eValorTributacaoMunicipal.Text := FProdutoCompleto.ValorTribMunicipal.ToString;
    eValorLiquido.ValueCurrency := FProdutoCompleto.ValorLiquido;
    eNCM.ValueInt := FProdutoCompleto.CodigoNCM;
    eFonte.Text := FProdutoCompleto.Fonte;
    eVersao.Text := FProdutoCompleto.Versao;
    eChave.Text := FProdutoCompleto.Chave;
    eDataVigenciaInicio.Text := DateToStr(FProdutoCompleto.VigenciaInicio);
    eDataVigenciaFim.Text := DateToStr(FProdutoCompleto.VigenciaFim);
  end;
end;

end.
