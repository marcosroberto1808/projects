class AssinaturaVirtuaisController < ApplicationController
  before_action :set_assinatura_virtual, only: [:show, :edit, :update, :destroy]

  require 'fileutils'

  def index
    redirect_to root_url
  end

  def new
    @assinatura_virtual = AssinaturaVirtual.new
    @assinatura = AssinaturaVirtual.find_by_usuario_id(get_cpf)
  end

  def create
    @assinatura_virtual = AssinaturaVirtual.new(assinatura_virtual_params)
    arquivo = params["assinatura_virtual"]["url"]
    @assinatura_virtual["usuario_id"] = get_cpf
    
    if arquivo.present?
      @assinatura_virtual["url"] = arquivo.original_filename
      @arquivo_path = "#{Rails.root}/app/assets/images/signatures/#{@assinatura_virtual["usuario_id"]}/#{@assinatura_virtual["url"]}"
      @dir_path = "#{Rails.root}/app/assets/images/signatures/#{@assinatura_virtual["usuario_id"]}/"
    end

    respond_to do |format|
      if @assinatura_virtual.save and arquivo.present?
        #Checa se o diretorio existe, caso não ele cria;
        FileUtils.mkdir_p(@dir_path) unless File.directory?(@dir_path)
        #Salva o arquivo no diretorio
        File.open(@arquivo_path, 'wb') do |file|
          file.write(arquivo.read)
        end

        format.html { redirect_to "/assinatura_virtuais/new", notice: 'Assinatura Virtual criado com sucesso.' }
      else
        format.html { render action: 'new' }
        format.json { render json: @assinatura_virtual.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assinatura_virtual.destroy
    respond_to do |format|
      format.html { redirect_to "/assinatura_virtuais/new", notice: 'Assinatura Virtual removida com sucesso.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assinatura_virtual
      @assinatura_virtual = AssinaturaVirtual.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assinatura_virtual_params
      params.require(:assinatura_virtual).permit(:assistido_id, :url)
    end
end