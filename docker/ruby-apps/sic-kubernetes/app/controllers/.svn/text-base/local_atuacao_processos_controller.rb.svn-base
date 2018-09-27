class LocalAtuacaoProcessosController < ApplicationController
  before_action :set_local_atuacao_processo, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to root_url
  end

  def show
  end

  def new
    @local_atuacao_processo = LocalAtuacaoProcesso.new
  end

  def edit
  end

  def create
    @local_atuacao_processo = LocalAtuacaoProcesso.new(local_atuacao_processo_params)

    respond_to do |format|
      if @local_atuacao_processo.save
        format.html { redirect_to @local_atuacao_processo, notice: 'Local atuacao processo was successfully created.' }
        format.json { render action: 'show', status: :created, location: @local_atuacao_processo }
      else
        format.html { render action: 'new' }
        format.json { render json: @local_atuacao_processo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @local_atuacao_processo.update(local_atuacao_processo_params)
        format.html { redirect_to @local_atuacao_processo, notice: 'Local atuacao processo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @local_atuacao_processo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @local_atuacao_processo.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local_atuacao_processo
      @local_atuacao_processo = LocalAtuacaoProcesso.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_atuacao_processo_params
      params.require(:local_atuacao_processo).permit(:processo_judicial_id)
    end
end
