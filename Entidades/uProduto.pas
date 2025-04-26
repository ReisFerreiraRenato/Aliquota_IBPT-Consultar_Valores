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
    /// Cria uma nova inst�ncia da classe TProduto com valores padr�o.
    /// </summary>
    constructor Create; overload;

    /// <summary>
    /// Cria uma nova inst�ncia da classe TProduto com valores definidos.
    /// </summary>
    /// <param name="pCodigo">C�digo do produto.</param>
    /// <param name="pDescricao">Descri��o do produto.</param>
    /// <param name="pNcm">NCM do produto.</param>
    constructor Create(pCodigo: Integer; pDescricao: string; pNcm: string); overload;

    /// <summary>
    /// Destr�i a inst�ncia da classe TProduto.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Obt�m e define o c�digo do produto.
    /// </summary>
    property Codigo: Integer read FCodigo write FCodigo;

    /// <summary>
    /// Obt�m e define a descri��o do produto.
    /// </summary>
    property Descricao: string read FDescricao write FDescricao;

    /// <summary>
    /// Obt�m e define o NCM do produto.
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

