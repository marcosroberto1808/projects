class AddDataDeAlertaToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_de_alerta, :date
  end
end
