class Notificacao < ActiveRecord::Base
  belongs_to :assistido
  belongs_to :evento

  validates_presence_of :data, :descricao, message: ": O campo tem que ser preenchido."

  def assistido_nome
    self.assistido.nome rescue 'Usuário'
  end
end
