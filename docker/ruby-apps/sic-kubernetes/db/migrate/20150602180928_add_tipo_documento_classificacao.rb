class AddTipoDocumentoClassificacao < ActiveRecord::Migration
  def change
  	add_column :classificacao_documentos, :tipo_documento_id, :integer  	
  end
end
