class Infracao < ActiveRecord::Base
  belongs_to :inquerito_policial
  validates_presence_of :descricao_nome, :descricao_codigo
end
