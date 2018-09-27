class RemoveFieldVistaDosAutosFlagFromProcessoJudiciais < ActiveRecord::Migration
  def change
    if column_exists? :processo_judiciais, :vistas_autos_flag, :boolean
      remove_column :processo_judiciais, :vistas_autos_flag, :boolean
    end
  end
end
