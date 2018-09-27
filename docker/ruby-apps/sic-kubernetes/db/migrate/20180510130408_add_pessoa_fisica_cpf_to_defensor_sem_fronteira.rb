class AddPessoaFisicaCpfToDefensorSemFronteira < ActiveRecord::Migration
  def change
    add_column :defensor_sem_fronteiras, :pessoa_fisica_cpf, :text
  end
end
