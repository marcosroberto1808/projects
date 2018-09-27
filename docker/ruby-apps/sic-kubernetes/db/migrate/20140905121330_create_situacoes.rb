class CreateSituacoes < ActiveRecord::Migration
  def change
    create_table :situacoes do |t|
      t.string :situacao_estado
      t.string :instituicao
      t.string :cidade
      t.string :uf
      t.date :data_prisao
      t.string :motivo
      t.references :assistido, index: true

      t.timestamps
    end
  end
end
