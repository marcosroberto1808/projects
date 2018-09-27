class RemoveTipoToClassificacaoAndamento < ActiveRecord::Migration
  def self.up
    remove_column :classificacao_andamentos, :tipo
  end

  def self.down
    add_column :classificacao_andamentos, :tipo, :string
  end
end
