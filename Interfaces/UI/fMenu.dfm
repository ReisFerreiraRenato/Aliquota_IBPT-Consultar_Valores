object Menu: TMenu
  Left = 0
  Top = 0
  Hint = 'As tabelas devem est'#225' na pasta:'
  Caption = 'Menu'
  ClientHeight = 610
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 15
  object lbValor: TLabel
    Left = 312
    Top = 11
    Width = 42
    Height = 15
    Caption = 'Valor R$'
  end
  object blUF: TLabel
    Left = 439
    Top = 11
    Width = 17
    Height = 15
    Caption = 'UF:'
  end
  object lbImportandoTabelas: TLabel
    Left = 579
    Top = 0
    Width = 166
    Height = 25
    Alignment = taRightJustify
    Caption = 'Importando Tabelas'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clCrimson
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Visible = False
  end
  object eValor: TNumberBox
    Left = 312
    Top = 32
    Width = 121
    Height = 33
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object cbUF: TComboBox
    Left = 439
    Top = 32
    Width = 82
    Height = 32
    Style = csOwnerDrawFixed
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ItemHeight = 26
    ParentFont = False
    TabOrder = 2
  end
  object pnProdutoSelecionado: TPanel
    Left = 8
    Top = 76
    Width = 513
    Height = 136
    Enabled = False
    TabOrder = 4
    Visible = False
    object Label1: TLabel
      Left = 4
      Top = 73
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
    end
    object Label2: TLabel
      Left = 123
      Top = 73
      Width = 51
      Height = 15
      Caption = 'Descri'#231#227'o'
    end
    object Label3: TLabel
      Left = 435
      Top = 73
      Width = 31
      Height = 15
      Caption = 'NCM:'
    end
    object Label4: TLabel
      Left = 1
      Top = 1
      Width = 511
      Height = 32
      Align = alTop
      Alignment = taCenter
      Caption = 'Produto Selecionado: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 234
    end
    object eDescricaoProdutoSelecionado: TEdit
      Left = 123
      Top = 94
      Width = 306
      Height = 23
      Enabled = False
      TabOrder = 0
    end
    object eCodigoProdutoSelecionado: TNumberBox
      Left = 4
      Top = 94
      Width = 113
      Height = 23
      Enabled = False
      TabOrder = 1
    end
    object eNCMProdutoSelecionado: TNumberBox
      Left = 435
      Top = 94
      Width = 72
      Height = 23
      Enabled = False
      TabOrder = 2
    end
  end
  object bBuscarProduto: TBitBtn
    Left = 8
    Top = 32
    Width = 298
    Height = 32
    Hint = 'Buscar produto'
    Caption = '&Buscar Produto'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = bBuscarProdutoClick
  end
  object pnProdutoTributacao: TPanel
    Left = 8
    Top = 217
    Width = 737
    Height = 382
    Color = clBtnShadow
    ParentBackground = False
    TabOrder = 5
    Visible = False
    object Label9: TLabel
      Left = 7
      Top = 56
      Width = 39
      Height = 15
      Caption = 'C'#243'digo'
    end
    object Label10: TLabel
      Left = 83
      Top = 56
      Width = 14
      Height = 15
      Caption = 'Ex:'
    end
    object Label15: TLabel
      Left = 159
      Top = 56
      Width = 54
      Height = 15
      Caption = 'Descri'#231#227'o:'
    end
    object Label23: TLabel
      Left = 559
      Top = 56
      Width = 45
      Height = 15
      Caption = 'Valor R$:'
    end
    object Label24: TLabel
      Left = 635
      Top = 56
      Width = 88
      Height = 15
      Caption = 'Valor L'#237'quido R$:'
    end
    object Label25: TLabel
      Left = 471
      Top = 56
      Width = 31
      Height = 15
      Caption = 'NCM:'
    end
    object lbApresentacaoProduto: TLabel
      Left = 1
      Top = 1
      Width = 735
      Height = 28
      Align = alTop
      Alignment = taCenter
      Caption = 'lbApresentacaoProduto'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 208
    end
    object eCodigo: TNumberBox
      Left = 7
      Top = 77
      Width = 70
      Height = 23
      Enabled = False
      TabOrder = 0
    end
    object eEx: TNumberBox
      Left = 83
      Top = 77
      Width = 70
      Height = 23
      Enabled = False
      TabOrder = 1
    end
    object eDescricao: TEdit
      Left = 159
      Top = 77
      Width = 306
      Height = 23
      Enabled = False
      TabOrder = 2
    end
    object gbTributacao: TGroupBox
      Left = 7
      Top = 110
      Width = 160
      Height = 267
      Caption = 'Tributa'#231#227'o %:'
      TabOrder = 3
      object Label12: TLabel
        Left = 11
        Top = 18
        Width = 88
        Height = 15
        Caption = 'Nacional Federal'
      end
      object Label5: TLabel
        Left = 11
        Top = 68
        Width = 102
        Height = 15
        Caption = 'Importados Federal'
      end
      object Label6: TLabel
        Left = 10
        Top = 168
        Width = 53
        Height = 15
        Caption = 'Municipal'
      end
      object Label14: TLabel
        Left = 10
        Top = 118
        Width = 44
        Height = 15
        Caption = 'Estadual'
      end
      object Label16: TLabel
        Left = 11
        Top = 218
        Width = 29
        Height = 15
        Caption = 'Total:'
      end
      object eTribNacionalFederal: TNumberBox
        Left = 11
        Top = 39
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 0
      end
      object eTribImportadosFederal: TNumberBox
        Left = 11
        Top = 89
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 1
      end
      object eTribEstadual: TNumberBox
        Left = 10
        Top = 139
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 2
      end
      object eTribMunicipal: TNumberBox
        Left = 11
        Top = 189
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 3
      end
      object eSomaTributacao: TEdit
        Left = 10
        Top = 239
        Width = 141
        Height = 23
        Enabled = False
        TabOrder = 4
      end
    end
    object gbValores: TGroupBox
      Left = 173
      Top = 110
      Width = 160
      Height = 267
      Caption = 'Valores Tributa'#231#227'o R$'
      TabOrder = 4
      object Label7: TLabel
        Left = 11
        Top = 18
        Width = 88
        Height = 15
        Caption = 'Nacional Federal'
      end
      object Label8: TLabel
        Left = 11
        Top = 68
        Width = 102
        Height = 15
        Caption = 'Importados Federal'
      end
      object Label11: TLabel
        Left = 10
        Top = 168
        Width = 53
        Height = 15
        Caption = 'Municipal'
      end
      object Label13: TLabel
        Left = 10
        Top = 118
        Width = 44
        Height = 15
        Caption = 'Estadual'
      end
      object Label17: TLabel
        Left = 10
        Top = 218
        Width = 29
        Height = 15
        Caption = 'Total:'
      end
      object eSomaValoresTributacao: TEdit
        Left = 11
        Top = 239
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 0
      end
      object eValorTributacaoMunicipal: TEdit
        Left = 11
        Top = 189
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 1
      end
      object eValorTributacaoEstadual: TEdit
        Left = 11
        Top = 139
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 2
      end
      object eValorTributacaoImportadosFederal: TEdit
        Left = 11
        Top = 89
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 3
      end
      object eValorTributacaoNacionalFederal: TEdit
        Left = 11
        Top = 39
        Width = 140
        Height = 23
        Enabled = False
        TabOrder = 4
      end
    end
    object eValorProduto: TNumberBox
      Left = 559
      Top = 77
      Width = 70
      Height = 23
      Enabled = False
      TabOrder = 5
    end
    object eValorLiquido: TNumberBox
      Left = 635
      Top = 77
      Width = 85
      Height = 23
      Enabled = False
      TabOrder = 6
    end
    object eNCM: TNumberBox
      Left = 471
      Top = 77
      Width = 70
      Height = 23
      Enabled = False
      TabOrder = 7
    end
    object GroupBox1: TGroupBox
      Left = 339
      Top = 110
      Width = 381
      Height = 267
      Caption = 'Outras Informa'#231#245'es:'
      TabOrder = 8
      object Label18: TLabel
        Left = 11
        Top = 18
        Width = 107
        Height = 15
        Caption = 'Data Vig'#234'ncia Inicio:'
      end
      object Label19: TLabel
        Left = 11
        Top = 68
        Width = 95
        Height = 15
        Caption = 'Data Vig'#234'ncia Fim'
      end
      object Label20: TLabel
        Left = 10
        Top = 168
        Width = 34
        Height = 15
        Caption = 'Vers'#227'o'
      end
      object Label21: TLabel
        Left = 10
        Top = 118
        Width = 33
        Height = 15
        Caption = 'Chave'
      end
      object Label22: TLabel
        Left = 11
        Top = 218
        Width = 30
        Height = 15
        Caption = 'Fonte'
      end
      object eFonte: TEdit
        Left = 11
        Top = 239
        Width = 365
        Height = 23
        Enabled = False
        TabOrder = 0
      end
      object eVersao: TEdit
        Left = 11
        Top = 189
        Width = 142
        Height = 23
        Enabled = False
        TabOrder = 1
      end
      object eChave: TEdit
        Left = 11
        Top = 139
        Width = 142
        Height = 23
        Enabled = False
        TabOrder = 2
      end
      object eDataVigenciaInicio: TMaskEdit
        Left = 11
        Top = 39
        Width = 141
        Height = 23
        Enabled = False
        TabOrder = 3
        Text = ''
      end
      object eDataVigenciaFim: TMaskEdit
        Left = 11
        Top = 89
        Width = 141
        Height = 23
        Enabled = False
        TabOrder = 4
        Text = ''
      end
    end
  end
  object bConsultarTributacaoProduto: TBitBtn
    Left = 545
    Top = 32
    Width = 200
    Height = 25
    Hint = 'Consultar tributacao do produto'
    Caption = '&Consultar Tributa'#231#227'o do Produto'
    TabOrder = 3
    OnClick = bConsultarTributacaoProdutoClick
  end
  object bTestarConexao: TBitBtn
    Left = 544
    Top = 63
    Width = 200
    Height = 25
    Hint = 'Testar a conex'#227'o com o banco de dados'
    Caption = 'Testar &Conex'#227'o'
    TabOrder = 6
    OnClick = bTestarConexaoClick
  end
  object bImportarTabela: TBitBtn
    Left = 544
    Top = 94
    Width = 200
    Height = 25
    Hint = 'Selecionar arquivo para importar'
    Caption = '&Importar Tablela'
    TabOrder = 7
    OnClick = bImportarTabelaClick
  end
  object bImportarTodasTabelas: TBitBtn
    Left = 544
    Top = 125
    Width = 200
    Height = 25
    Hint = 'Importar todas as tabelas'
    Caption = 'Importar &Todas As Tabelas'
    TabOrder = 8
    OnClick = bImportarTodasTabelasClick
  end
  object bLimparTela: TBitBtn
    Left = 545
    Top = 156
    Width = 200
    Height = 25
    Hint = 'Limpar dados'
    Caption = '&Limpar Tela'
    TabOrder = 9
    OnClick = bLimparTelaClick
  end
  object bSair: TBitBtn
    Left = 544
    Top = 187
    Width = 200
    Height = 25
    Hint = 'Limpar dados'
    Caption = '&Sair'
    TabOrder = 10
    OnClick = bSairClick
  end
  object OpenDialog1: TOpenDialog
    Filter = 'Csv|*.csv|Excel |*.xlx|Excel 2007|*.xlsx'
    Title = 'Importar Planilhas'
    Left = 456
    Top = 88
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 512
    Top = 152
  end
end
