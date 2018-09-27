class AddDataFatoToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_fato, :date
  end
end
