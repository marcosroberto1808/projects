class AddFieldToClassificacaoAndamentos < ActiveRecord::Migration
  def change
    add_column :classificacao_andamentos, :tipo, :string
  end
end
