unit fBuscarProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.NumberBox, Vcl.Buttons, uBuscarProduto, FireDAC.Comp.Client,
  uProduto, Vcl.Grids, uConstantesGerais, DB, uConstantesBaseDados,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, Vcl.DBGrids;

type
  TBuscarProduto = class(TForm)
    eDescricao: TEdit;
    eCodigo: TNumberBox;
    eNCM: TNumberBox;
    lbCodigo: TLabel;
    lbDescricao: TLabel;
    lbNcm: TLabel;
    bBuscar: TBitBtn;
    bSelecionar: TBitBtn;
    bLimpar: TBitBtn;
    tabelaMemoria: TFDMemTable;
    gdDados: TDBGrid;
    dsTabelaMemoria: TDataSource;
    procedure eDescricaoKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bBuscarClick(Sender: TObject);
    procedure bSelecionarClick(Sender: TObject);
    procedure bLimparClick(Sender: TObject);
    procedure eCodigoExit(Sender: TObject);
    procedure eDescricaoExit(Sender: TObject);
    procedure eNCMExit(Sender: TObject);
  private
    { Private declarations }
    /// <summary>Campo para armazenar o array de produtos da consulta de produtos feita</summary>
    FArrayProdutos: TArray<TProduto>;
    /// <summary>Campo para armazenar o produto selecionado na tela</summary>
    FProduto: TProduto;

    /// <summary>Buscar produto pela descrição. </summary>
    /// <param name="pDescricao" type="String">String contendo a descrição do produto.</param>
    procedure BuscarProdutoDescricao(pDescricao: String);

    /// <summary>Buscar produto pelo código. </summary>
    /// <param name="pCodigo" type="Integer">Código do produto.</param>
    procedure BuscarProdutoCodigo(pCodigo: Integer);

    /// <summary>Buscar produtos pelo código NCM. </summary>
    /// <param name="pNCM" type="String">Código NCM do produto.</param>
    procedure BuscarProdutoNCM(pNCM: String);

    /// <summary>Carrega os produtos da consulta na tabela de memória. </summary>
    procedure CarregarTabelaMemoria;

    /// <summary>Limpar/Criar a tabela de produtos da memória. </summary>
    procedure LimparCriarTabelaMemoria;

    /// <summary>Limpa os campos da tela e seta o foco no código. </summary>
    procedure LimparEdits;

    /// <summary>Esconder a grid. </summary>
    procedure EsconderGrid;

    /// <summary>Limpa a tabela e a grid de produtos. </summary>
    procedure LimparGridTabela;

    /// <summary>Limpa a tela e todos os seus campos e atributos. </summary>
    procedure LimparTela;

    /// <summary>Monta a grid com os produtos buscados. </summary>
    procedure MontarGrid;
  public
    { Public declarations }

    /// <summary>Obtém e define o produto selecionado</summary>
    ProdutoSelecionado: TProduto;

    /// <summary>Obtém e define a descricao do produto selecionado</summary>
    DescricaoProdutoSelecionado: AnsiString;

    /// <summary>Obtém e define o código do produto selecionado</summary>
    CodigoProdutoSelecionado: Integer;

    /// <summary>Obtém e define o código NCM do produto selecionado</summary>
    CodigoNcmProdutoSelecionado: AnsiString;
  end;

var
  BuscarProduto: TBuscarProduto;

implementation

{$R *.dfm}

procedure TBuscarProduto.bBuscarClick(Sender: TObject);
begin
  if (eCodigo.ValueInt <> 0) then
  begin
    BuscarProdutoCodigo(eCodigo.ValueInt);
    Exit;
  end;
  if (Trim(eDescricao.Text) <> '') then
  begin
    BuscarProdutoDescricao(Trim(eDescricao.Text));
    Exit;
  end;
  if eNCM.ValueInt <> 0 then
  begin
    BuscarProdutoNCM(eNCM.Value.ToString);
    Exit;
  end;

  ShowMessage('Favor preencher algum dos campos!');
  eCodigo.SetFocus;
end;

procedure TBuscarProduto.bLimparClick(Sender: TObject);
begin
  LimparTela;
end;

procedure TBuscarProduto.bSelecionarClick(Sender: TObject);
begin
  if (not tabelaMemoria.Active) or tabelaMemoria.IsEmpty then
  begin
    Exit;
  end;

  codigoProdutoSelecionado := tabelaMemoria.FieldByName(cCODIGO).AsInteger;
  descricaoProdutoSelecionado := tabelaMemoria.FieldByName(cDESCRICAO).AsAnsiString;
  codigoNcmProdutoSelecionado := tabelaMemoria.FieldByName(cNCM).AsAnsiString;

  ModalResult := mrOk
end;

procedure TBuscarProduto.BuscarProdutoCodigo(pCodigo: Integer);
begin
  FProduto := BuscarProdutoPorCodigo(pCodigo);
  if FProduto = nil then
  begin
    ShowMessage(PRODUTOS_NAO_ENCONTADOS);
    Exit;
  end;

  produtoSelecionado := FProduto;
  MontarGrid;
