class CreateInfracoes < ActiveRecord::Migration
  def change
    create_table :infracoes do |t|
      t.references :inquerito_policial, index: true
      t.string :descricao_codigo
      t.string :descricao_nome

      t.timestamps
    end
  end
end
