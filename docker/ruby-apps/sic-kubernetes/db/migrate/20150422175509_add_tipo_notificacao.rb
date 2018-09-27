class AddTipoNotificacao < ActiveRecord::Migration
  def change
  	add_column :notificacoes, :tipo, :string
  end
end
