class AddPessoaFisicaNomeToDefensorSemFronteira < ActiveRecord::Migration
  def change
    add_column :defensor_sem_fronteiras, :pessoa_fisica_nome, :text
  end
end
