class NotificacoesController < ApplicationController
  before_action :set_notificacao, only: [:show, :edit, :update, :destroy]

  def index
    @notificacoes = Notificacao.where(notificado: get_cpf).order("data asc")
    @tipos = ["Todos", "Automático", "Agendado"]
    @status = [["Todos", "Todos"], ["Não Alertado", false], ["Já Alertado", true]]
  end

  def show
    @notificacao = Notificacao.find_by_id(params["id"])
    @notificacao.update(visto: true)
  end

  def new
    @notificacao = Notificacao.new
  end

  def pesquisar
    @notificacoes = Notificacao.where(notificado: get_cpf)

    if (params["data_ini"] != "") or (params["data_fim"] != "")
      if (params["data_ini"] != "") and (params["data_fim"] != "")
        @notificacoes = @notificacoes.where("data >= ? and data <= ?",params["data_ini"], params["data_fim"])
      end

      if (params["data_ini"] != "")
        @notificacoes = @notificacoes.where("data >= ?",params["data_ini"])        
      end

      if (params["data_fim"] != "")
        @notificacoes = @notificacoes.where("data <= ?",params["data_fim"])                
      end
    end

    if params["assistido"] != ""
      @assistido = Assistido.find_by_nome(params["assistido"]) 
      if @assistido != nil 
        @notificacoes = @notificacoes.where(assistido_id: @assistido.id)
      else
        @notificacoes = @notificacoes.where(assistido_id: 0)
      end
    end

    if params["descricao"] != ""
      @notificacoes = @notificacoes.where("descricao ilike ?", "%#{params["descricao"]}%")
    end

    if params["tipo"] != "Todos"
      @notificacoes = @notificacoes.where(tipo: params["tipo"])
    end

    if params["status"] != "Todos"
      @notificacoes = @notificacoes.where(visto: params["status"])
    end 

    respond_to do |format|
      format.js
    end    
  end

  def create
    @notificacao = Notificacao.new(notificacao_params)
    @assistido_valido = true
    if params["assistido_notificacao"].present?
      #remove o nome da mãe da string
      @preso = params["assistido_notificacao"].split(" - Mãe:")[0]
      @assistido = Assistido.find_by_nome(@preso)
      if @assistido.present?
        @notificacao["assistido_id"] = @assistido.id
      else
        @assistido_valido = false                  
      end
    end

    respond_to do |format|
      if @notificacao.save

        format.html { redirect_to "/notificacoes", notice: 'Notificação criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @notificacao }
      else
        if !@assistido_valido
          @notificacao.errors.add(:base, "Assistido inválido.")
        end

        format.html { render action: 'new' }
        format.json { render json: @notificacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notificacao.destroy
    respond_to do |format|
      format.html { redirect_to notificacoes_url }
      format.json { head :no_content }
    end
  end

  private
    def set_notificacao
      @notificacao = Notificacao.find(params[:id])
    end

    def notificacao_params
      params.require(:notificacao).permit(:assistido_id, :preso, :instituicao, :cidade, :uf, :data, :descricao, :tipo, :notificado, :visto)
    end
end
