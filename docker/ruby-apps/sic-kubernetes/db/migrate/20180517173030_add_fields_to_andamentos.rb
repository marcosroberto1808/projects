class AddFieldsToAndamentos < ActiveRecord::Migration
  def change
    add_column :andamentos, :observacao, :text
    add_column :andamentos, :forca_tarefa, :boolean
    add_column :andamentos, :pa_advogado_particular, :boolean
    add_column :andamentos, :pa_asistencia_juridica, :boolean
    add_column :andamentos, :pa_defensor_publico, :boolean
    add_column :andamentos, :pa_sem_asistencia, :boolean
    add_column :andamentos, :at_presencial, :boolean
    add_column :andamentos, :at_analise_processual, :boolean
    add_column :andamentos, :sp_provisiorio, :boolean
    add_column :andamentos, :sp_condenado, :boolean
  end
end
