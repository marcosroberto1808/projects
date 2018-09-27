class AddClassificacaoDocumentonoDocumento < ActiveRecord::Migration
  def change
		add_column :documentos, :classificacao_documento_id, :integer  	  	  	
  end
end
