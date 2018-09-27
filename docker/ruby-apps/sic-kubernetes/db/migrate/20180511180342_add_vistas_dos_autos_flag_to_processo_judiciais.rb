class AddVistasDosAutosFlagToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :vistas_autos_flag, :bool
  end
end
