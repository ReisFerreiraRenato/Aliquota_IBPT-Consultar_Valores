unit uProduto;

interface

uses
  System.SysUtils, System.Types;

type
  /// <summary>
  /// Classe que representa um produto.
  /// Esta classe mapeia diretamente as colunas da tabela PRODUTO no banco de dados.
  /// </summary>
  TProduto = class
  private
    FCodigo: Integer;
    FDescricao: string;
    FNcm: string;

  public
    /// <summary>
    /// Cria uma nova instância da classe TProduto com valores padrão.
    /// </summary>
    constructor Create; overload;

    /// <summary>
    /// Cria uma nova instância da classe TProduto com valores definidos.
    /// </summary>
    /// <param name="pCodigo">Código do produto.</param>
    /// <param name="pDescricao">Descrição do produto.</param>
    /// <param name="pNcm">NCM do produto.</param>
    constructor Create(pCodigo: Integer; pDescricao: string; pNcm: string); overload;

    /// <summary>
    /// Destrói a instância da classe TProduto.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Obtém e define o código do produto.
    /// </summary>
    property Codigo: Integer read FCodigo write FCodigo;

    /// <summary>
    /// Obtém e define a descrição do produto.
    /// </summary>
    property Descricao: string read FDescricao write FDescricao;

    /// <summary>
    /// Obtém e define o NCM do produto.
    /// </summary>
    property Ncm: string read FNcm write FNcm;
  end;

implementation

constructor TProduto.Create;
begin
  FCodigo := 0;
  FDescricao := '';
  FNcm := '';
end;

constructor TProduto.Create(pCodigo: Integer; pDescricao: string; pNcm: string);
begin
  FCodigo := pCodigo;
  FDescricao := pDescricao;
  FNcm := pNcm;
end;

destructor TProduto.Destroy;
begin
  inherited;
end;

end.

