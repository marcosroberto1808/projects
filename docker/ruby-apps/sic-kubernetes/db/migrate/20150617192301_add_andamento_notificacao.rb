class AddAndamentoNotificacao < ActiveRecord::Migration
  def change
  	add_column :notificacoes, :andamento_id, :integer  	  	
  end
end
