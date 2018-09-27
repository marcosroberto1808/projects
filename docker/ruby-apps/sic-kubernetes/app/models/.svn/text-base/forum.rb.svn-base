class Forum < ActiveRecord::Base
  has_many :vara
  has_many :processo_judicial
  
  validates_presence_of :nome, :cidade  

  before_destroy :check_for_varas, :check_for_processos

  def check_for_varas
    if vara.count > 0
      errors.add(:base, "Existem Juízos, atrelados a este Foro. Deleção não realizada.")
      return false
    end
  end

  def check_for_processos
    if processo_judicial.count > 0
      errors.add(:base, "Existem Processos, atrelados a este Foro. Deleção não realizada.")
      return false
    end
  end  

  def cidade_nome
  	Cidade.find(self["cidade"]).nome
  end
end
