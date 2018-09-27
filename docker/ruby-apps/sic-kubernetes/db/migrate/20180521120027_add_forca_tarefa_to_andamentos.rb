class AddForcaTarefaToAndamentos < ActiveRecord::Migration
  def self.up
    add_reference :andamentos, :forca_tarefa , index: true
    add_foreign_key :andamentos, :forca_tarefas
  end

  def self.down
    remove_foreign_key :andamentos, :forca_tarefas
    remove_reference :andamentos, :forca_tarefa, foreign_key: true
  end

end
