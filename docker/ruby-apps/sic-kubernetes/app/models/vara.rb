class Vara < ActiveRecord::Base
  belongs_to :forum
  has_many	 :processo_judicial
  validates_presence_of :nome, message: ": O campo tem que ser preenchido."
  validates_presence_of :forum_id, message: ": O campo tem que ser preenchido."
  before_destroy :check_for_processos

  VARA_TJ_ID = 46
  VARA_VEPA_ID = 28
  VARA_VEP_01_ID = 25
  VARA_VEP_02_ID = 26
  VARA_VEP_03_ID = 27
  VARA_INTERIOR = 60

  def check_for_processos
    if processo_judicial.count > 0
      errors.add(:base, "Existem Processos, atrelados a este Juízo. Deleção não realizada.")
      return false
    end
  end

  def self.get_varas_de_execucao_penal_ids
    return [VARA_TJ_ID, VARA_VEPA_ID, VARA_VEP_01_ID, VARA_VEP_02_ID, VARA_VEP_03_ID, VARA_INTERIOR]
  end

  def self.get_varas_de_execucao_penal
    ids = self.get_varas_de_execucao_penal_ids
    return self.find(ids, :order => 'nome DESC')
  end

  def self.get_varas_criminais
    ids = self.get_varas_de_execucao_penal_ids
    return self.where.not(id: ids).order(:nome)
  end
end
