class SituacoesController < ApplicationController
  before_action :set_situacao, only: [:show, :edit, :update, :destroy]

  def index
    @situacoes = Situacao.all
  end

  def show
  end

  def new
    @situacao = Situacao.new
  end

  def edit
  end

  def create
    @situacao = Situacao.new(situacao_params)

    respond_to do |format|
      if @situacao.save
        format.html { redirect_to @situacao, notice: 'Situacao was successfully created.' }
        format.json { render action: 'show', status: :created, location: @situacao }
      else
        format.html { render action: 'new' }
        format.json { render json: @situacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @situacao.update(situacao_params)
        format.html { redirect_to @situacao, notice: 'Situacao was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @situacao.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @situacao.destroy
    respond_to do |format|
      format.html { redirect_to situacoes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_situacao
      @situacao = Situacao.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def situacao_params
      params.require(:situacao).permit(:preso, :instituicao, :cidade, :uf, :data_prisao, :motivo, :assistido_id, :inquerito_policial_id)
    end
end
