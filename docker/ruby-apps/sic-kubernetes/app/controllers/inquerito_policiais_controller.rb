class InqueritoPoliciaisController < ApplicationController
  before_action :set_inquerito_policial, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to root_url
  end

  def show
  end

  def new
    @assistido = Assistido.find(session["assistido_selecionado"])
    @inquerito_policial = InqueritoPolicial.new
    @inquerito_policial["cidade"] = "Fortaleza"
    @inquerito_policial["uf"] = "CE"
  end

  def edit
    @assistido = Assistido.find(session["assistido_selecionado"])
    @inquerito_policial["numero_anexo"] = @inquerito_policial["numero_anexo"].split("/")[0]
  end

  def add_infracao_new
    @infracao = Infracao.new
    respond_to do |format|
      @infracao["descricao_codigo"] = params["infracao_codigo"]
      @infracao["descricao_nome"] = params["infracao_nome"]
      format.js
    end
  end

  def add_infracao_edit
    @infracao = Infracao.new
    respond_to do |format|
      @infracao["descricao_codigo"] = params["infracao_codigo"]
      @infracao["descricao_nome"] = params["infracao_nome"]
      format.js
    end
  end

  def create
    @inquerito_policial = InqueritoPolicial.new(inquerito_policial_params)
    @inquerito_policial["assistido_id"] = session["assistido_selecionado"]
    @inquerito_policial["numero_anexo"] = @inquerito_policial["numero_anexo"]+"/"+Date.today.year.to_s

    if params["inquerito_policial"]["origem_inquerito_id"].present?
      @origem = OrigemInquerito.find(params["inquerito_policial"]["origem_inquerito_id"])
      @inquerito_policial["cidade"] = @origem.cidade.nome
      @inquerito_policial["uf"] = @origem["uf"]
    end

    @erro_infrao = false
    if params["infracoes"] == nil or params["infracoes"].length == 0
      @erro_infrao = true
    end

    respond_to do |format|
      if @inquerito_policial.save and @erro_infrao == false
        if params["infracoes"]
          params["infracoes"].each do |infracao|
            infracao = infracao.split("|")
            @infracao = Infracao.new
            @infracao["inquerito_policial_id"] = @inquerito_policial["id"]
            @infracao["descricao_codigo"] = infracao[0]
            @infracao["descricao_nome"] = infracao[1]
            @infracao.save
          end
        end
        format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}", notice: 'Inquerito Policial criado com sucesso.' }
      else
        if @erro_infrao
          @inquerito_policial.errors.add(:base, "Pelo menos uma infração precisar ser adicionada ao inquerito.")
        end
        @assistido = Assistido.find(session["assistido_selecionado"])
        format.html { render action: 'new' }
        format.json { render json: @inquerito_policial.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    params[:inquerito_policial][:numero_anexo] = params["inquerito_policial"]["numero_anexo"]+"/"+Date.today.year.to_s

    if params["inquerito_policial"]["origem_inquerito_id"].present?
      @origem = OrigemInquerito.find(params["inquerito_policial"]["origem_inquerito_id"])
      params[:inquerito_policial][:cidade] = @origem.cidade.nome
      params[:inquerito_policial][:uf] = @origem["uf"]
    end

    respond_to do |format|
      if @inquerito_policial.update(inquerito_policial_params)
        if params["infracoes"]
          params["infracoes"].each do |infracao|
            infracao = infracao.split("|")
            @infracao = Infracao.new
            @infracao["inquerito_policial_id"] = @inquerito_policial["id"]
            @infracao["descricao_codigo"] = infracao[0]
            @infracao["descricao_nome"] = infracao[1]
            @infracao.save
          end
        end
        format.html { redirect_to @inquerito_policial, notice: 'Inquerito Policial editado com sucesso.' }
        format.json { head :no_content }

      else
        @assistido = Assistido.find(session["assistido_selecionado"])
        format.html { render action: 'edit' }
        format.json { render json: @inquerito_policial.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    # @inquerito_policial.destroy
    respond_to do |format|
      format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}" }
      format.json { head :no_content }
    end
  end

  private
    def set_inquerito_policial
      @inquerito_policial = InqueritoPolicial.find(params[:id])
    end

    def inquerito_policial_params
      params.require(:inquerito_policial).permit(:assistido_id, :origem_inquerito_id, :cidade, :uf, :infracao_logradouro, :infracao_numero, :infracao_complemento, :infracao_bairro, :infracao_cep, :data_abertura, :observacao, :instauracao, :data_crime, :latitude, :longitude, :cep, :numero, :defensor_responsavel, :numero_anexo, :cidade_crime)
    end
end
