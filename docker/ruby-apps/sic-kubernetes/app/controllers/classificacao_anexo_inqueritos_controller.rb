class ClassificacaoAnexoInqueritosController < ApplicationController
  before_action :set_classificacao_anexo_inquerito, only: [:show, :edit, :update, :destroy]

  # GET /classificacao_anexo_inqueritos
  # GET /classificacao_anexo_inqueritos.json
  def index
    @classificacao_anexo_inqueritos = ClassificacaoAnexoInquerito.all
  end

  # GET /classificacao_anexo_inqueritos/1
  # GET /classificacao_anexo_inqueritos/1.json
  def show
  end

  # GET /classificacao_anexo_inqueritos/new
  def new
    @classificacao_anexo_inquerito = ClassificacaoAnexoInquerito.new
  end

  # GET /classificacao_anexo_inqueritos/1/edit
  def edit
  end

  # POST /classificacao_anexo_inqueritos
  # POST /classificacao_anexo_inqueritos.json
  def create
    @classificacao_anexo_inquerito = ClassificacaoAnexoInquerito.new(classificacao_anexo_inquerito_params)

    respond_to do |format|
      if @classificacao_anexo_inquerito.save
        format.html { redirect_to @classificacao_anexo_inquerito, notice: 'Classificação de Anexo de Inquerito criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @classificacao_anexo_inquerito }
      else
        format.html { render action: 'new' }
        format.json { render json: @classificacao_anexo_inquerito.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /classificacao_anexo_inqueritos/1
  # PATCH/PUT /classificacao_anexo_inqueritos/1.json
  def update
    respond_to do |format|
      if @classificacao_anexo_inquerito.update(classificacao_anexo_inquerito_params)
        format.html { redirect_to @classificacao_anexo_inquerito, notice: 'Classificação de Anexo de Inquerito atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @classificacao_anexo_inquerito.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /classificacao_anexo_inqueritos/1
  # DELETE /classificacao_anexo_inqueritos/1.json
  def destroy
    @classificacao_anexo_inquerito.destroy
    respond_to do |format|
      format.html { redirect_to classificacao_anexo_inqueritos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classificacao_anexo_inquerito
      @classificacao_anexo_inquerito = ClassificacaoAnexoInquerito.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classificacao_anexo_inquerito_params
      params.require(:classificacao_anexo_inquerito).permit(:descricao)
    end
end
