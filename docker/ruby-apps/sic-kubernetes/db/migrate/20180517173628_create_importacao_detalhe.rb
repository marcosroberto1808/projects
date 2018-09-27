class CreateImportacaoDetalhe < ActiveRecord::Migration
  def change
    create_table :importacao_detalhes do |t|
      t.belongs_to :assistido, index: true
      t.string :tipo_informacao
      t.string :responsavel_juridico
      t.text :objetivo
      t.string :tipo
      t.string :status
      t.text :descricao
      t.string :usuario_nome
      t.string :unidade_nome
      t.string :unidade_abreviacao
      t.datetime :data_informacao
      t.datetime :data_inclusao
      t.datetime :data_atualizacao
    end
    add_foreign_key :importacao_detalhes, :assistidos, column: :assistido_id, class_name: :assistido
  end
end
