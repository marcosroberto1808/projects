class CidadesController < ApplicationController
  before_action :set_cidade, only: [:show, :edit, :update, :destroy]

  def index
    @cidades = Cidade.all.order('nome')
  end

  def show
  end

  def new
    @cidade = Cidade.new
  end

  def edit
  end

  def create
    @cidade = Cidade.new(cidade_params)

    respond_to do |format|
      if @cidade.save
        format.html { redirect_to @cidade, notice: 'Cidade foi criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @cidade }
      else
        format.html { render action: 'new' }
        format.json { render json: @cidade.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cidade.update(cidade_params)
        format.html { redirect_to @cidade, notice: 'Cidade foi atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cidade.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @cidade.destroy
        format.html { redirect_to @cidade, notice: 'Cidade foi deletada com sucesso.' }
        format.json { head :no_content }
      else
        @cidades = Cidade.all
        format.html { render action: 'index' }
        format.json { render json: @cidade.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cidade
      @cidade = Cidade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cidade_params
      params.require(:cidade).permit(:nome, :uf)
    end
end