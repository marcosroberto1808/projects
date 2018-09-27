class ProcessoJudiciaisController < ApplicationController
  include NotificacoesHelper
  include ProcessoJudiciaisHelper

  before_action :set_processo_judicial, only: [:show, :edit, :update, :destroy]
  before_action :get_supplies, only: [:new, :edit]

  def index
    redirect_to root_url
  end

  def apagar_andamento
    notificacao = Notificacao.where(andamento_id: params[:andamento_id]).first
    if notificacao
      notificacao.destroy
    end
    Andamento.find(params[:andamento_id]).destroy
    redirect_to processo_judicial_path(params[:processo_id]), notice: "Andamento deletado com sucesso."
  end

  def add_infracao_new
    @infracao = Infracao.new
    respond_to do |format|
      @infracao["descricao_codigo"] = params["infracao_codigo"]
      @infracao["descricao_nome"] = params["infracao_nome"]
      format.js        
    end
  end

  def add_local
    if numeric?(params[:lcl_atc_acompanhar])
      local_atuacao_id = params[:lcl_atc_acompanhar]
    else
       local_atuacao_id = LotacaoDefensor.find_by_descricao_local(params[:lcl_atc_acompanhar]).id
    end
    @local_atuacao_processo = LocalAtuacaoProcesso.new(processo_judicial_id: params[:id] ? params[:id] : nil,
                                                       lotacao_defensor_id: local_atuacao_id)
    respond_to do |format|
      format.js        
    end
  end

  def show
    @assistido = Assistido.find(session["assistido_selecionado"].present? ? session["assistido_selecionado"] :
                                    params[:id])
    @andamentos = @processo_judicial.andamento.order("data desc")
    @vistas_dos_autos_rows = @processo_judicial.get_vistas_dos_autos
  end

  def new
    @processo_judicial = ProcessoJudicial.new
    @processo_judicial["cidade"] = "Fortaleza"
    get_supplies
  end

  def edit
    get_supplies
    @is_edit = true
  end

  def create
    @processo_judicial = ProcessoJudicial.new(processo_judicial_params)
    @processo_judicial["assistido_id"] = session["assistido_selecionado"]

    if params["processo_judicial"]["vara_id"].present?
      @juizo = Vara.find(params["processo_judicial"]["vara_id"])
      @processo_judicial["cidade"] = @juizo.forum.cidade_nome
      @processo_judicial["estado"] = @juizo.forum.uf
    end

    respond_to do |format|
      if @processo_judicial.save
        salva_locais if params[:locais]

        if valida_local_atuacao_vazio
          redirect_to new_processo_judicial_path(@processo_judicial), :alert => "Local Atuação: O campo tem que ser preenchido." and return
        end
        valida_vista_dos_autos(params)
        gerar_notificacoes()
        format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}", notice: 'Processo Judicial criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @processo_judicial }
      else
        @assistido = Assistido.find(session["assistido_selecionado"])
        @inqueritos = InqueritoPolicial.where(assistido_id: session["assistido_selecionado"])
        @lotacoes = LotacaoDefensor.get_lotacao_defensor(get_cpf)
        @foruns = Forum.all
        @varas = Vara.all

        get_supplies

        format.html { render action: 'new' }
        format.json { render json: @processo_judicial.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params["processo_judicial"]["vara_id"].present? and @processo_judicial["vara_id"].to_s != params["processo_judicial"]["vara_id"].to_s
      @historico_local = LocalizacaoProcesso.new
      @juizo = Vara.find(params["processo_judicial"]["vara_id"])
      @historico_local["processo_judicial_id"] = @processo_judicial["id"]
      @historico_local["foro"] = @juizo.forum.nome
      @historico_local["juizo"] = @juizo.nome
    end

    respond_to do |format|
      if params['processo_judicial']['processo_tipo'] == ProcessoJudicial::PROCESSO_TIPO_CRIMINAL
        params['processo_judicial'].delete('cidade_id')
        params['processo_judicial'].delete('data_de_alerta')
      end

      if params['processo_judicial']['processo_tipo'] == ProcessoJudicial::PROCESSO_TIPO_EXECUCAO_PENAL
        params['processo_judicial'].delete('data_fato')
        params['processo_judicial'].delete('data_rec_denuncia')
        params['processo_judicial'].delete('data_publicacao_sentenca')
        params['processo_judicial'].delete('data_tj_acusacao')
        params['processo_judicial'].delete('data_publicacao_acordao')
        params['processo_judicial'].delete('data_defesa_tj')
      end

      if @processo_judicial.update(processo_judicial_params)
        if params["processo_judicial"]["vara_id"].present?
          @juizo = Vara.find(params["processo_judicial"]["vara_id"])
          @processo_judicial.update_attributes(cidade: @juizo.forum.cidade_nome, estado: @juizo.forum.uf)
        end
        salva_locais if params[:locais]
        if valida_local_atuacao_vazio
          redirect_to :back, :alert => "Local Atuação: O campo tem que ser preenchido." and return
        end
        @historico_local.save unless @historico_local.nil?
        valida_vista_dos_autos(params)
        gerar_notificacoes()

        format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}", notice: 'Processo Judicial editado com sucesso.' }
        format.json { head :no_content }
      else
        @assistido = Assistido.find(session["assistido_selecionado"])
        @inqueritos = InqueritoPolicial.where(assistido_id: session["assistido_selecionado"])
        @foruns = Forum.all
        @varas = Vara.all
        @is_edit = true

        get_supplies

        format.html { render action: 'edit' }
        format.json { render json: @processo_judicial.errors, status: :unprocessable_entity }
      end
    end
  end

  def salva_locais
    params[:locais].each  do |local|
      local_atuacao_processo = LocalAtuacaoProcesso.new(processo_judicial_id: @processo_judicial.id, lotacao_defensor_id: local)

      local_atuacao_processo.save unless local_atuacao_processo.acompanhamento_existe?
    end
  end

  def destroy
    @processo_judicial.delete
    respond_to do |format|
      format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}" }
      format.json { head :no_content }
    end
  end

  def valida_local_atuacao_vazio
    params[:locais] == nil and (LocalAtuacaoProcesso.where(:processo_judicial_id => @processo_judicial.id).size == 0)
  end

  def destroy_penal
    @processo_judicial.destroy
    respond_to do |format|
      format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}" }
      format.json { head :no_content }
    end
  end

  def gerar_ficha
    @andamento = Andamento.find(params['id'])
    @processo_judicial = ProcessoJudicial.find(@andamento.processo_id)
    @assistido = Assistido.find(@processo_judicial.assistido_id)
    @situacao = Situacao.find_by(assistido_id: @processo_judicial.assistido_id,
                              inquerito_policial_id: @processo_judicial.inquerito_policial_id)
    InqueritoPolicial.find_by(id: @processo_judicial.inquerito_policial_id)
    if @processo_judicial.processo_tipo == 'Execução Penal'
      respond_to do |format|

        format.pdf {
          render pdf: "ficha-padronizada",
                 locals: {
                     artigo: @inquerito_policial ? @inquerito_policial.infracao.pluck('descricao_codigo').join(','): '',
                     current_user: current_user
                 },
                 footer: { center: "[page] of [topage]" }

        }
      end
    else
      redirect_to :action => "show", :id => @processo_judicial.id
    end
  end

  def get_varas
    @varas = Vara.all
  end

  private
    def set_processo_judicial
      @processo_judicial = ProcessoJudicial.find(params[:id])
    end

    def processo_judicial_params
      params.require(:processo_judicial).permit(:assistido_id, :numero, :cidade, :forum_id, :natureza, :data_abertura,
                                                :data_arquivamente, :resumo, :julgado, :recurso, :carta_guia, :tipo,
                                                :status, :updated_at, :created_at, :estado, :inquerito_policial_id,
                                                :vara_id, :processo_tipo, :data_fato, :data_rec_denuncia,
                                                :data_publicacao_sentenca, :data_tj_acusacao, :data_publicacao_acordao,
                                                :data_defesa_tj, :data_de_alerta, :cidade_id, :capitulacao, :regime,
                                                :pena, :genero_delitivo, :natureza_delitiva, :tempo_medida_cautelar,
                                                :data_progressao_de_regime, :data_livramento_condicional, :defensor_cpf,
                                                :operador_cpf)
    end

    def get_supplies
      @assistido = Assistido.find(session["assistido_selecionado"])
      @inqueritos = InqueritoPolicial.where(assistido_id: session["assistido_selecionado"])
      @foruns = Forum.all
      @varas_criminais = Vara.get_varas_criminais
      @varas_de_execucao_penal = Vara.get_varas_de_execucao_penal
      @lotacoes = LotacaoDefensor.get_lotacao_defensor(get_cpf)
      @cidades = Cidade.all.order(:nome)
      @vara_interior_id = Vara::VARA_INTERIOR
      @naturezas = ProcessoJudicial.get_naturezas_choices
      @yes_or_no_choices = ProcessoJudicial.yes_no_choices
      @processo_tipos_choices = ProcessoJudicial.get_processo_tipos_choices
      @tipos_choices = ProcessoJudicial.get_tipos_choices
      @status_choices = ProcessoJudicial.get_status_choices
      @vistas_autos_flag = 1
      @data_vistas_autos = @processo_judicial.get_data_vistas_autos(current_user)
      if !@data_vistas_autos
        @vistas_autos_flag = 0
        @data_vistas_autos = DateTime.now.to_date
      end
      @regime_choices = ProcessoJudicial.get_status_regime
      @genero_choices = ProcessoJudicial.get_genero_delitivo
      @natureza_delitiva_choices = ProcessoJudicial.get_natureza_delitiva
      @medida_cautelar_choices = ProcessoJudicial.get_tempo_medida_cautelar
    end

    def gerar_notificacoes()
      situacao = ProcessoJudicial.find(@processo_judicial.id).assistido.situacao.last
      if validar_data(@processo_judicial.data_progressao_de_regime)
        notificar_processo(@processo_judicial,
                           situacao,
                           @processo_judicial.data_progressao_de_regime,
                           "Notificação de Processo - Progressão de Regime(#{@processo_judicial.assistido.nome}).")
      end
      if validar_data(@processo_judicial.data_livramento_condicional)
        notificar_processo(@processo_judicial,
                           situacao,
                           @processo_judicial.data_livramento_condicional,
                           "Notificação de Processo - Livramento Condicional(#{@processo_judicial.assistido.nome}).")
      end
      if validar_data(@processo_judicial.data_de_alerta)
        notificar_processo(@processo_judicial,
                           situacao,
                           @processo_judicial.data_de_alerta,
                           "Notificação de Processo(#{@processo_judicial.assistido.nome}).")
      end
    end

    def valida_vista_dos_autos(params)
      if !params['data_vista_dos_autos'].empty? and params['vistas_autos_flag'] == ProcessoJudiciaisHelper::VISTA_DOS_ALTOS_OK
        params['processo_judicial_id'] = @processo_judicial.id
        ProcessoJudicial.associar_vistas_autos(current_user, params)
      end
    end
end
