class CreateClassificacaoAndamentos < ActiveRecord::Migration
  def change
    create_table :classificacao_andamentos do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
