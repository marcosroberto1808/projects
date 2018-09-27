class AddDataPublicacaoSentencaToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_publicacao_sentenca, :date
  end
end
