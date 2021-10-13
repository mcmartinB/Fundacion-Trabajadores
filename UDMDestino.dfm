object DMDestino: TDMDestino
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 923
  Top = 154
  Height = 364
  Width = 464
  object dbDestino: TDatabase
    DatabaseName = 'dbDestino'
    DriverName = 'INFORMIX'
    Params.Strings = (
      'SERVER NAME=servername'
      'DATABASE NAME=database'
      'USER NAME=user'
      'OPEN MODE=READ/WRITE'
      'SCHEMA CACHE SIZE=8'
      'LANGDRIVER='
      'SQLQRYMODE='
      'SQLPASSTHRU MODE=SHARED AUTOCOMMIT'
      'LOCK MODE=5'
      'DATE MODE=0'
      'DATE SEPARATOR=/'
      'SCHEMA CACHE TIME=-1'
      'MAX ROWS=-1'
      'BATCH COUNT=200'
      'ENABLE SCHEMA CACHE=FALSE'
      'SCHEMA CACHE DIR='
      'ENABLE BCD=FALSE'
      'LIST SYNONYMS=NONE'
      'DBNLS='
      'COLLCHAR='
      'BLOBS TO CACHE=64'
      'BLOB SIZE=32'
      'PASSWORD=password')
    SessionName = 'Default'
    Left = 24
    Top = 24
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'txt'
    FileName = 'script.txt'
    Filter = 'Texto|*.txt'
    Left = 24
    Top = 112
  end
  object qryEmpresas: TQuery
    DatabaseName = 'dbDestino'
    Left = 80
    Top = 56
  end
  object qryOperarios: TQuery
    DatabaseName = 'dbDestino'
    DataSource = dsEmpresas
    Left = 144
    Top = 32
  end
  object kmtOperarios: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
    IndexDefs = <>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    FilterOptions = []
    Version = '4.08b'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 24
    Top = 176
  end
  object dsTrabajadores: TDataSource
    DataSet = qryOperarios
    Left = 208
    Top = 56
  end
  object dsEmpresas: TDataSource
    DataSet = qryEmpresas
    Left = 136
    Top = 88
  end
  object tblOperarios: TQuery
    DatabaseName = 'dbDestino'
    DataSource = dsEmpresas
    RequestLive = True
    Left = 112
    Top = 176
  end
  object qrySerial: TQuery
    DatabaseName = 'dbDestino'
    Left = 112
    Top = 232
  end
  object qryCodPlanta: TQuery
    DatabaseName = 'dbDestino'
    Left = 192
    Top = 232
  end
end
