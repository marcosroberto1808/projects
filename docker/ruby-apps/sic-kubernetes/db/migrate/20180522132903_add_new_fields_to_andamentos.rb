class AddNewFieldsToAndamentos < ActiveRecord::Migration
  def change
    add_column :andamentos, :remissao_homologada, :boolean
    add_column :andamentos, :indulto_comutacao, :boolean
    add_column :andamentos, :problemas_identificados, :text

    add_column :andamentos, :data_base_progressao, :date
    add_column :andamentos, :data_progressao_de_regime, :date
    add_column :andamentos, :data_livramento_condicional, :date
  end
end
