class AddDataTjAcusacaoToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_tj_acusacao, :date
  end
end
