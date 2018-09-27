class AddCidadeCrime < ActiveRecord::Migration
  def change
  	add_column :inquerito_policiais, :cidade_crime, :string  	  	
  end
end
