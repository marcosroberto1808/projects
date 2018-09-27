class AddFieldToNotificacao < ActiveRecord::Migration
  def self.up
    add_column :notificacoes, :processo_id, :integer
  end

  def self.down
    remove_column :notificacoes, :processo_id
  end
end
