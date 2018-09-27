class AddCamposForo < ActiveRecord::Migration
  def change
  	add_column :foruns, :uf, :string	
  	add_column :foruns, :cidade, :integer
  end
end
