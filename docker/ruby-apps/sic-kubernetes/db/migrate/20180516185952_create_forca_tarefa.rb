class CreateForcaTarefa < ActiveRecord::Migration
  def change
    create_table :forca_tarefas do |t|
      t.string :nome, null: false
      t.date :data_inicial, null: false
      t.date :data_final, null: false
      t.boolean :ativo, null: false
    end
  end
end
