class AddFieldsToProcessoJudiciais < ActiveRecord::Migration
  def self.up
    add_column :processo_judiciais, :data_progressao_de_regime, :date
    add_column :processo_judiciais, :data_livramento_condicional, :date
    add_column :processo_judiciais, :defensor_cpf, :string
  end

  def self.down
    remove_column :processo_judiciais, :data_progressao_de_regime
    remove_column :processo_judiciais, :data_livramento_condicional
    remove_column :processo_judiciais, :defensor_cpf
  end
end
