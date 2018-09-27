module NotificacoesHelper

  def notificar_andamento(andamento, situacao)
    notificados = [ andamento.defensor_cpf, andamento.operador_cpf]
    notificados.each do |notificado|
      if notificado.present?
        notificacao = noticiacao(andamento, situacao, nil)
        notificacao["data"] = andamento.data_alerta
        notificacao["descricao"] = "Notificação de Andamento(#{andamento.classificacao_andamento.descricao})."
        notificacao["notificado"] = notificado
        notificacao.save
      end
    end
  end

  def notificar_andamento_processo(processo, situacao, andamento)
    notificados = [ processo.defensor_cpf, processo.operador_cpf]
    notificados.each do |notificado|
      if notificado.present?
        notificacao = noticiacao(andamento, situacao, processo)
        notificacao["preso"] = true
        notificacao["data"] = situacao.data_prisao + 30
        notificacao["descricao"] = "Notificação de 30 dias do relaxamento de prisão."
        notificacao["tipo"] = "Automático"
        notificacao["notificado"] = notificado
        notificacao.save
      end
    end
  end

  def notificar_andamento_processo_inquerito(processo, situacao, andamento)
    notificacao = noticiacao(andamento, situacao, processo)
    notificacao["preso"] = true
    notificacao["data"] = situacao.data_prisao + 30
    notificacao["descricao"] = "Notificação de 30 dias do relaxamento de prisão."
    notificacao["tipo"] = "Automático"
    notificacao.save
  end

  def notificar_processo(processo, situacao, data, descricao)
    notificados = [ processo.defensor_cpf, processo.operador_cpf]
    notificados.each do |notificado|
      if notificado.present?
        notificacao = noticiacao(nil, situacao, processo)
        notificacao["preso"] = true
        notificacao["data"] = data
        notificacao["descricao"] = descricao
        notificacao["andamento_id"] = nil
        notificacao["notificado"] = notificado
        notificacao.save
      end
    end
  end

  def noticiacao(andamento, situacao, processo)
    notificacao = Notificacao.new
    notificacao["assistido_id"] = situacao.assistido.id
    notificacao["instituicao"] = situacao.instituicao
    notificacao["cidade"] = situacao.cidade
    notificacao["uf"] = situacao.uf
    notificacao["tipo"] = "Agendado"
    if andamento.present?
      notificacao["andamento_id"] = andamento.id
    end
    if processo.present?
      notificacao["uf"] = processo.estado
      notificacao["cidade"] = processo.cidade
      notificacao["notificado"] = processo.inquerito_policial.present? ? processo.inquerito_policial.defensor_responsavel : processo.defensor_cpf
      notificacao["processo_id"] = processo.id
    end
    notificacao
  end

  def notificar(evento, usuario)
    notificacao = Notificacao.new
    notificacao["data"] = evento.data
    notificacao["uf"] = evento.uf
    notificacao["cidade"] = evento.cidade
    notificacao["instituicao"] = evento.instituicao
    notificacao["tipo"] = evento.tipo
    notificacao["descricao"] = evento.descricao
    notificacao["assistido_id"] = evento.assistido_id
    notificacao["evento_id"] = evento.id
    notificacao["notificado"] = usuario
    notificacao.save
  end

  def notificar_assistido(situacao)
    notificacao = Notificacao.new
    notificacao["assistido_id"] = situacao.assistido.id
    notificacao["preso"] = true
    notificacao["instituicao"] = situacao.instituicao
    notificacao["cidade"] = situacao.cidade
    notificacao["uf"] = situacao.uf
    notificacao["data"] = situacao.data_prisao + 90
    notificacao["descricao"] = "Notificação de 90 dias de prisão."
    notificacao["tipo"] = "Automático"
    notificacao["notificado"] = situacao.inquerito_policial.defensor_responsavel
    notificacao.save
    notificacao
  end
end
