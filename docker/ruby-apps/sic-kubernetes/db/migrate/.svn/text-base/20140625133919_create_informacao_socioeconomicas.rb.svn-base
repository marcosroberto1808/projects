class CreateInformacaoSocioeconomicas < ActiveRecord::Migration
  def change
    create_table :informacao_socioeconomicas do |t|
      t.references :assistido, index: true
      t.string :nivel_escolaridade
      t.boolean :usa_drogas
      t.boolean :aceita_tratamento
      t.boolean :problema_sauda
      t.boolean :incluido_atividade_presidio
      t.boolean :trabalhava_antes_prisao
      t.string :renda_familiar

      t.timestamps
    end
  end
end
