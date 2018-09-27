class CreateClassificacaoDocumentos < ActiveRecord::Migration
  def change
    create_table :classificacao_documentos do |t|
      t.string :descricao

      t.timestamps
    end
  end
end
