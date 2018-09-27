class AssinaturaVirtual < ActiveRecord::Base
  belongs_to :assistido

  validates_presence_of :url, message: ": Não foi selecionado."  
end
