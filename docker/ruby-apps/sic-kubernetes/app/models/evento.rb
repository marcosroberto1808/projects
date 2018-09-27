class Evento < ActiveRecord::Base
  belongs_to :assistido
  has_many :notificacao, :dependent => :delete_all
end
