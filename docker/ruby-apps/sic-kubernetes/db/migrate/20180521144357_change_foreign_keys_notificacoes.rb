class ChangeForeignKeysNotificacoes < ActiveRecord::Migration
  def change
    add_foreign_key :notificacoes, :andamentos, column: :andamento_id,
                    class_name: :andamento
  end
end
