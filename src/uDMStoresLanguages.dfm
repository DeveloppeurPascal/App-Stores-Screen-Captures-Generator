object dmStoresLanguages: TdmStoresLanguages
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object fdStoresLanguages: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 304
    Top = 224
    object fdStoresLanguagesLibelle: TStringField
      FieldName = 'Libelle'
    end
    object fdStoresLanguagesFolder: TStringField
      FieldName = 'Folder'
    end
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 432
    Top = 224
  end
end
