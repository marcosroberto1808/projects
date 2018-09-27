class CreateLocalAtuacaoProcessos < ActiveRecord::Migration
  def change
    create_table :local_atuacao_processos do |t|
      t.references :processo_judicial, index: true

      t.timestamps
    end
  end
end
