class CreateNotificacoes < ActiveRecord::Migration
  def change
    create_table :notificacoes do |t|
      t.references :assistido, index: true
      t.boolean :preso
      t.string :instituicao
      t.string :cidade
      t.string :uf
      t.date :data_prisao
      t.string :motivo

      t.timestamps
    end
  end
end
