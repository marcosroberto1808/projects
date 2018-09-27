class TipoDocumentosController < ApplicationController
  before_action :set_tipo_documento, only: [:show, :edit, :update, :destroy]

  # GET /tipo_documentos
  # GET /tipo_documentos.json
  def index
    redirect_to root_url
  end

  # GET /tipo_documentos/1
  # GET /tipo_documentos/1.json
  def show
  end

  # GET /tipo_documentos/new
  def new
    @tipo_documento = TipoDocumento.new
  end

  # GET /tipo_documentos/1/edit
  def edit
  end

  # POST /tipo_documentos
  # POST /tipo_documentos.json
  def create
    @tipo_documento = TipoDocumento.new(tipo_documento_params)

    respond_to do |format|
      if @tipo_documento.save
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully created.' }
        format.json { render action: 'show', status: :created, location: @tipo_documento }
      else
        format.html { render action: 'new' }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_documentos/1
  # PATCH/PUT /tipo_documentos/1.json
  def update
    respond_to do |format|
      if @tipo_documento.update(tipo_documento_params)
        format.html { redirect_to @tipo_documento, notice: 'Tipo documento was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tipo_documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_documentos/1
  # DELETE /tipo_documentos/1.json
  def destroy
    @tipo_documento.destroy
    respond_to do |format|
      format.html { redirect_to tipo_documentos_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_documento
      @tipo_documento = TipoDocumento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tipo_documento_params
      params.require(:tipo_documento).permit(:descricao)
    end
end
