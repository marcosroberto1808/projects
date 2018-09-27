class TipoDocumento < ActiveRecord::Base
  has_many :classificacao_documentos

  PESSOAL_ID = 1
  EXTRAJUDICIAL_ID = 2
  PROCESSO_ID = 3
  INQUERITO_ID = 4
end
