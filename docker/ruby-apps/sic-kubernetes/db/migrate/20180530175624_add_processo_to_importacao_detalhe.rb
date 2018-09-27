class AddProcessoToImportacaoDetalhe < ActiveRecord::Migration
  def change
    add_column :importacao_detalhes, :situacao, :string
    add_column :importacao_detalhes, :numero_processo, :string
    add_column :importacao_detalhes, :data_prisao, :datetime
    add_column :importacao_detalhes, :vara, :string
  end
end
