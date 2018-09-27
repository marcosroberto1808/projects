class AlterLocalAtuacaoProcessos < ActiveRecord::Migration
  def change
  	remove_column :local_atuacao_processos, :foro
  	remove_column :local_atuacao_processos, :juizo
  	add_column :local_atuacao_processos, :lotacao_defensor_id, :integer
  end
end
