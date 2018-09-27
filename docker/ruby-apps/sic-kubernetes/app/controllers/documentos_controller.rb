class DocumentosController < ApplicationController
  before_action :set_documento, only: [:show, :edit, :update, :destroy]
  require 'fileutils'

  def index
    redirect_to root_url
  end

  def show
  end

  def new
    @documento = Documento.new
    @assistido = Assistido.find(session["assistido_selecionado"])
    @classificacao_documento = ClassificacaoDocumento.where(tipo_documento_id: params["tipo"])
  end

  def edit
  end

  def create
    @documento = Documento.new(documento_params)
    arquivo = @documento["nome_url"]
    @tipo = params["tipo_documento"].to_i

    if arquivo
      @documento["nome_url"] = arquivo.original_filename
    end
    @documento["assistido_id"] = session["assistido_selecionado"]
    @arquivo_path = ""
    @dir_path = ""

    if @tipo == TipoDocumento::PESSOAL_ID
      @arquivo_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/pessoais/#{@documento["nome_url"]}"
      @dir_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/pessoais/"    
    elsif @tipo == TipoDocumento::EXTRAJUDICIAL_ID
      @arquivo_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/extrajudiciais/#{@documento["nome_url"]}"
      @dir_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/extrajudiciais/"      
    elsif @tipo == TipoDocumento::PROCESSO_ID
      @arquivo_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/processos/#{@documento["processo_judicial_id"]}/#{@documento["nome_url"]}"
      @dir_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/processos/#{@documento["processo_judicial_id"]}/"
    elsif @tipo == TipoDocumento::INQUERITO_ID
      @arquivo_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/inqueritos/#{@documento["inquerito_policial_id"]}/#{@documento["nome_url"]}"
      @dir_path = "#{PATH_DOCS_SIC}/documentos/#{session["assistido_selecionado"]}/inqueritos/#{@documento["inquerito_policial_id"]}/"      
    else
      #Literalmente Nada!
    end

    if !@arquivo_path.present? and !@dir_path.present?
      @assistido = Assistido.find(session["assistido_selecionado"])
      return redirect_to assistido_path(@assistido)
    end

    respond_to do |format|
      if validate_document(arquivo)
        begin
          #Checa se o diretorio existe, caso não ele cria;
          FileUtils.mkdir_p(@dir_path) unless File.directory?(@dir_path)
          #Salva o arquivo no diretorio
          File.open(@arquivo_path, 'wb') do |file|
            file.write(arquivo.read)
          end
        rescue
          format.html { redirect_to "/documentos/new?tipo=#{@tipo}", alert: 'Ocorreu um erro ao salvar o arquivo' }
        end
        if @documento.save
          @path = ""
          if @tipo == TipoDocumento::PROCESSO_ID
            @path = @documento.processo_judicial
          elsif @tipo == TipoDocumento::INQUERITO_ID
            @path = @documento.inquerito_policial
          else
            #literalmente nada
          end

          #O redirect de sucesso é diferente para os casos (Processo/Inquerito) e (Pessoal/Extrajudicial)
          if (@documento.processo_judicial_id == nil and @documento.inquerito_policial_id == nil)
            format.html { redirect_to "/assistidos/#{session["assistido_selecionado"]}", notice: 'Documento adicionado com sucesso.' }
          else
            format.html { redirect_to @path, notice: 'Documento adicionado com sucesso.' }
          end
        else
          @assistido = Assistido.find(session["assistido_selecionado"])
          #Os laçoes abaixo retornam com a informação de erro para diferentes URLs baseado no tipo de documento que ta criado(processo, inquerito, pessoal, extrajudicial);
          if @documento.inquerito_policial_id != nil
            format.html { redirect_to "/documentos/new?tipo=#{@tipo}&inquerito=#{@documento["inquerito_policial_id"]}", alert: 'Data Ato, Classificação e Arquivo são obrigatórios.' }
          end

          if @documento.processo_judicial_id != nil
            format.html { redirect_to "/documentos/new?tipo=#{@tipo}&processo=#{@documento["processo_judicial_id"]}", alert: 'Data Ato, Classificação e Arquivo são obrigatórios.' }
          end

          if (@documento.processo_judicial_id == nil and @documento.inquerito_policial_id == nil)
            format.html { redirect_to "/documentos/new?tipo=#{@tipo}", alert: 'Data Ato, Classificação e Arquivo são obrigatórios.' }
          end
        end
      else
        format.html { redirect_to "/documentos/new?tipo=#{@tipo}", alert: 'Deve ser informado um arquivodo tipo PDF e o mesmo tem que possuir um tamanho menor ou igual a 10MB.' }
      end
    end
  end

  def validate_document(arquivo)
    arquivo.present? and (arquivo.size().to_f / 2**20).round(2) <= 10 and arquivo.content_type == "application/pdf"
  end

  def update
    respond_to do |format|
      if @documento.update(documento_params)
        format.html { redirect_to @documento, notice: 'Documento was successfully updated.' }
        format.json { head :no_content }
      else
        @assistido = Assistido.find(session["assistido_selecionado"])        
        format.html { render action: 'edit' }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @documento.destroy

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Documento deletado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def documento_params
      params.require(:documento).permit(:tipo_documento_id, :assistido_id, :inquerito_policial_id, :processo_judicial_id, :data, :nome_url, :resposta_necessidade, :resposta, :classificacao_documento_id, :numero_processual)
    end
end
