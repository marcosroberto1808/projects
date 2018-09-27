class CreateProcessoJudicialHasVistaDosAutos < ActiveRecord::Migration
  def change
    create_table :processo_judicial_has_vista_dos_autos do |t|
      t.integer :processo_judicial_id, null: true
      t.integer :defensor_id, null: true
      t.integer :defensor_sem_fronteira_id, null: true
      t.date :data, null: false
    end

    add_foreign_key :processo_judicial_has_vista_dos_autos, :processo_judiciais, name: "andamento_has_vista_dos_autos_pj_fk"
    add_foreign_key :processo_judicial_has_vista_dos_autos, :defensor_sem_fronteiras, name: "andamento_has_vista_dos_autos_dsf_fk"
  end
end
