class CreateAndamentos < ActiveRecord::Migration
  def change
    create_table :andamentos do |t|
      t.references :classificacao_andamento, index: true
      t.references :documento, index: true
      t.references :processo, index: true
      t.boolean :resposta_necessidade
      t.text :resposta
      t.date :data_resposta
      t.date :data
      t.date :data_verificar_resposta
      t.text :resultado
      t.string :numero_processual

      t.timestamps
    end
  end
end
