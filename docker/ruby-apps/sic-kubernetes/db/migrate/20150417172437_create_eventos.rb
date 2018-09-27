class CreateEventos < ActiveRecord::Migration
  def change
    create_table :eventos do |t|
      t.date :data
      t.string :descricao
      t.string :tipo
      t.integer :local_atuacao
      t.references :assistido, index: true

      t.timestamps
    end
  end
end
