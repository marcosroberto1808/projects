class ClassificacaoDocumentosController < ApplicationController
  before_action :set_classificacao_documento, only: [:show, :edit, :update, :destroy]
  before_action :set_tipo_documentos

  def index
    @classificacao_documentos = ClassificacaoDocumento.where("tipo_documento_id <> ?", 3)
  end

  def show
  end

  def new
    @classificacao_documento = ClassificacaoDocumento.new
  end

  def edit
  end

  def create
    @classificacao_documento = ClassificacaoDocumento.new(classificacao_documento_params)

    respond_to do |format|
      if @classificacao_documento.save
        format.html { redirect_to @classificacao_documento, notice: 'Classificação de Anexo de Processo criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @classificacao_documento }
      else
        format.html { render action: 'new' }
        format.json { render json: @classificacao_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @classificacao_documento.update(classificacao_documento_params)
        format.html { redirect_to @classificacao_documento, notice: 'Classificação de Anexo de Processo atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @classificacao_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @classificacao_documento.destroy
    respond_to do |format|
      format.html { redirect_to classificacao_documentos_url }
      format.json { head :no_content }
    end
  end

  private
    def set_tipo_documentos
      @tipos_documentos = TipoDocumento.where("descricao <> ?", "Processo")      
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_classificacao_documento
      @classificacao_documento = ClassificacaoDocumento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classificacao_documento_params
      params.require(:classificacao_documento).permit(:descricao, :tipo_documento_id)
    end
end
