class CreateInqueritoPoliciais < ActiveRecord::Migration
  def change
    create_table :inquerito_policiais do |t|
      t.references :assistido, index: true
      t.string :origem
      t.string :cidade
      t.string :uf
      t.string :logradouro
      t.string :numero
      t.string :complemento
      t.string :bairro
      t.string :infracao_cep
      t.date :data_abertura
      t.text :observacao
      t.string :instauracao
      t.date :data_crime
      t.string :latitude
      t.string :longitude
      t.string :cep

      t.timestamps
    end
  end
end
