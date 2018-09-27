class AddProcessoTipoToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :processo_tipo, :string, :default => 'Criminal'
  end
end
