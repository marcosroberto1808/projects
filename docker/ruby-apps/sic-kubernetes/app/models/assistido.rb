class Assistido < ActiveRecord::Base
  audited
  self.table_name = 'public.assistidos'
  has_many :documento, :dependent => :delete_all
  has_many :inquerito_policial, :dependent => :delete_all
  has_many :processo_judicial, :dependent => :delete_all
  has_many :informacao_socioeconomica, :dependent => :delete_all
  has_many :situacao, :dependent => :delete_all
  has_many :notificacao, :dependent => :delete_all
  has_many :situacao, :dependent => :delete_all
  has_many :evento, :dependent => :delete_all
  has_many :importacao_detalhe
  before_save :upcase_fields
  before_validation :upcase_fields

  validates_presence_of :nome, message: ": O campo tem que ser preenchido."
  validates_presence_of :nome_mae, message: ": O campo tem que ser preenchido."  
  validates_presence_of :data_nascimento, message: ": O campo tem que ser preenchido."

  validates :nome, uniqueness: { scope: :nome_mae, case_sensitive: false, message: "- Este assistido já foi cadastrado!" }

  def upcase_fields
    self.nome.upcase! if self.nome.present?
    self.nome_mae.upcase! if self.nome_mae.present?
    self.nome_pai.upcase! if self.nome_pai.present?
  end

  def sincronizar(data)
    self.import_pareceres(data)
    self.import_peticoes(data)
    self.import_oficios(data)
    self.import_situacao(data)
    self.import_processos
    self.import_observacoes_juridicas
  end

  def import_pareceres(data)
    ImportacaoDetalhe.where(assistido_id: self.id, tipo_informacao: ImportacaoDetalhe::PARECER).destroy_all
    pareceres = data['pareceres']
    pareceres.each do |parecer|
      importacao_detalhe = ImportacaoDetalhe.new
      importacao_detalhe.assistido = self
      importacao_detalhe.tipo_informacao = ImportacaoDetalhe::PARECER
      importacao_detalhe.responsavel_juridico = parecer['responsavel_juridico']
      importacao_detalhe.descricao = parecer['descricao']
      importacao_detalhe.status = parecer['status']
      importacao_detalhe.data_informacao = self.sanitize_date(parecer['data_parecer'])
      importacao_detalhe.usuario_nome = parecer['usuario_nome']
      importacao_detalhe.data_inclusao = self.sanitize_date(parecer['data_inclusao'])
      importacao_detalhe.data_atualizacao = self.sanitize_date(parecer['data_atualizacao'])
      importacao_detalhe.save
    end

  end

  def import_peticoes(data)
    ImportacaoDetalhe.where(assistido_id: self.id, tipo_informacao: ImportacaoDetalhe::PETICAO).destroy_all
    peticoes = data['peticoes']
    peticoes.each do |peticao|
      importacao_detalhe = ImportacaoDetalhe.new
      importacao_detalhe.assistido = self
      importacao_detalhe.tipo_informacao = ImportacaoDetalhe::PETICAO
      importacao_detalhe.responsavel_juridico = peticao['responsavel_juridico']
      importacao_detalhe.objetivo = peticao['objetivo']
      importacao_detalhe.tipo = peticao['tipo']
      importacao_detalhe.status = peticao['status']
      importacao_detalhe.data_informacao = self.sanitize_date(peticao['data_peticao'])
      importacao_detalhe.usuario_nome = peticao['usuario_nome']
      importacao_detalhe.data_inclusao = self.sanitize_date(peticao['data_inclusao'])
      importacao_detalhe.data_atualizacao = self.sanitize_date(peticao['data_atualizacao'])
      importacao_detalhe.save
    end
  end

  def import_oficios(data)
    ImportacaoDetalhe.where(assistido_id: self.id, tipo_informacao: ImportacaoDetalhe::OFICIO).destroy_all
    oficios = data['oficios']
    oficios.each do |oficio|
      importacao_detalhe = ImportacaoDetalhe.new
      importacao_detalhe.assistido = self
      importacao_detalhe.tipo_informacao = ImportacaoDetalhe::OFICIO
      importacao_detalhe.responsavel_juridico = oficio['responsavel_juridico']
      importacao_detalhe.unidade_nome = oficio['unidade_nome']
      importacao_detalhe.unidade_abreviacao = oficio['unidade_abreviacao']
      importacao_detalhe.objetivo = oficio['objetivo']
      importacao_detalhe.data_informacao = self.sanitize_date(oficio['data_documento'])
      importacao_detalhe.usuario_nome = oficio['usuario_nome']
      importacao_detalhe.data_inclusao = self.sanitize_date(oficio['data_inclusao'])
      importacao_detalhe.data_atualizacao = self.sanitize_date(oficio['data_atualizacao'])
      importacao_detalhe.save
    end
  end

  def import_processos
    ImportacaoDetalhe.where(assistido_id: self.id, tipo_informacao: ImportacaoDetalhe::PROCESSO).destroy_all
    seq_pessoa = self.id_importacao_sejus
    url = API_SEJUS + "#{seq_pessoa}/processos/"
    auth = {username: API_SEJUS_USERNAME, password: API_SEJUS_PASSWORD}
    response = HTTParty.get(url, basic_auth: auth)
    if response.parsed_response.present?
      response.parsed_response.each do |processo|
        importacao_detalhe = ImportacaoDetalhe.new
        importacao_detalhe.assistido = self
        importacao_detalhe.tipo_informacao = ImportacaoDetalhe::PROCESSO
        importacao_detalhe.unidade_nome = processo['unidade']
        importacao_detalhe.descricao = processo['observacoes']
        importacao_detalhe.situacao = processo['situacao']
        importacao_detalhe.numero_processo = processo['numero_processo'].strip
        importacao_detalhe.data_prisao = self.sanitize_date(processo['data_prisao'])
        importacao_detalhe.vara = processo['vara']
        importacao_detalhe.save
      end
    end
  end

  def sanitize_date(date)
    if date.present?
      d = date.split(' ')[0].split('-')
      DateTime.new(d[0].to_i, d[1].to_i, d[2].to_i)
    end
  end

  def import_observacoes_juridicas
    seq_pessoa = self.id_importacao_sejus
    url_juridicas = API_SEJUS + "#{seq_pessoa}/observacoesjuridicas"
    url_complementares = API_SEJUS + "#{seq_pessoa}/observacoescomplementares"
    auth = {username: API_SEJUS_USERNAME, password: API_SEJUS_PASSWORD}
    observacoesjuridicas = HTTParty.get(url_juridicas, basic_auth: auth).parsed_response
    observacoescomplementares = HTTParty.get(url_complementares, basic_auth: auth).parsed_response

    self.historico_delito_atual = observacoesjuridicas['historico_delito_atual']
    self.antecedentes_criminais = observacoesjuridicas['antecedentes_criminais']
    self.pretensoes_futuras = observacoescomplementares['pretensoes_futuras']
    self.observacoes_complementares = observacoescomplementares['observacoes_complementares']

  end

  def import_situacao(data)
    situacao_sejus = data['situacao']
    unidade_nome = data['unidade_nome']
    situacao = Situacao.new
    situacao.assistido = self
    situacao.situacao_estado = self.sic_situacao_import(situacao_sejus)
    situacao.instituicao = unidade_nome
    situacao.created_at = DateTime.now
    situacao.save
  end

  def sic_situacao_import(situacao)
    result = "Não Informado"
    if situacao == "LIBERTO"
      result = "Em Liberdade"
    elsif situacao == "RECOLHIDO"
        result = "Preso"
    end
    result
  end
end
