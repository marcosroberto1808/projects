class ClassificacaoDocumento < ActiveRecord::Base
	has_many :documentos
	belongs_to :tipo_documentos

  validates_presence_of :descricao
  before_destroy :check_for_documentos

  def tipo_documento_nome
  	TipoDocumento.find(self.tipo_documento_id).descricao
  end

  def check_for_documentos
    if documento.count > 0
      errors.add(:base, "Existem Documentos, atrelados a esta classificação. Deleção não realizada.")
      return false
    end
  end 
end
