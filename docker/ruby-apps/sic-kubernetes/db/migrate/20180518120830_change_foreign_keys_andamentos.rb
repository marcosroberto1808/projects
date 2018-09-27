class ChangeForeignKeysAndamentos < ActiveRecord::Migration
  def change
    add_foreign_key :andamentos, :classificacao_andamentos, column: :classificacao_andamento_id,
                    class_name: :classificacao_andamento
    add_foreign_key :andamentos, :documentos, column: :documento_id, class_name: :documento
    change_column_null :andamentos, :processo_id, true, column: :processo_id,
                    class_name: :processo_judicial
  end
end
