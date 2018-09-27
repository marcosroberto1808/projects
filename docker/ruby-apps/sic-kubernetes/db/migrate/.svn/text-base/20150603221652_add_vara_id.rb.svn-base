class AddVaraId < ActiveRecord::Migration
  def change
  	add_column :processo_judiciais, :vara_id, :integer  	
    add_foreign_key "processo_judiciais", "varas", name: "varas_processo_judicial_id_fk"  	
  end
end
