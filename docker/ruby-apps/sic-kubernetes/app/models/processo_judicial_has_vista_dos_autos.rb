class ProcessoJudicialHasVistaDosAutos < ActiveRecord::Base
  before_save :check_if_exists

  def check_if_exists
    if self.defensor_id
      exists = ProcessoJudicialHasVistaDosAutos.exists?(
          data: self.data,
          defensor_id: self.defensor_id,
          processo_judicial_id: self.processo_judicial_id,
      )
    end

    if self.defensor_sem_fronteira_id
      exists = ProcessoJudicialHasVistaDosAutos.exists?(
          data: self.data,
          processo_judicial_id: self.processo_judicial_id,
          defensor_sem_fronteira_id: self.defensor_sem_fronteira_id,
      )
    end

    not exists
  end
end
