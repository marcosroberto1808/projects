class AumentaTamanhoDescricaoEmInfoSocioecon < ActiveRecord::Migration
  def change
  	change_column :informacao_socioeconomicas, :usa_drogas_descricao, :text
  	change_column :informacao_socioeconomicas, :aceita_tratamento_descricao, :text
  	change_column :informacao_socioeconomicas, :problema_sauda_descricao, :text
  	change_column :informacao_socioeconomicas, :incluido_atividade_presidio_descricao, :text
  	change_column :informacao_socioeconomicas, :trabalhava_antes_prisao_descricao, :text
  end
end
