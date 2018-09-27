class AddImportacaoSejus < ActiveRecord::Migration
  def change
    add_column :assistidos, :id_importacao_sejus, :integer
  end
end
