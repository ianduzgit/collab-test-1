object dmCocoFone: TdmCocoFone
  OldCreateOrder = False
  Height = 252
  Width = 323
  object con1: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=m8st3rk3y'
      'Server=localhost'
      'Database=G:\DB\FB\ORIXA.FDB'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 32
    Top = 32
  end
  object FDTransaction1: TFDTransaction
    Options.ReadOnly = True
    Connection = con1
    Left = 128
    Top = 32
  end
  object Q1: TFDQuery
    Connection = con1
    Transaction = FDTransaction1
    FetchOptions.AssignedValues = [evMode, evRowsetSize, evUnidirectional]
    FetchOptions.Mode = fmAll
    FetchOptions.Unidirectional = True
    FetchOptions.RowsetSize = -1
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    Left = 128
    Top = 120
  end
  object FBDriver1: TFDPhysFBDriverLink
    Left = 32
    Top = 120
  end
  object BatchMove1: TFDBatchMove
    Reader = BatchReader1
    Writer = BatchWriter1
    Mappings = <>
    LogFileName = 'Data.log'
    Left = 232
    Top = 32
  end
  object BatchReader1: TFDBatchMoveDataSetReader
    DataSet = Q1
    Left = 232
    Top = 120
  end
  object BatchWriter1: TFDBatchMoveJSONWriter
    DataDef.Fields = <>
    Encoding = ecUTF8
    Left = 232
    Top = 192
  end
end
