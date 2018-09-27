class AssistidosController < ApplicationController
  before_action :set_assistido, only: [:show, :edit, :update, :destroy]
  include NotificacoesHelper

  def index
    redirect_to root_url
  end

  def show
    session["assistido_selecionado"] = @assistido.id
    @situacao = @assistido.situacao.last
    @socioe = InformacaoSocioeconomica.find_by_assistido_id(@assistido.id)
    #raise Documento.first.classificacao_documento.inspect
    @documentos_pessoais = Documento.joins(:classificacao_documento)
                                    .where('classificacao_documentos.tipo_documento_id' => TipoDocumento::PESSOAL_ID,
                                           assistido_id: @assistido.id)
    @documentos_extrajudiciais = Documento.joins(:classificacao_documento)
                                     .where('classificacao_documentos.tipo_documento_id' => TipoDocumento::EXTRAJUDICIAL_ID,
                                           assistido_id: @assistido.id)
    @cidade = Cidade.find_by_nome(@assistido["cidade"])
    @cidade = @cidade.id if @cidade.present?
  end

  def download
    documento = Documento.find(params["documento"])
    path_file = documento.get_path

    if path_file
      send_file path_file
    else
      raise "Tipo de Arquivo Inexistente"
    end
  end

  def new
    @assistido = Assistido.new
    @cidades = Cidade.where(uf: "CE")
    @uf = Cidade.find_by_nome("Fortaleza").id if Cidade.find_by_nome("Fortaleza").present?
  end

  def update_resumo
    @assistido = Assistido.find(params["assistido_id"])
    respond_to do |format|
      @assistido.update_attributes(:resumo => params["resumo"])
      format.js
    end
  end

  def update_dados_pessoais
    @cidade_nome = ''
    @uf_sigla = ''
    if params["cidade"].present?
      @cidade = Cidade.find(params["cidade"])
      params["cidade"] = @cidade.nome
      params["uf"] = @cidade.uf
      @cidade_nome = @cidade.nome
      @uf_sigla = @cidade.uf
    end
    def assistido_params
      params.permit(:nome, :sexo, :profissao, :data_nascimento, :nome_mae, :nome_pai, :cpf, :rg,
                            :orgao_emissor, :estado_civil, :nacionalidade, :cep, :logradouro, :numero, :complemento,
                            :bairro, :contato_nome, :contato_tipo_vinculo, :contato_telefone,
                            :contato_email, :nome, :telefone, :telefone_dois, :telefone_tres, :historico_delito_atual,
                            :antecedentes_criminais, :pretensoes_futuras,
                    :observacoes_complementares).merge(cidade: @cidade_nome, uf: @uf_sigla)
    end
    @erro_update_dados_pessoais = true

    respond_to do |format|
      @assistido = Assistido.find(params["assistido_id"])
      if @assistido.update(assistido_params)
        format.js
      else
        @erros = ""
        @erros += "<p>O campo 'Nome' é obrigatório.</p>"
        @erros += "<p>O campo 'Nome Mãe' é obrigatório.</p>"
        @erro_update_dados_pessoais = false
        format.js
      end
    end
  end

  def update_situacao
    @situacao = Situacao.new(:situacao_estado => params["situacao"], :cidade => params["cidade"], :uf => params["uf"],
                             :instituicao => params["instituicao"], :assistido_id => session["assistido_selecionado"],
                             :data_prisao => params["data_prisao"], :inquerito_policial_id => params["inquerito"])
    @erro_update_situacao = false
    if params["data_prisao"] != ""
      if params["data_prisao"].length < 10
        @erro_update_situacao = true
      else
        begin
          Date.parse(params["data_prisao"])
        rescue
          @erro_update_situacao = true
        end
      end
    end

    respond_to do |format|
      if @erro_update_situacao == false and @situacao.save
        if @situacao["situacao_estado"] == "Preso" and params["notificar"].present?
          #caso o status seja definido para preso, criará uma notificação para 90 dias;
          @notificacao = notificar_assistido(@situacao)
          #deleta a antiga notificação caso exista, só pode haver uma
          deleta_notificacao_refeita(@situacao.assistido.id)
        else
          #deleta o antigo evento e notificacções caso exista, só pode ahver um
          deleta_notificacao_refeita(@situacao.assistido.id)
        end

        format.js
      else
        format.js
      end
    end
  end

  def update_socioeconomicas
    @socioe = InformacaoSocioeconomica.find(params["socioe_id"])
    #setando valor default para caso o checkbo não seja marcado(o que geral um parametro inexistente)
    @socioe["usa_drogas"] = false
    @socioe["aceita_tratamento"] = false
    @socioe["problema_sauda"] = false
    @socioe["incluido_atividade_presidio"] = false
    @socioe["trabalhava_antes_prisao"] = false
    @socioe["nivel_escolaridade"] = params["escolaridade"]
    @socioe["usa_drogas"] = params["drogas"] if params["drogas"] == "true"
    @socioe["usa_drogas_descricao"] = (params["drogas"] ? params["drogas_descricao"] : nil)
    @socioe["aceita_tratamento"] = params["tratamento"] if params["tratamento"] == "true"
    @socioe["aceita_tratamento_descricao"] = (params["tratamento"] ? params["tratamento_descricao"] : nil)
    @socioe["problema_sauda"] = params["saude"] if params["saude"] == "true"
    @socioe["problema_sauda_descricao"] = (params["saude"] ? params["saude_descricao"] : nil)
    @socioe["incluido_atividade_presidio"] = params["atividades"] if params["atividades"] == "true"
    @socioe["incluido_atividade_presidio_descricao"] = (params["atividades"] ? params["atividades_descricao"] : nil)
    @socioe["trabalhava_antes_prisao"] = params["empregado"] if params["empregado"] == "true"
    @socioe["trabalhava_antes_prisao_descricao"] = (params["empregado"] ? params["empregado_descricao"] : nil)
    @socioe["renda_familiar"] = params["renda"]

    respond_to do |format|
      if @socioe.save
        format.js
      else
        format.js
      end
    end
  end

  def sincronizar
    @assistido = Assistido.find(params['assistido'])
    auth = {username: API_SEJUS_USERNAME, password: API_SEJUS_PASSWORD}
    seq_pessoa = nil
    if @assistido.present?
      if @assistido.id_importacao_sejus.present?
        seq_pessoa = @assistido.id_importacao_sejus
      else
        nome = URI.encode(@assistido.nome)

        url = API_SEJUS + "nome/#{nome}"
        response = HTTParty.get(url, basic_auth: auth)

        if response.parsed_response.present?
          seq_pessoa = response.parsed_response.first['seq_pessoa']
          @assistido.id_importacao_sejus = seq_pessoa
        end
      end

      if seq_pessoa.present?
        url = API_SEJUS + "#{seq_pessoa}"
        response = HTTParty.get(url, basic_auth: auth)
        if response.parsed_response.present?
          @assistido.sincronizar(response.parsed_response.first)
        end
      end
    end
    redirect_to :back
  end

  def pesquisar_assistidos
    @assistidos_encontrados = Array.new
    #checa se é uma pesquisafjson avançada
    if params["busca_avancada"]
      @pesquisa_avancada = true
    end

    #Checa se o usuário manteve o campo de busca sem ser utilizado e zera
    if params["busca_assistido"] == "Procurar Assistido"
      params["busca_assistido"] = nil
    end

    #enhancement_ilike
    nome_search = enhancement_ilike('nome', params["busca_assistido"])
    busca_assistido_search = enhancement_ilike('nome', params["busca_nome"])
    nome_social_search = enhancement_ilike('nome_social', params["busca_nome_social"])
    nome_mae_search = enhancement_ilike('nome_mae', params["busca_nome_mae"])
    nome_pai_search = enhancement_ilike('nome_pai', params["busca_nome_pai"])
    profissao_search = enhancement_ilike('profissao', params["busca_profissao"])
    cidade_search = enhancement_ilike('cidade', params["busca_cidade"])
    logradouro_search = enhancement_ilike('logradouro', params["busca_logradouro"])
    bairro_search = enhancement_ilike('bairro', params["busca_bairro"])
    complemento_search = enhancement_ilike('complemento', params["busca_complemento"])

    if params["busca_assistido"]
      @assistidos_encontrados = Assistido.where(nome_search)
    elsif not params["busca_nome"].nil? || params["busca_nome"].empty?
      @assistidos_encontrados = Assistido.where(busca_assistido_search)
    elsif not params["busca_processo"].nil? || params["busca_processo"].empty?
      @assistidos_encontrados = Assistido.joins(:processo_judicial).where(:processo_judiciais => {numero: params["busca_processo"]})
    else
      @assistidos_encontrados = Assistido.all
    end

    if params["busca_nome_social"] and !params["busca_nome_social"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(nome_social_search)
    end

    if params["busca_sexo"]
      @assistidos_encontrados = @assistidos_encontrados.where(sexo: params["busca_sexo"])
    end

    if params["busca_nome_mae"] and !params["busca_nome_mae"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(nome_mae_search)
    end

    if params["busca_nome_pai"] and !params["busca_nome_pai"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(nome_pai_search)
    end

    if params["busca_profissao"] and !params["busca_profissao"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(profissao_search)
    end

    if params["busca_cep"] and !params["busca_cep"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where("cep ilike '%#{params["busca_cep"]}%'")
    end

    #Validação Datas
    begin
      if params["busca_data_nascimento_inicio"] != "" and params["busca_data_nascimento_inicio"] != nil
        Date.parse(params["busca_data_nascimento_inicio"])
        if params["busca_data_nascimento_inicio"].length < 10 and params["busca_data_nascimento_inicio"].length > 0
          raise "erro"
        end
      end
      if params["busca_data_nascimento_fim"] != "" and params["busca_data_nascimento_inicio"] != nil
        Date.parse(params["busca_data_nascimento_fim"])
        if params["busca_data_nascimento_fim"].length < 10 and params["busca_data_nascimento_fim"].length > 0
          raise "erro"
        end
      end
    rescue
      flash[:alert] = "Data(s) usada(s) na pesquisa avançada, invalida(s)."
      redirect_to :back
    end

    if params["busca_data_nascimento_inicio"] != ""
      @data_inicio = params["busca_data_nascimento_inicio"]
    else
      @data_inicio = "01/01/1900"
    end

    if params["busca_data_nascimento_fim"] != ""
      @data_fim = params["busca_data_nascimento_fim"]
    else
      @data_fim = "01/01/2900"
    end

    if params["busca_cidade"] and !params["busca_cidade"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(cidade_search)
    end

    if params["busca_uf"] and !params["busca_uf"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(uf: params["busca_uf"])
    end

    if params["busca_logradouro"] and !params["busca_logradouro"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(logradouro_search)
    end

    if params["busca_numero"] and !params["busca_numero"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where("numero ilike '%#{params["busca_numero"]}%'")
    end

    if params["busca_bairro"] and !params["busca_bairro"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(bairro_search)
    end

    if params["busca_complemento"] and !params["busca_complemento"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where(complemento_search)
    end

    if params["busca_telefone"] and !params["busca_telefone"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where("telefone ilike '%#{params["busca_telefone"]}%'")
    end

    if params["busca_observacao"] and !params["busca_observacao"].empty?
      @assistidos_encontrados = @assistidos_encontrados.where("observacao ilike '%#{params["busca_observacao"]}%'")
    end

    @assistidos_encontrados = @assistidos_encontrados.where(ativo: true)

    @assistidos_encontrados = @assistidos_encontrados.paginate(:page => params[:page], :per_page => 10).order("nome asc")
  end

  def create
    @assistido = Assistido.new(assistido_params)
    #preencher cidade e UF
    if params["assistido"]["cidade"].present?
      @cidade = Cidade.find(params["assistido"]["cidade"])
      @assistido["cidade"] = @cidade.nome
      @assistido["uf"] = @cidade.uf
    end

    #Validação Datas
    begin
      if params["assistido"]["data_nascimento"] != "" and params["assistido"]["data_nascimento"] != nil
        Date.parse(params["assistido"]["data_nascimento"])
        if params["assistido"]["data_nascimento"].length < 10 and params["assistido"]["data_nascimento"].length > 0
          raise "erro"
        end
      end
    rescue
      flash[:alert] = "Data(s) usada(s) na pesquisa avançada, invalida(s)."
      redirect_to :back
    end

    respond_to do |format|
      if @assistido.save
        @situacao = Situacao.new
        @situacao["situacao_estado"] = "Não Informado"
        @situacao["assistido_id"] = @assistido.id
        @situacao.save
        @informacoes_socioeconomicas = generate_inforacoes_socioeconomicas(@assistido.id)

        if @informacoes_socioeconomicas.save
          format.html { redirect_to @assistido, notice: 'O Perfil foi cadastrado com sucesso.' }
          format.json { render action: 'show', status: :created, location: @assistido }
        else
          # @assistido.destroy
          format.html { render action: 'new' }
          format.json { render json: @informacoes_socioeconomicas.errors, status: :unprocessable_entity }
        end
      else
        if params["assistido"]["cidade"].present?
          @cidade = Cidade.find_by_nome(@assistido["cidade"]).id
        end

        format.html { render action: 'new' }
        format.json { render json: @assistido.errors, status: :unprocessable_entity }
      end
    end
  end

  def generate_inforacoes_socioeconomicas(assistido_id)
    informacoes_socioeconomicas = InformacaoSocioeconomica.new
    informacoes_socioeconomicas.assistido_id = assistido_id
    informacoes_socioeconomicas.nivel_escolaridade = params[:escolaridade]
    informacoes_socioeconomicas.usa_drogas = params[:drogas]
    informacoes_socioeconomicas.aceita_tratamento = params[:tratamento]
    informacoes_socioeconomicas.problema_sauda = params[:saude]
    informacoes_socioeconomicas.incluido_atividade_presidio = params[:atividades]
    informacoes_socioeconomicas.trabalhava_antes_prisao = params[:empregado]
    informacoes_socioeconomicas.renda_familiar = params[:renda]
    informacoes_socioeconomicas.usa_drogas_descricao = params[:drogas_descricao] if (params[:drogas])
    informacoes_socioeconomicas.aceita_tratamento_descricao = params[:tratamento_descricao] if (params[:tratamento])
    informacoes_socioeconomicas.problema_sauda_descricao = params[:saude_descricao] if (params[:saude])
    informacoes_socioeconomicas.incluido_atividade_presidio_descricao = params[:atividades_descricao] if (params[:atividades])
    informacoes_socioeconomicas.trabalhava_antes_prisao_descricao = params[:empregado_descricao] if (params[:empregado])
    return informacoes_socioeconomicas
  end

  def update
    respond_to do |format|
      if @assistido.update(assistido_params)
        format.html { redirect_to @assistido, notice: 'O Assistido foi editado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @assistido.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @assistido.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  def json_webservice_sejus
    nome_assistido = URI.encode(params[:nome_assistido])

    url = "http://172.24.21.2:8082/pesquisa/preso/nome/#{nome_assistido}"
    auth = {username: "defensoria", password: "6D?^pu8JSP7[}:tM"}

    response = HTTParty.get(url, basic_auth: auth)

    render :json => response.parsed_response
  end

  def json_webservice_sejus_detalhado
    seq_assistido_sejus = URI.encode(params[:seq_assistido_sejus])

    url = "http://172.24.21.2:8082/pesquisa/preso/#{seq_assistido_sejus}"
    auth = {username: "defensoria", password: "6D?^pu8JSP7[}:tM"}

    response = HTTParty.get(url, basic_auth: auth)

    render :json => response.parsed_response
  end

  def json_autocomplete_assistido
    search = enhancement_ilike('nome', params["term"])
    @assistidos = Assistido.where(search).pluck(:nome)
    @assistidos = @assistidos.where(ativo: true)

    respond_to do |format|
      format.html { render json: @assistidos }
    end
  end

  def json_autocomplete_assistido_notificacao
    search = enhancement_ilike('nome', params["term"])
    @assistidos_sem_format = Assistido.where(search).pluck(:nome, :nome_mae)
    @assistidos_sem_format = @assistidos_sem_format.where(ativo: true)
    @assistidos = Array.new
    @assistidos_sem_format.each do |assistido|
      @assistidos << assistido[0]+" - Mãe:"+assistido[1]
    end

    respond_to do |format|
      format.html { render json: @assistidos }
    end
  end

  private
    def set_assistido
      @assistido = Assistido.find(params[:id])
    end

    def assistido_params
      params.require(:assistido).permit(:nome, :cpf, :estado_civil, :cep, :logradouro, :numero, :complemento, :bairro,
                                        :cidade, :uf, :profissao, :nome_social, :rg, :orgao_emissor, :data_nascimento,
                                        :nome_pai, :nome_mae, :nacionalidade, :telefone, :telefone_dois, :telefone_tres,
                                        :observacao, :contato_nome, :contato_telefone, :contato_tipo_vinculo,
                                        :contato_email, :resumo, :sexo, :id_importacao_sejus)
    end
end
