class InqueritoPolicial < ActiveRecord::Base
  audited
  belongs_to :assistido
  belongs_to :origem_inquerito
  has_many :infracao, :dependent => :delete_all
  has_many :documento, :dependent => :delete_all
  has_one  :situacao

  validates_presence_of :numero,
                        :numero_anexo,
                        :origem_inquerito,
                        :data_abertura,
                        :instauracao,
                        :data_crime,
                        message: ": O campo tem que ser preenchido."

end
