class OrigemInquerito < ActiveRecord::Base
  belongs_to :cidade
  has_many :inquerito_policiais

  validates_presence_of :nome, :cidade
  before_destroy :check_for_inqueritos

  def check_for_inqueritos
    if inquerito_policiais.count > 0
      errors.add(:base, "Existem Inquéritos, atrelados a esta Origem. Deleção não realizada.")
      return false
    end
  end

end
