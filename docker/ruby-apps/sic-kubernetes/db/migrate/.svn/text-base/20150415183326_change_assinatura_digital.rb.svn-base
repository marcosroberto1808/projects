class ChangeAssinaturaDigital < ActiveRecord::Migration
  def change
  	add_column :assinatura_virtuais, :assistido_id, :string
		rename_column :assinatura_virtuais, :assistido_id, :usuario_id
  end
end