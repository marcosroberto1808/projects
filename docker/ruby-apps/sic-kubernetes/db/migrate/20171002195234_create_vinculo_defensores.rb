class CreateVinculoDefensores < ActiveRecord::Migration
  def change
    create_table :vinculo_defensores do |t|
      t.references :assistido, index: true
      t.string :defensor_cpf
      t.boolean :acompanhar_processo
      t.boolean :acompanhar_inquerito

      t.timestamps
    end
  end
end
