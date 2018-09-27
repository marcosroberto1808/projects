class AddAtivoToAssistidos < ActiveRecord::Migration
  def change
    add_column :assistidos, :ativo, :boolean, null:true, default: true
  end
end
