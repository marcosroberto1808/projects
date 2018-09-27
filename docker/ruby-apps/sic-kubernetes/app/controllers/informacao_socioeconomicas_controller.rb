class InformacaoSocioeconomicasController < ApplicationController
  before_action :set_informacao_socioeconomica, only: [:show, :edit, :update, :destroy]

  # GET /informacao_socioeconomicas
  # GET /informacao_socioeconomicas.json
  def index
    redirect_to root_url
  end

  # GET /informacao_socioeconomicas/1
  # GET /informacao_socioeconomicas/1.json
  def show
  end

  # GET /informacao_socioeconomicas/new
  def new
    @informacao_socioeconomica = InformacaoSocioeconomica.new
  end

  # GET /informacao_socioeconomicas/1/edit
  def edit
  end

  # POST /informacao_socioeconomicas
  # POST /informacao_socioeconomicas.json
  def create
    @informacao_socioeconomica = InformacaoSocioeconomica.new(informacao_socioeconomica_params)

    respond_to do |format|
      if @informacao_socioeconomica.save
        format.html { redirect_to @informacao_socioeconomica, notice: 'Informacao socioeconomica was successfully created.' }
        format.json { render action: 'show', status: :created, location: @informacao_socioeconomica }
      else
        format.html { render action: 'new' }
        format.json { render json: @informacao_socioeconomica.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /informacao_socioeconomicas/1
  # PATCH/PUT /informacao_socioeconomicas/1.json
  def update
    respond_to do |format|
      if @informacao_socioeconomica.update(informacao_socioeconomica_params)
        format.html { redirect_to @informacao_socioeconomica, notice: 'Informacao socioeconomica was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @informacao_socioeconomica.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /informacao_socioeconomicas/1
  # DELETE /informacao_socioeconomicas/1.json
  def destroy
    @informacao_socioeconomica.destroy
    respond_to do |format|
      format.html { redirect_to informacao_socioeconomicas_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_informacao_socioeconomica
      @informacao_socioeconomica = InformacaoSocioeconomica.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def informacao_socioeconomica_params
      params.require(:informacao_socioeconomica).permit(:assistido_id, :nivel_escolaridade, :usa_drogas, :aceita_tratamento, :problema_sauda, :incluido_atividade_presidio, :trabalhava_antes_prisao, :renda_familiar)
    end
end
