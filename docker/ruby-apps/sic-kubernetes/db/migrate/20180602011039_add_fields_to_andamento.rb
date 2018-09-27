class AddFieldsToAndamento < ActiveRecord::Migration
  def change
    add_column :andamentos, :data_alerta, :date
    add_column :andamentos, :defensor_cpf, :string
  end
end
