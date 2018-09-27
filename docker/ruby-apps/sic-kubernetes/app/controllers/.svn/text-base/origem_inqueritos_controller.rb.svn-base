class OrigemInqueritosController < ApplicationController
  before_action :set_origem_inquerito, only: [:show, :edit, :update, :destroy]

  def index
    @origem_inqueritos = OrigemInquerito.all
  end

  def show
  end

  def new
    @origem_inquerito = OrigemInquerito.new
  end

  def edit
  end

  def create
    @origem_inquerito = OrigemInquerito.new(origem_inquerito_params)
    @origem_inquerito["uf"] = @origem_inquerito.cidade.uf

    respond_to do |format|
      if @origem_inquerito.save
        format.html { redirect_to @origem_inquerito, notice: 'Origem de Inquerito criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @origem_inquerito }
      else
        format.html { render action: 'new' }
        format.json { render json: @origem_inquerito.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @origem_inquerito.update(origem_inquerito_params)
        format.html { redirect_to @origem_inquerito, notice: 'Origem de Inquerito atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @origem_inquerito.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def destroy
    respond_to do |format|
      if @origem_inquerito.destroy
        format.html { redirect_to origem_inqueritos_url }
        format.json { head :no_content }
      else
        @origem_inqueritos = OrigemInquerito.all
        format.html { render action: 'index' }
        format.json { render json: @origem_inquerito.errors, status: :unprocessable_entity }
      end
    end
  end

  private    
    def set_origem_inquerito
      @origem_inquerito = OrigemInquerito.find(params[:id])
    end
    
    def origem_inquerito_params
      params.require(:origem_inquerito).permit(:uf, :cidade_id, :nome)
    end
end