end;

procedure TBuscarProduto.BuscarProdutoDescricao(pDescricao: String);
begin
  FArrayProdutos := BuscarProdutosPorDescricao(pDescricao);
  if FArrayProdutos = nil then
  begin
    ShowMessage(PRODUTOS_NAO_ENCONTADOS);
    Exit;
  end;

  MontarGrid;
end;

procedure TBuscarProduto.BuscarProdutoNCM(pNCM: String);
begin
  FArrayProdutos := BuscarProdutoPorNCM(pNCM);

  if FArrayProdutos = nil then
  begin
    ShowMessage(PRODUTOS_NAO_ENCONTADOS);
    Exit;
  end;

  MontarGrid;
end;

procedure TBuscarProduto.CarregarTabelaMemoria;
var
  contador: Integer;
begin
  if tabelaMemoria.FieldDefs.Count = 0 then
  begin
    tabelaMemoria.FieldDefs.Clear;
    tabelaMemoria.FieldDefs.Add(cCODIGO, ftInteger, 0, False);
    tabelaMemoria.FieldDefs.Add(cDESCRICAO, ftString, 255, False);
    tabelaMemoria.FieldDefs.Add(cNCM, ftString, 9, False);
    tabelaMemoria.CreateDataSet;
    tabelaMemoria.Open;
    tabelaMemoria.Active := True;
  end;

  if not tabelaMemoria.IsEmpty then
    tabelaMemoria.EmptyDataSet;

  if FProduto <> nil then
  begin
    tabelaMemoria.Append;
    tabelaMemoria.FieldByName(cCODIGO).AsInteger := FProduto.Codigo;
    tabelaMemoria.FieldByName(cDESCRICAO).AsString := FProduto.Descricao;
    tabelaMemoria.FieldByName(cNCM).AsString := FProduto.Ncm;
    tabelaMemoria.Post;
  end;

  if FArrayProdutos <> nil then
  begin
    for contador := Low(FArrayProdutos) to High(FArrayProdutos) do
    begin
      tabelaMemoria.Append;
      tabelaMemoria.FieldByName(cCODIGO).AsInteger := FArrayProdutos[contador].Codigo;
      tabelaMemoria.FieldByName(cDESCRICAO).AsString := FArrayProdutos[contador].Descricao;
      tabelaMemoria.FieldByName(cNCM).AsString := FArrayProdutos[contador].Ncm;
      tabelaMemoria.Post;
    end;
  end;

  tabelaMemoria.First;
end;

procedure TBuscarProduto.eCodigoExit(Sender: TObject);
begin
  if eCodigo.ValueInt <> 0 then
  begin
    BuscarProdutoCodigo(eCodigo.ValueInt);
    bSelecionar.SetFocus;
  end;
end;

procedure TBuscarProduto.eDescricaoExit(Sender: TObject);
begin
  if (Trim(eDescricao.Text) <> '') and (Length(Trim(eDescricao.Text)) > 2) then
  begin
    BuscarProdutoDescricao(Trim(eDescricao.Text));
  end;
end;

procedure TBuscarProduto.eDescricaoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Trim(eDescricao.Text) <> '') and (Length(Trim(eDescricao.Text)) > 2) then
  begin
    BuscarProdutoDescricao(Trim(eDescricao.Text));
  end;
end;

procedure TBuscarProduto.eNCMExit(Sender: TObject);
begin
  if eNCM.ValueInt <> 0 then
    BuscarProdutoNCM(eNCM.Value.ToString);
end;

procedure TBuscarProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(FProduto) then
    FProduto.Free;

  if Assigned(FArrayProdutos) and (Length(FArrayProdutos) > 0) then
    SetLength(FArrayProdutos, 0);
end;

procedure TBuscarProduto.FormCreate(Sender: TObject);
begin
  FProduto := nil;
  FArrayProdutos := nil;
end;

procedure TBuscarProduto.LimparEdits;
begin
  eDescricao.Clear;
  eCodigo.Clear;
  eNCM.Clear;
  eCodigo.SetFocus;
end;

procedure TBuscarProduto.EsconderGrid;
begin
  gdDados.Visible := False;
  gdDados.Refresh;
end;

procedure TBuscarProduto.LimparGridTabela;
begin
  LimparCriarTabelaMemoria;
  EsconderGrid;
end;

procedure TBuscarProduto.LimparCriarTabelaMemoria;
begin
  if not Assigned(tabelaMemoria) then
    tabelaMemoria := tabelaMemoria.Create(Self);
  tabelaMemoria.EmptyDataSet;
end;

procedure TBuscarProduto.LimparTela;
begin
  LimparCriarTabelaMemoria;
  LimparGridTabela;
  EsconderGrid;
  LimparEdits;
end;

procedure TBuscarProduto.MontarGrid;
begin
  CarregarTabelaMemoria;
  gdDados.Refresh;
  gdDados.Visible := True;
end;

end.
