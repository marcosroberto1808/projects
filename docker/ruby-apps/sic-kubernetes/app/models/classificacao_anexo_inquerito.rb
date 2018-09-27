class ClassificacaoAnexoInquerito < ActiveRecord::Base
 validates_presence_of :descricao

 before_destroy :check_for_documentos

  def check_for_documentos
  	#@documentos.where()
    #if forum.count > 0
    #  errors.add(:base, "Existem entradas de Foros, atreladas a esta cidade. Deleção não realizada.")
    #  return false
    #end
  end
end
