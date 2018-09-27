class AddOperadorCpfToProcessoJudicial < ActiveRecord::Migration
  def self.up
    add_column :processo_judiciais, :operador_cpf, :string
  end

  def self.down
    remove_column :processo_judiciais, :operador_cpf
  end
end
