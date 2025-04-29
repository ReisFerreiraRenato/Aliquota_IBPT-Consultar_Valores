unit fMenu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Buttons, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, Data.DB, Datasnap.DBClient, Vcl.NumberBox, Vcl.StdCtrls,
  uProduto, Vcl.ExtCtrls, uFuncoes, uBuscarCalculoTributosProduto,
  uArquivoCSVLinhaProduto, Vcl.Mask;

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
  private
    { Private declarations }
    produtoSelecionado: Tproduto;
    produtoCompleto: TArquivoCSVLinhaProduto;
    procedure LimparDados;
  public
    { Public declarations }
  end;

var
  Menu: TMenu;

implementation

{$R *.dfm}

uses
  System.IniFiles, uConfiguracao, uConexaoBanco, uVariaveisGlobais,
  uConstantesGerais, uLogErro, uConstantesBaseDados, fBuscarProduto,
  uImportadorTabelas;

{ TMenu }

procedure TMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //destruir conexao
  gConexaoBanco.Destroy;
end;

procedure TMenu.FormCreate(Sender: TObject);
begin
  CarregarConfiguracao;
  CarregarItensCombobox;
end;

procedure TMenu.LimparDados;
begin
  produtoSelecionado := nil;
  produtoCompleto := nil;
  pnProdutoSelecionado.Visible := False;
  pnProdutoTributacao.Visible := False;
  eValor.ValueInt := 0;
  cbUF.ItemIndex := 0;
  bBuscarProduto.SetFocus;
end;

procedure TMenu.AparecerEsconderPainelProdutoSelecionado(pValor: Boolean);
begin
  pnProdutoSelecionado.Visible := pValor;
end;

procedure TMenu.bBuscarProdutoClick(Sender: TObject);
var
  buscarProduto: TBuscarProduto;
  codigo: integer;
  descricao, ncm: string;
begin
  produtoSelecionado := nil;
  AparecerEsconderPainelProdutoSelecionado(False);
  buscarProduto := TBuscarProduto.Create(Self);
  try
    buscarProduto.ShowModal;
    if buscarProduto.ModalResult = mrOk then
    begin
      codigo := buscarProduto.codigoProdutoSelecionado;
      descricao := string(buscarProduto.descricaoProdutoSelecionado);
      ncm := string(buscarProduto.codigoNcmProdutoSelecionado);
      produtoSelecionado := TProduto.Create(codigo, descricao, ncm);
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

  if (produtoSelecionado = nil) then
  begin
    ShowMessage(ERRO_SELECIONAR_PRODUTO);
    bBuscarProduto.SetFocus;
    Exit;
  end;

  produtoCompleto := BuscarProdutoTributacao(produtoSelecionado.Codigo, cbUF.Text, eValor.ValueInt);
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
var
  importarTodasTabelas: TImportadorTabelas;
begin
  importarTodasTabelas := TImportadorTabelas.Create;
  try
    if importarTodasTabelas.ImportarTabelas then
      ShowMessage(TABELAS_IMPORTADA_COM_SUCESSO)
    else
      ShowMessage(ERRO_AO_IMPORTAR_TABELAS);
  finally
    importarTodasTabelas.Free;
  end;
end;

procedure TMenu.bLimparTelaClick(Sender: TObject);
begin
  LimparDados;
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
  if produtoSelecionado <> nil then
  begin
    AparecerEsconderPainelProdutoSelecionado(True);
    eDescricaoProdutoSelecionado.Text := produtoSelecionado.Descricao;
    eCodigoProdutoSelecionado.ValueInt := produtoSelecionado.Codigo;
    eNCMProdutoSelecionado.ValueInt := StringParaInt(produtoSelecionado.Ncm);
  end;
end;

procedure TMenu.CarregarProdutoCompleto;
const
  captionProduto = 'Produto: {0} - Valor R$ {1} - Impostos R$ {2} = Líquido R$ {3}';
begin
  if produtoCompleto <> nil then
  begin
    pnProdutoTributacao.Visible := True;
    lbApresentacaoProduto.Caption := String.Format(captionProduto, [produtoCompleto.Descricao, eValor.Text,
      produtoCompleto.SomaTributacaoValor.ToString, produtoCompleto.ValorLiquido.ToString]);

    eValorProduto.ValueCurrency := eValor.ValueCurrency;
    eDescricao.Text := produtoCompleto.Descricao;
    eCodigo.ValueInt := produtoCompleto.CodigoProduto;
    eEx.ValueInt := produtoCompleto.Ex;
    eSomaTributacao.Text := produtoCompleto.SomaTributacaoPorcentagem.ToString;
    eSomaValoresTributacao.Text := produtoCompleto.SomaTributacaoValor.ToString;
    eTribNacionalFederal.ValueCurrency := produtoCompleto.NacionalFederal;
    eTribImportadosFederal.ValueCurrency := produtoCompleto.ImportadosFederal;
    eTribEstadual.ValueCurrency := produtoCompleto.Estadual;
    eTribMunicipal.ValueCurrency := produtoCompleto.Municipal;
    eValorTributacaoNacionalFederal.Text := produtoCompleto.ValorTribNacionalFederal.ToString;
    eValorTributacaoImportadosFederal.Text := produtoCompleto.ValorTribImportadosFederal.ToString;
    eValorTributacaoEstadual.Text := produtoCompleto.ValorTribEstadual.ToString;
    eValorTributacaoMunicipal.Text := produtoCompleto.ValorTribMunicipal.ToString;
    eValorLiquido.ValueCurrency := produtoCompleto.ValorLiquido;
    eNCM.ValueInt := produtoCompleto.CodigoNCM;
    eFonte.Text := produtoCompleto.Fonte;
    eVersao.Text := produtoCompleto.Versao;
    eChave.Text := produtoCompleto.Chave;
    eDataVigenciaInicio.Text := DateToStr(produtoCompleto.VigenciaInicio);
    eDataVigenciaFim.Text := DateToStr(produtoCompleto.VigenciaFim);
  end;
end;

end.
