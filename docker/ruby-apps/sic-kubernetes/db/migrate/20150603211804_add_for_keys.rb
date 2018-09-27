class AddForKeys < ActiveRecord::Migration
  def change
    add_foreign_key "inquerito_policiais", "origem_inqueritos", name: "origem_inquerito_inquerito_id_fk"  	
    add_foreign_key "processo_judiciais", "foruns", name: "foruns_processo_judicial_id_fk"  	  	
  end
end
