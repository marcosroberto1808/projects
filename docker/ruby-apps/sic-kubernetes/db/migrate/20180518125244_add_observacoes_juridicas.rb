class AddObservacoesJuridicas < ActiveRecord::Migration
  def change
    add_column :assistidos, :historico_delito_atual, :text
    add_column :assistidos, :antecedentes_criminais, :text
    add_column :assistidos, :pretensoes_futuras, :text
    add_column :assistidos, :observacoes_complementares, :text
  end
end
