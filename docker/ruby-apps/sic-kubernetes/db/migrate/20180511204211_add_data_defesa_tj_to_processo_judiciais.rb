class AddDataDefesaTjToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_defesa_tj, :date
  end
end
