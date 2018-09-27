class AddFieldsToDefensorSemFronteiras < ActiveRecord::Migration
  def self.up
    add_column :defensor_sem_fronteiras, :email_alternativo, :string
    add_column :defensor_sem_fronteiras, :estado, :string
  end

end
