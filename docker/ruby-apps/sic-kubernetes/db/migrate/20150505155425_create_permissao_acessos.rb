class CreatePermissaoAcessos < ActiveRecord::Migration
  def change
    create_table :permissao_acessos do |t|
      t.string :cpf
      t.date :data

      t.timestamps
    end
  end
end
