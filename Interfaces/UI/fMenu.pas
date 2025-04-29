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
  private
    { Private declarations }
    produtoSelecionado: Tproduto;
    produtoCompleto: TArquivoCSVLinhaProduto;
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
    ShowMessage('Adicione o valor a ser calculado. ');
    eValor.SetFocus;
    Exit;
  end;

  if (eValor.ValueCurrency < 0) then
  begin
    ShowMessage('O valor não pode ser negativo. ');
    eValor.SetFocus;
    Exit;
  end;

  if (produtoSelecionado = nil) then
  begin
    ShowMessage('Favor selecionar o produto. ');
    bBuscarProduto.SetFocus;
    Exit;
  end;

  produtoCompleto := BuscarProdutoTributacao(produtoSelecionado.Codigo, cbUF.Text, eValor.ValueInt);
  CarregarProdutoCompleto;
end;

procedure TMenu.bImportarTabelaClick(Sender: TObject);
begin
  ShowMessage('Em desenvolvimento!');
end;

procedure TMenu.bImportarTodasTabelasClick(Sender: TObject);
var
  importarTodasTabelas: TImportadorTabelas;
begin
  importarTodasTabelas := TImportadorTabelas.Create;
  try
    if importarTodasTabelas.ImportarTabelas then
      ShowMessage('Tabelas imporatas com sucesso. ')
    else
      ShowMessage('Erro ao importar tabelas. ');
  finally
    importarTodasTabelas.Free;
  end;
end;

procedure TMenu.bTestarConexaoClick(Sender: TObject);
begin
  if gConexaoBanco.TestarConexao then
    ShowMessage('Conexão testada com sucesso')
  else
    ShowMessage('Conexão com erro');
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
begin
  if produtoCompleto <> nil then
  begin
    pnProdutoTributacao.Visible := True;
    lbApresentacaoProduto.Caption := 'Produto: ' +
      produtoCompleto.Descricao + ' - Valor R$ ' +
      eValor.Text + ' - Impostos R$ ' + produtoCompleto.SomaTributacaoValor.ToString +
      ' = Líquido R$ ' + produtoCompleto.ValorLiquido.ToString;

    eValorProduto.ValueCurrency := eValor.ValueCurrency;
    eDescricaoProdutoSelecionado.Text := produtoCompleto.Descricao;
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
