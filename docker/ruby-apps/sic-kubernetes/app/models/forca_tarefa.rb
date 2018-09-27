class ForcaTarefa < ActiveRecord::Base
  audited
  validates_presence_of :nome, :data_inicial, :data_final
  validates :ativo, :inclusion => { :in => [true, false] }
  validate :end_date_after_start_date?

  def end_date_after_start_date?
    if data_final and data_inicial and (data_final < data_inicial)
      errors.add :data_final, "deve ser Maior ou Igual a Data Inicial"
    end
  end
end
