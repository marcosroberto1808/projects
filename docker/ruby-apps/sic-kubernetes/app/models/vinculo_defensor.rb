class VinculoDefensor < ActiveRecord::Base
  belongs_to :assistido

  validates :defensor_cpf, uniqueness: { scope: :assistido_id }
end
