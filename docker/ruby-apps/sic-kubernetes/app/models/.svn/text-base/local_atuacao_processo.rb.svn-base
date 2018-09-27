class LocalAtuacaoProcesso < ActiveRecord::Base
  belongs_to :processo_judicial
  belongs_to :lotacao_defensor

  def acompanhamento_existe?
  	busca = LocalAtuacaoProcesso.find_by(processo_judicial_id: processo_judicial_id, lotacao_defensor_id: lotacao_defensor_id)
  	return (!busca.nil?) #retorna false se achar nada
  end
end
