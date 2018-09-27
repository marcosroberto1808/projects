module AssistidosHelper

  def get_assistido(id_assistido)
    if id_assistido.present?
      Assistido.find(id_assistido).nome
    end
  end

  def get_status_processo_vinculo(acompanhar_processo)
    acompanhar_processo ? "Sim" : "Não"
  end

  def get_status_processo_inquerito(acompanhar_inquerito)
    acompanhar_inquerito ? "Sim" : "Não"
  end

end
