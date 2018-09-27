class AddNAnexoResponsavel < ActiveRecord::Migration
  def change
  	add_column :inquerito_policiais, :numero_anexo, :string
  	add_column :inquerito_policiais, :defensor_responsavel, :string  	  	
  end
end
