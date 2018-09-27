class CreateOrigemInqueritos < ActiveRecord::Migration
  def change
    create_table :origem_inqueritos do |t|
      t.string :uf
      t.references :cidade, index: true
      t.string :nome

      t.timestamps
    end
  end
end
