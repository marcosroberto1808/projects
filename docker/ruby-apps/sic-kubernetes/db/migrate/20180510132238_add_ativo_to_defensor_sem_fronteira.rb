class AddAtivoToDefensorSemFronteira < ActiveRecord::Migration
  def change
    add_column :defensor_sem_fronteiras, :ativo, :boolean
  end
end
