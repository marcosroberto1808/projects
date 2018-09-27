class ClassificacaoAndamento < ActiveRecord::Base
	has_many :andamento
  validates_presence_of :descricao	

	before_destroy :check_for_andamentos

  DESCRICAO_SEM_PROVIDENCIA = 'Sem Providência'

  PR_RELAXAMENTO = 'Relaxamento'
  PR_REVOGACAO_PREVENTIVA = 'Revogação de Preventiva'
  PR_HABEAS_CORPUS = 'Habeas Corpus'
  PR_SUBSTITUICAO_CAUTELAR = 'Substituição de Cautelar'
  PR_LIBERDADE_PROVISORIA = 'Liberdade Provisória'
  PR_ALEGACOES_FINAIS = 'Alegações Finais'
  PR_RESPOSTA_ACUSACAO = 'Resposta à Acusação'
  PR_AUDIENCIA_JUSTIFICACAO = 'Audiência de Justificação'
  PR_RECURSO = 'Recurso'
  PR_PROGRESSAO_REGIME = 'Progressão de regime'
  PR_LIVRAMENTO_CONDICIONAL = 'Livramento Condicional'
  PR_INDULTO = 'Indulto'
  PR_COMUTACAO_PENAS = 'Comutação de penas'
  PR_REMICAO_PENA = 'Remição de pena'
  PR_PRISAO_DOMICILIAR = 'Prisão domiciliar'
  PR_TRABALHO_EXTERNO = 'Trabalho externo'
  PR_EXTINCAO_PUNIBILIDADE = 'Extinção da punibilidade'
  PR_EXTINCAO_PENA = 'Extinção de pena'
  PR_READEQUACAO_REGIME = 'Readequação de regime'
  PR_SOMA_PENAS = 'Soma de penas'
  PR_REVISAO_CRIMINAL = 'Revisão Criminal'
  PR_EXPEDICAO_GUIA = 'Expedição de Guia'
  PR_PROJECAO_BENEFICIO = 'Projeção de Benefício'
  PR_SEM_PROVIDENCIA = 'Sem Providência'
  PR_DEFESA_PREVIA = 'Defesa prévia'
  PR_OUTROS = 'Outros'
  PR_RETIFICACAO_CALCULO = 'Retificação de calculo'
  PR_PEDIDO_RECONSIDERACAO = 'Pedido de reconsideração'
  PR_UNIFICACAO_PENAS = 'Unificação de penas(Continuidade delitiva)'
  PR_RETIFICACAO_SOMA_PENAS = 'Retificação de soma de penas'
  PR_CALCULO_PENA = 'Calculo de pena'
  PR_SAIDA_TEMPORARIA = 'Saída temporária'
  PR_OFICIO = 'Ofício'
  PR_COMUNICACAO_INTERNA = 'Comunicação interna'
  PR_TRANSFERENCIA_EXECUCAO_PENAL = 'Transferência de execução penal'

  def check_for_andamentos
    if andamento.count > 0
      errors.add(:base, "Existem Andamentos, atrelados a esta Classificação. Deleção não realizada.")
      return false
    end
  end

  def self.providencias
    [
      DESCRICAO_SEM_PROVIDENCIA,
      PR_RELAXAMENTO,
      PR_REVOGACAO_PREVENTIVA,
      PR_HABEAS_CORPUS,
      PR_SUBSTITUICAO_CAUTELAR,
      PR_LIBERDADE_PROVISORIA,
      PR_ALEGACOES_FINAIS,
      PR_RESPOSTA_ACUSACAO,
      PR_AUDIENCIA_JUSTIFICACAO,
      PR_RECURSO,
      PR_PROGRESSAO_REGIME,
      PR_LIVRAMENTO_CONDICIONAL,
      PR_INDULTO,
      PR_COMUTACAO_PENAS,
      PR_REMICAO_PENA,
      PR_PRISAO_DOMICILIAR,
      PR_TRABALHO_EXTERNO,
      PR_EXTINCAO_PUNIBILIDADE,
      PR_EXTINCAO_PENA,
      PR_READEQUACAO_REGIME,
      PR_SOMA_PENAS,
      PR_REVISAO_CRIMINAL,
      PR_EXPEDICAO_GUIA,
      PR_PROJECAO_BENEFICIO,
      PR_SEM_PROVIDENCIA,
      PR_DEFESA_PREVIA,
      PR_OUTROS,
      PR_RETIFICACAO_CALCULO,
      PR_PEDIDO_RECONSIDERACAO,
      PR_UNIFICACAO_PENAS,
      PR_RETIFICACAO_SOMA_PENAS,
      PR_CALCULO_PENA,
      PR_SAIDA_TEMPORARIA,
      PR_OFICIO,
      PR_COMUNICACAO_INTERNA,
      PR_TRANSFERENCIA_EXECUCAO_PENAL,
    ]
  end

end
