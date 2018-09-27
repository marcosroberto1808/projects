class CreateDocumentos < ActiveRecord::Migration
  def change
    create_table :documentos do |t|
      t.references :tipo_documento, index: true
      t.references :assistido, index: true
      t.references :inquerito_policial, index: true
      t.references :processo_judicial, index: true
      t.date :data
      t.string :nome_url
      t.boolean :resposta_necessidade
      t.text :resposta

      t.timestamps
    end
  end
end
