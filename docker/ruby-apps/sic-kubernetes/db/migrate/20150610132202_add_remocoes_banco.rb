class AddRemocoesBanco < ActiveRecord::Migration
  def change
		remove_column :documentos, :tipo_documento_id  	
  end
end
