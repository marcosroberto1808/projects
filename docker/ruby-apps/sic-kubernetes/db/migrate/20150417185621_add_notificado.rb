class AddNotificado < ActiveRecord::Migration
  def change
  	add_column :notificacoes, :notificado, :string
  end
end
