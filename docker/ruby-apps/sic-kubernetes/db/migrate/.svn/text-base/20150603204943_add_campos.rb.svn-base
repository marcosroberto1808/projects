class AddCampos < ActiveRecord::Migration
  def change
  	add_column :processo_judiciais, :forum_id, :integer  	  	
  	remove_column :processo_judiciais, :foro

  	add_column :inquerito_policiais, :origem_inquerito_id, :integer  	
  	remove_column :inquerito_policiais, :origem
  end
end