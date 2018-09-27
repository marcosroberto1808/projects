class CreateLocalizacaoProcessos < ActiveRecord::Migration
  def change
    create_table :localizacao_processos do |t|
      t.references :processo_judicial, index: true
      t.string :foro
      t.string :juizo

      t.timestamps
    end
  end
end
