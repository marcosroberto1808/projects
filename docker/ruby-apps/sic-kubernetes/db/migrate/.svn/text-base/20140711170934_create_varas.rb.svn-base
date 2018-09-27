class CreateVaras < ActiveRecord::Migration
  def change
    create_table :varas do |t|
      t.string :nome
      t.references :forum, index: true

      t.timestamps
    end
  end
end
