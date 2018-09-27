class ProcessoJudicial < ActiveRecord::Base
  audited
  belongs_to :assistido
  belongs_to :inquerito_policial
  belongs_to :forum
  belongs_to :vara
    
  has_many :local_atuacao_processo, :dependent => :delete_all
  has_many :localizacao_processos, :dependent => :delete_all
  has_many :documento, :dependent => :delete_all
  has_many :andamento, :dependent => :delete_all, foreign_key: :processo_id

  validates_presence_of :vara_id, :numero, :cidade, :natureza, :processo_tipo, message: ": O campo tem que ser preenchido."
  validates_presence_of :tipo, message: ": O campo tem que ser preenchido.", if: :is_execucao_penal?
  validates_presence_of :defensor_cpf, :operador_cpf, message: ": O campo tem que ser preenchido (Defensor ou Operador).", if: :is_datas_alerta?
  validates :status, :inclusion => {in: [true, false], message: ": O campo tem que ser preenchido."}, if: :is_execucao_penal?
  validates :julgado, :recurso, :carta_guia, :inclusion => {in: [true, false], message: ": O campo tem que ser preenchido."}, if: :is_acao_penal?

  PROCESSO_TIPO_CRIMINAL = 'Criminal'
  PROCESSO_TIPO_EXECUCAO_PENAL = 'Execução Penal'

  NATUREZA_ACAO_PENAL = 'Ação Penal'
  NATUREZA_EXECUCAO_PENAL = 'Execução Penal'

  TIPO_DEFINITIVO = 'Definitivo'
  TIPO_PROVISORIO = 'Provisório'

  STATUS_EXTINTA = 0
  STATUS_EM_CURSO = 1

  REGIME_ABERTO = 'Aberto'
  REGIME_SEMIABERTO = 'Semiaberto'
  REGIME_FECHADO = 'Fechado'

  GENERO_VIDA = 'Vida'
  GENERO_PATRIMONIO = 'Patrimônio'
  GENERO_LESAO_CORPORAL = 'Lesão Corporal'
  GENERO_LIBERDADE_SEXUAL = 'Liberdade Sexual'
  GENERO_DROGAS = 'Drogas'
  GENERO_OUTROS = 'Outros'

  NATUREZA_HEDIONDO = 'Hediondo'
  NATUREZA_COMUM = 'Comum'
  NATUREZA_COM_VIOLENCIA = 'Com Violência'
  NATUREZA_SEM_VIOLENCIA = 'Sem Violência'

  MEDIDA_CAUTELAR_3MESES = 'Até 3 Meses'
  MEDIDA_CAUTELAR_6MESES = 'Até 6 Meses'
  MEDIDA_CAUTELAR_1ANO = 'Até 1 Ano'
  MEDIDA_CAUTELAR_MAIS_1ANO = '+ de 1 Ano'


  def self.get_naturezas
    [NATUREZA_ACAO_PENAL, NATUREZA_EXECUCAO_PENAL]
  end

  def self.get_status_choices
    [['Selecione uma opção', ''], ['Em Curso', STATUS_EM_CURSO], ['Extinta', STATUS_EXTINTA]]
  end

  def self.get_naturezas_choices
    choices = [['Selecione uma opção', '']]

    self.get_naturezas.each do |i|
      choices.append([i, i])
    end

    return choices
  end

  def self.get_status_regime
    [['Selecione um opção', ''], [REGIME_ABERTO, REGIME_ABERTO], [REGIME_SEMIABERTO, REGIME_SEMIABERTO], [REGIME_FECHADO, REGIME_FECHADO]]
  end

  def self.get_genero_delitivo
    [['Selecione um opção', ''], [GENERO_VIDA, GENERO_VIDA], [GENERO_PATRIMONIO, GENERO_PATRIMONIO], [GENERO_LESAO_CORPORAL, GENERO_LESAO_CORPORAL], [GENERO_LIBERDADE_SEXUAL, GENERO_LIBERDADE_SEXUAL], [GENERO_DROGAS, GENERO_DROGAS], [GENERO_OUTROS, GENERO_OUTROS]]
  end

  def self.get_natureza_delitiva
    [['Selecione um opção', ''], [NATUREZA_HEDIONDO, NATUREZA_HEDIONDO], [NATUREZA_COMUM, NATUREZA_COMUM], [NATUREZA_COM_VIOLENCIA, NATUREZA_COM_VIOLENCIA], [NATUREZA_SEM_VIOLENCIA, NATUREZA_SEM_VIOLENCIA]]
  end

  def self.get_tempo_medida_cautelar
    [['Selecione um opção', ''], [MEDIDA_CAUTELAR_3MESES, MEDIDA_CAUTELAR_3MESES], [MEDIDA_CAUTELAR_6MESES, MEDIDA_CAUTELAR_6MESES], [MEDIDA_CAUTELAR_1ANO, MEDIDA_CAUTELAR_1ANO], [MEDIDA_CAUTELAR_MAIS_1ANO, MEDIDA_CAUTELAR_MAIS_1ANO]]
  end

  def self.get_processo_tipos
    [PROCESSO_TIPO_CRIMINAL, PROCESSO_TIPO_EXECUCAO_PENAL]
  end

  def self.get_processo_tipos_choices
    choices = [['Selecione uma opção', '']]

    self.get_processo_tipos.each do |i|
      choices.append([i, i])
    end

    return choices
  end

  def self.get_tipos
    [TIPO_DEFINITIVO, TIPO_PROVISORIO]
  end

  def self.get_tipos_choices
    choices = [['Selecione uma opção', '']]

    self.get_tipos.each do |i|
      choices.append([i, i])
    end

    return choices
  end

  def self.yes_no_choices
    [['Selecione uma opção', ''], ['Sim', 1], ['Não', 0]]
  end

  def is_acao_penal?
    natureza == NATUREZA_ACAO_PENAL
  end

  def is_execucao_penal?
    natureza == NATUREZA_EXECUCAO_PENAL
  end

  def is_datas_alerta?
    (data_de_alerta.present? or data_progressao_de_regime.present? or data_livramento_condicional.present?) and
        (!defensor_cpf.present? and !operador_cpf.present?)
  end

  def self.associar_vistas_autos(current_user, params)
    if params['vistas_autos_flag'] and params['data_vista_dos_autos']

      data = {}
      if current_user.is_a?(Colaborador)
        data['defensor_id'] = current_user.id
      end

      if current_user.is_a?(DefensorSemFronteira)
        data['defensor_sem_fronteira_id'] = current_user.id
      end

      data['data'] = params['data_vista_dos_autos']
      data['processo_judicial_id'] = params['processo_judicial_id']

      ProcessoJudicialHasVistaDosAutos.create(data)
    end
  end

  def get_data_vistas_autos(current_user)
    if not self.id.nil?
      terms = []

      if current_user.is_a?(Colaborador)
        terms.append("defensor_id = #{current_user.id}")
      end

      if current_user.is_a?(DefensorSemFronteira)
        terms.append("defensor_sem_fronteira_id = #{current_user.id}")
      end

      terms.append("processo_judicial_id = #{self.id}")

      row = ProcessoJudicialHasVistaDosAutos.where([terms.join(' AND ')]).order(:id).last

      if row
        row.data
      end
    end
  end

  def get_vistas_dos_autos
    vistas_autos = ProcessoJudicialHasVistaDosAutos.where(processo_judicial_id: self.id).order(data: :desc)

    vistas_dos_autos_rows = []

    vistas_autos.each do |row|
      defensor = row.defensor_id.present? ? Colaborador.find(row.defensor_id) : DefensorSemFronteira.find(row.defensor_sem_fronteira_id)
      vistas_dos_autos_rows << {nome: defensor.pessoa_fisica_nome, data: row.data}
    end

    vistas_dos_autos_rows
  end
end
