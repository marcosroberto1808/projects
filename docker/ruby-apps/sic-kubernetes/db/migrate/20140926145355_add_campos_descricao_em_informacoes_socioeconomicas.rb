class AddCamposDescricaoEmInformacoesSocioeconomicas < ActiveRecord::Migration
  def change
  	add_column :informacao_socioeconomicas, :usa_drogas_descricao, :string
  	add_column :informacao_socioeconomicas, :aceita_tratamento_descricao, :string
  	add_column :informacao_socioeconomicas, :problema_sauda_descricao, :string
  	add_column :informacao_socioeconomicas, :incluido_atividade_presidio_descricao, :string
  	add_column :informacao_socioeconomicas, :trabalhava_antes_prisao_descricao, :string
  end
end
