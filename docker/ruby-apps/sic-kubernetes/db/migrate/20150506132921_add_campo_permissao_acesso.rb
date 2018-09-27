class AddCampoPermissaoAcesso < ActiveRecord::Migration
  def change
  	add_column :permissao_acessos, :defensor, :string  	
  end
end
