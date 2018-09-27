class AndamentosController < ApplicationController
  include NotificacoesHelper

  before_action :set_andamento, only: [:show, :edit, :update, :destroy]
  before_action :set_classificacao

  respond_to :html

  def index
    redirect_to "/"
  end

  def show
    @only_show = true
    get_supplies
  end

  def new
    @andamento = Andamento.new
    @andamento.data = DateTime.now.strftime('%d/%m/%Y')
    @andamento.processo_id = params['processo']
    @processo_judicial = ProcessoJudicial.find(params['processo'])
    @is_processo_execucao = @processo_judicial.processo_tipo == ProcessoJudicial::PROCESSO_TIPO_EXECUCAO_PENAL

    get_supplies

    respond_with(@andamento)
  end

  def edit
  end

  def create
    @andamento = Andamento.new(andamento_params)
    @arquivo =  params["andamento"]["anexo"]
    if @arquivo.present?
      @documento = Documento.new
      @documento["assistido_id"] = session["assistido_selecionado"]
      @documento["processo_judicial_id"] = @andamento["processo_id"]
      @documento["data"] = @andamento["data"]
      @documento["nome_url"] = @arquivo.original_filename
      @classificacao_generica = ClassificacaoDocumento.find_by_descricao("Anexo de Andamento")
      @classificacao_generica = @classificacao_generica.id if @classificacao_generica.present?
      @documento["classificacao_documento_id"] = @classificacao_generica
      @arquivo_path = ""
      @dir_path = ""
      @arquivo_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/processos/#{@documento["processo_judicial_id"]}/#{@documento["nome_url"]}"
      @dir_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/processos/#{@documento["processo_judicial_id"]}/"      
      @documento.save
      #Checa se o diretorio existe, caso não ele cria;
      FileUtils.mkdir_p(@dir_path) unless File.directory?(@dir_path)
      #Salva o arquivo no diretorio
      File.open(@arquivo_path, 'wb') do |file|
        file.write(@arquivo.read)
      end      
    end

    @andamento["documento_id"] = @documento.id if @documento.present?

    respond_to do |format|
      if @andamento.save
        @processo = ProcessoJudicial.find(@andamento["processo_id"])
        @situacao = @processo.assistido.situacao.last

        gerar_notificacoes
        format.html {redirect_to processo_judicial_path(@andamento['processo_id']),
                                 notice: 'Andamento adicionado com sucesso.'}
        format.json { head :no_content }
      else
        if @documento.present?
          Documento.find(@documento.id).destroy
        end
        get_supplies
        format.html { render action: 'new' }
        format.json { render json: @andamento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @andamento.update(andamento_params)
    respond_with(@andamento)
  end

  def destroy
    @processo = @andamento["processo_id"]
    if @andamento.destroy
      redirect_to "/processo_judiciais/#{@processo}", notice: "Andamento deletado com sucesso."
    else
      respond_with(@andamento)
    end
  end

  def consultar
    @forca_tarefa = ForcaTarefa.where(ativo: true).order(:nome)
    @forca_tarefa_nome = ForcaTarefa.find(params[:forca_tarefa_id]) if params[:forca_tarefa_id].present?
    @relatorio = AndamentoForcaTarefa.filters_relatorio_forca_tarefa(params[:data_inicial], params[:data_final],
                                                                     params[:forca_tarefa_id],params["defensor_cpf"],
                                                                     '', '')

    respond_to do |format|
      format.html
      format.pdf { render pdf: "relatorio-forca-tarefa",
                          footer: { center: "[page] of [topage]" }
      }
    end
  end

  def atividades_realizadas
    @forca_tarefa = ForcaTarefa.where(ativo: true).order(:nome)
    @forca_tarefa_nome = ForcaTarefa.find(params[:forca_tarefa_id]) if params[:forca_tarefa_id].present?
    @relatorio = AndamentoForcaTarefa.filters_relatorio_atividades_realizadas(params[:data_inicial], params[:data_final],
                                                                              params[:forca_tarefa_id], params["defensor_cpf"])
    respond_to do |format|
      format.html
      format.pdf { render pdf: "relatorio-forca-tarefa",
                          footer: { center: "[page] of [topage]" }
      }
    end
  end

  def get_assistidos
    andamentos = Andamento.joins(:classificacao_andamento)
    filtros = AndamentoForcaTarefa.filtros_methods(params['forca_tarefa_id'],params['data_inicial'],
                                                      params['data_final'],params['defensor_cpf'],params['type'],
                                                                 params['key'])
    @andamentos = andamentos.joins(:audits).where(filtros)

    render :layout => false
  end

  private
    def set_classificacao
      @classificacao = ClassificacaoAndamento.order(:descricao)
    end

    def set_andamento
      @andamento = Andamento.find(params[:id])
    end

    def andamento_params
      params.require(:andamento).permit(:classificacao_andamento_id, :documento_id, :processo_id, :resposta_necessidade,
                                        :resposta, :data_resposta, :data, :data_verificar_resposta, :resultado,
                                        :numero_processual, :forca_tarefa, :observacao, :pa_advogado_particular,
                                        :pa_asistencia_juridica, :pa_defensor_publico, :pa_sem_asistencia,
                                        :at_presencial, :at_analise_processual, :sp_provisiorio, :sp_condenado, :forca_tarefa_id,
                                        :remissao_homologada, :indulto_comutacao, :data_base_progressao, :data_progressao_de_regime,
                                        :data_livramento_condicional, :data_alerta, :defensor_cpf, :operador_cpf,
                                        problemas_identificados:[])
    end

    def get_supplies
      @forca_tarefa = ForcaTarefa.where(ativo: true).order(:nome)
      @sem_providencia_id = return_id_classificacao(ClassificacaoAndamento::DESCRICAO_SEM_PROVIDENCIA)
      @progressao_regime_id = return_id_classificacao(ClassificacaoAndamento::PR_PROGRESSAO_REGIME)
      @livramento_condicional_id = return_id_classificacao(ClassificacaoAndamento::PR_LIVRAMENTO_CONDICIONAL)
      @is_execucao_penal = false
      if params['processo'].present?
        @processo_judicial = ProcessoJudicial.find(params['processo'])
        @is_execucao_penal = @processo_judicial.processo_tipo == ProcessoJudicial::PROCESSO_TIPO_EXECUCAO_PENAL
      end
      @problemas_identificados = Andamento::problemas_identificados
    end

    def return_id_classificacao(value_id)
      id = ''
      classificacao_andamento = ClassificacaoAndamento.find_by_descricao(value_id)
      if classificacao_andamento
        id = classificacao_andamento.id
      end
      id
    end

    def gerar_notificacoes
      if (@andamento.classificacao_andamento and @andamento.classificacao_andamento.descricao == "Relaxamento de Prisão")
        if (@processo.inquerito_policial.present? and @situacao.inquerito_policial.defensor_responsavel.present? and
            validar_data(@situacao.data_prisao + 30))
          notificar_andamento_processo_inquerito(@processo, @situacao, @andamento)
        end
      else
        if (@andamento.data_alerta.present? and @andamento.defensor_cpf.present? and validar_data(@andamento.data_alerta))
          if @situacao.cidade.nil?
            @situacao.cidade = @processo.cidade
          end
          if @situacao.uf.nil?
            @situacao.uf = @processo.estado
          end
          notificar_andamento(@andamento, @situacao)
        end
      end
    end
end
