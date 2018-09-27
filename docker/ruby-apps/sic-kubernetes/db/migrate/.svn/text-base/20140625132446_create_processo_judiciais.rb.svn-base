class CreateProcessoJudiciais < ActiveRecord::Migration
  def change
    create_table :processo_judiciais do |t|
      t.references :assistido, index: true
      t.string :numero
      t.string :juizo
      t.string :cidade
      t.string :foro
      t.string :natureza
      t.date :data_abertura
      t.date :data_arquivamente
      t.text :resumo
      t.boolean :julgado
      t.boolean :recurso
      t.boolean :carta_guia
      t.string :tipo
      t.boolean :status

      t.timestamps
    end
  end
end
