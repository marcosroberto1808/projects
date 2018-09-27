class AddOperadorCpfToAndamento < ActiveRecord::Migration
  def self.up
    add_column :andamentos, :operador_cpf, :string
  end

  def self.down
    remove_column :andamentos, :operador_cpf
  end
end
