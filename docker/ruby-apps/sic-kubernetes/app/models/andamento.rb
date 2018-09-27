class Andamento < ActiveRecord::Base
  audited
  belongs_to :classificacao_andamento
  belongs_to :documento
  belongs_to :processo_judicial
  belongs_to :audit

  validate :validate_if_forca_tarefa?
  validate :validate_if_not_forca_tarefa?
  validate :validate_options_checked?
  validates_presence_of :defensor_cpf, :operador_cpf, message: ": O campo tem que ser preenchido (Defensor ou Operador).", if: :is_datas_alerta?

  after_destroy :remove_filhos
  serialize :problemas_identificados, Array

  PI_NENHUM = 'Nenhum'
  PI_PRESO_CONDENADO_SEM_GUIA_DE_RECOLHIMENTO = 'Preso condenado sem guia de recolhimento'
  PI_FALHA_DE_COMUNICACAO_A_RESPEITO_DO_CUMPRIMENTO_DO_MANDADO = 'Falha de Comunicação a respeito do cumprimento de mandado'
  PI_BENEFICIO_VENCIDO_NA_EXECUCAO = 'Benefício vencido na execução'
  PI_EXCESSO_DE_PRAZO_NA_FORMACAO_DA_CULPA = 'Excesso de prazo na formação da Culpa'
  PI_DETENTO_ORIUNDO_DE_COMARCA_SEM_DPE = 'Detento oriundo de comarca sem DPE'
  PI_FALTA_DE_ATENDIMENTO_PELA_DPE = 'Falta de Atendimento pela DPE'
  PI_PEDIDO_DE_LIBERDADE_PROVISORIA_REQUERIDO = 'Pedido de liberdade Provisória requerido, mas sem apreciação judicial'
  PI_HABEAS_CORPUS_IMPRETADO_E_NAO_APRECIADO = 'Habeas Corpus Impetrado e não apreciado'
  PI_BENEFICIO_DE_EXECUCAO_PENAL_REQUERIDO = 'Benefício de Execução Penal requerido, mas sem apreciação judicial'
  PI_PRESO_COM_PROBLEMA_DE_IDENTIFICACAO = 'Preso com Problema de Identificação'
  PI_OUTROS = 'Outros'
  PI_PRESO_SEM_VINCULOS_FAMILIARES_CUMPRINDO_PENA_NA_CAPITAL = 'Preso sem vínculos familiares cumprindo pena na capital'

  def processo_judicial
    ProcessoJudicial.find(processo_id)
  end

  def remove_filhos
    @assistido = self.processo_judicial.assistido_id
    @notificacoes = Notificacao.where(assistido_id: @assistido, descricao: "Notificação de 30 dias do relaxamento de prisão.", andamento_id: self.id)
    if @notificacoes.present?
      @notificacoes.destroy_all
    end
    if self.documento_id.present?
      @documento = Documento.find(self.documento_id)
      @documento.destroy
    end
  end

  def self.problemas_identificados
    [
      PI_NENHUM,
      PI_PRESO_CONDENADO_SEM_GUIA_DE_RECOLHIMENTO,
      PI_FALHA_DE_COMUNICACAO_A_RESPEITO_DO_CUMPRIMENTO_DO_MANDADO,
      PI_BENEFICIO_VENCIDO_NA_EXECUCAO,
      PI_EXCESSO_DE_PRAZO_NA_FORMACAO_DA_CULPA,
      PI_DETENTO_ORIUNDO_DE_COMARCA_SEM_DPE,
      PI_FALTA_DE_ATENDIMENTO_PELA_DPE,
      PI_PEDIDO_DE_LIBERDADE_PROVISORIA_REQUERIDO,
      PI_HABEAS_CORPUS_IMPRETADO_E_NAO_APRECIADO,
      PI_BENEFICIO_DE_EXECUCAO_PENAL_REQUERIDO,
      PI_PRESO_COM_PROBLEMA_DE_IDENTIFICACAO,
      PI_OUTROS,
      PI_PRESO_SEM_VINCULOS_FAMILIARES_CUMPRINDO_PENA_NA_CAPITAL,
    ]
  end

  def validate_if_forca_tarefa?
    if forca_tarefa
        errors.add :forca_tarefa_id, " deve ser selecionado" if forca_tarefa_id.nil?
    end
  end

  def validate_if_not_forca_tarefa?
    if !forca_tarefa
      errors.add :classificacao_andamento_id, "deve ser selecionado quando não for Força Tarefa" if classificacao_andamento_id.nil?
      errors.add :data, "deve ser preenchido quando não for Força Tarefa" if data.nil?
    end
  end

  def validate_options_checked?
    if forca_tarefa
      errors.add "Previamente assistido por:", "Deve ter pelo menos uma opção selecionada" if !pa_advogado_particular and !pa_asistencia_juridica and !pa_defensor_publico and !pa_sem_asistencia
      errors.add "Atendimento:", "Deve ter pelo menos uma opção selecionada" if !at_presencial and !at_analise_processual
      errors.add "Situação Prisional:", "Deve ter pelo menos uma opção selecionada" if !sp_provisiorio and !sp_condenado
      errors.add "Problemas Identificados:", "Deve ter pelo menos uma opção selecionada" if problemas_identificados.length == 0
    end
  end

  def save
    if self.data.nil?
      self.data = DateTime.now.strftime('%Y-%m-%d')
    end
    super
  end

  def is_datas_alerta?
    data_alerta.present? and (!defensor_cpf.present? and !operador_cpf.present?)
  end

end
