class AddDataRecDenunciaToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_rec_denuncia, :date
  end
end
