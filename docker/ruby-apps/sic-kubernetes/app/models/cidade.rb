class Cidade < ActiveRecord::Base
	has_many :forum, foreign_key: :cidade
	has_many :origem_inquerito

  validates_presence_of :nome
  before_destroy :check_for_childs

  def check_for_childs
    if forum.count > 0
      errors.add(:base, "Existem entradas de Foros, atreladas a esta cidade. Deleção não realizada.")
      return false
    end

    if origem_inquerito.count > 0
      errors.add(:base, "Existem entradas de Origem Inquerito, atreladas a esta cidade. Deleção não realizada.")
      return false
    end
  end
end
