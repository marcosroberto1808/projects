class AddUrlImageAssistido < ActiveRecord::Migration
  def change
		add_column :assistidos, :imagem_url, :string, :default => "images/avatar/no_image.jpg", :null => false
  end
end
