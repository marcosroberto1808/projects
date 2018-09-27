class InfracoesController < ApplicationController
  before_action :set_infracao, only: [:show, :edit, :update, :destroy]

  # GET /infracoes
  # GET /infracoes.json
  def index
    redirect_to root_url
  end

  # GET /infracoes/1
  # GET /infracoes/1.json
  def show
  end

  # GET /infracoes/new
  def new
    @infracao = Infracao.new
  end

  # GET /infracoes/1/edit
  def edit
  end

  # POST /infracoes
  # POST /infracoes.json
  def create
    @infracao = Infracao.new(infracao_params)

    respond_to do |format|
      if @infracao.save
        format.html { redirect_to @infracao, notice: 'Infracao was successfully created.' }
        format.json { render action: 'show', status: :created, location: @infracao }
      else
        format.html { render action: 'new' }
        format.json { render json: @infracao.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /infracoes/1
  # PATCH/PUT /infracoes/1.json
  def update
    respond_to do |format|
      if @infracao.update(infracao_params)
        format.html { redirect_to @infracao, notice: 'Infracao atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @infracao.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /infracoes/1
  # DELETE /infracoes/1.json
  def destroy
    if @infracao.inquerito_policial.infracao.length == 1
      flash[:alert] = "Deve existir pelo menos uma infração no inquérito."
      redirect_to :back
    else
      @infracao.destroy
      respond_to do |format|
        format.html { redirect_to :back }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_infracao
      @infracao = Infracao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def infracao_params
      params.require(:infracao).permit(:inquerito_policial_id, :descricao_codigo, :descricao_nome)
    end
end
