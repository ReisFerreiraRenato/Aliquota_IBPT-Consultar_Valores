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
    arrayProdutos: TArray<TProduto>;
    produto: TProduto;
    procedure BuscarProdutoDescricao(pDescricao: String);
    procedure BuscarProdutoCodigo(pCodigo: Integer);
    procedure BuscarProdutoNCM(pNCM: String);
    procedure CarregarTabelaMemoria;
    procedure LimparTabelaMemoria;
    procedure LimparEdits;
    procedure LimparEsconderGrid;
    procedure LimparGridTabela;
    procedure LimparTela;
    procedure MontarGrid;
  public
    { Public declarations }
    produtoSelecionado: TProduto;
    descricaoProdutoSelecionado: AnsiString;
    codigoProdutoSelecionado: Integer;
    codigoNcmProdutoSelecionado: AnsiString;
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
  produto := BuscarProdutoPorCodigo(pCodigo);
  if produto = nil then
  begin
    ShowMessage(PRODUTOS_NAO_ENCONTADOS);
    Exit;
  end;

  produtoSelecionado := produto;
  MontarGrid;
end;

procedure TBuscarProduto.BuscarProdutoDescricao(pDescricao: String);
begin
  arrayProdutos := BuscarProdutosPorDescricao(pDescricao);
  if arrayProdutos = nil then
  begin
    ShowMessage(PRODUTOS_NAO_ENCONTADOS);
    Exit;
  end;

  MontarGrid;
end;

procedure TBuscarProduto.BuscarProdutoNCM(pNCM: String);
begin
  arrayProdutos := BuscarProdutoPorNCM(pNCM);

  if arrayProdutos = nil then
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

  if produto <> nil then
  begin
    tabelaMemoria.Append;
    tabelaMemoria.FieldByName(cCODIGO).AsInteger := produto.Codigo;
    tabelaMemoria.FieldByName(cDESCRICAO).AsString := produto.Descricao;
    tabelaMemoria.FieldByName(cNCM).AsString := produto.Ncm;
    tabelaMemoria.Post;
  end;

  if arrayProdutos <> nil then
  begin
    for contador := Low(arrayProdutos) to High(arrayProdutos) do
    begin
      tabelaMemoria.Append;
      tabelaMemoria.FieldByName(cCODIGO).AsInteger := arrayProdutos[contador].Codigo;
      tabelaMemoria.FieldByName(cDESCRICAO).AsString := arrayProdutos[contador].Descricao;
      tabelaMemoria.FieldByName(cNCM).AsString := arrayProdutos[contador].Ncm;
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
  if Assigned(produto) then
    produto.Free;

  if Assigned(arrayProdutos) and (Length(arrayProdutos) > 0) then
    SetLength(arrayProdutos, 0);
end;

procedure TBuscarProduto.FormCreate(Sender: TObject);
begin
  produto := nil;
  arrayProdutos := nil;
end;

procedure TBuscarProduto.LimparEdits;
begin
  eDescricao.Clear;
  eCodigo.Clear;
  eNCM.Clear;
  eCodigo.SetFocus;
end;

procedure TBuscarProduto.LimparEsconderGrid;
begin
  gdDados.Visible := False;
end;

procedure TBuscarProduto.LimparGridTabela;
begin
  LimparTabelaMemoria;
  LimparEsconderGrid;
end;

procedure TBuscarProduto.LimparTabelaMemoria;
begin
  if not Assigned(tabelaMemoria) then
    tabelaMemoria := tabelaMemoria.Create(Self);
  tabelaMemoria.EmptyDataSet;
end;

procedure TBuscarProduto.LimparTela;
begin
  LimparTabelaMemoria;
  LimparGridTabela;
  LimparEsconderGrid;
  LimparEdits;
end;

procedure TBuscarProduto.MontarGrid;
begin
  CarregarTabelaMemoria;
  gdDados.Refresh;
  gdDados.Visible := True;
end;

end.
