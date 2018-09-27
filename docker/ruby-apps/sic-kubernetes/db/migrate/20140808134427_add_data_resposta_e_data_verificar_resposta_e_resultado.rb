class AddDataRespostaEDataVerificarRespostaEResultado < ActiveRecord::Migration
  def change
		add_column :documentos, :data_resposta, :date  	
		add_column :documentos, :data_verificar_resposta, :date
		add_column :documentos, :resultado, :string		
  end
end
