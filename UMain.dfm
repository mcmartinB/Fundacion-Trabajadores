object FMain: TFMain
  Left = 163
  Top = 345
  Width = 1087
  Height = 551
  Caption = 'FUNDACI'#211'N ANTONIO BONNY: ACTUALIZAR OPERARIOS'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlGrids: TPanel
    Left = 0
    Top = 40
    Width = 1071
    Height = 473
    Align = alBottom
    TabOrder = 2
    object dbgrdTrabajadores: TDBGrid
      Left = 1
      Top = 185
      Width = 1069
      Height = 287
      Align = alClient
      DataSource = DMDestino.dsTrabajadores
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
    end
    object pnl1: TPanel
      Left = 1
      Top = 1
      Width = 1069
      Height = 184
      Align = alTop
      Caption = 'pnl1'
      TabOrder = 0
      object dbgrdEmpresas: TDBGrid
        Left = 1
        Top = 1
        Width = 1067
        Height = 182
        Align = alClient
        DataSource = DMDestino.dsEmpresas
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
      end
    end
  end
  object btnActualizar: TButton
    Left = 2
    Top = 3
    Width = 699
    Height = 30
    Caption = 
      'Actualizar Operarios --->>> Directorio Programa \ DatosTrabajado' +
      'resFundacion.csv'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnActualizarClick
  end
  object btnSalir: TButton
    Left = 704
    Top = 3
    Width = 365
    Height = 30
    Caption = 'SALIR'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnSalirClick
  end
end
