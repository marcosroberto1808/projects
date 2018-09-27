module ApplicationHelper
    include NotificacoesHelper

    def deleta_notificacao_refeita(assistido)
        @notificacoes = Notificacao.where(assistido_id: assistido, descricao: "Notificação de 90 dias de prisão.")
        if @notificacoes.present?
            @notificacoes.each do |notificacao|
                notificacao.destroy
            end
        end
    end

    def get_defensor_nome_cpf(cpf)
        colaborador = Colaborador.find_by_pessoa_fisica_cpf(cpf)
        if colaborador.present?
            colaborador.pessoa_fisica_nome
        end
    end

    def get_defensores
        Cfue.select(:pessoa_fisica_nome, :pessoa_fisica_cpf).uniq.where(
            unidade_exercicio_descricao:UNIDADE_EXERCICIO,
            funcao_descricao: "Defensor Público", ativo: true).order(:pessoa_fisica_nome)
    end

    def get_operadores
        Cfue.select(:pessoa_fisica_nome, :pessoa_fisica_cpf).uniq.where(
            unidade_exercicio_descricao:UNIDADE_EXERCICIO,
            ativo: true).where.not(funcao_descricao: "Defensor Público").order(:pessoa_fisica_nome)
    end

    def get_defensores_and_operadores_choices
        defensores = get_defensores
        operadores = get_operadores
        {
        'Defensor' => defensores.pluck(:pessoa_fisica_nome, :pessoa_fisica_cpf),
        'Operador' => operadores.pluck(:pessoa_fisica_nome, :pessoa_fisica_cpf)
        }
    end

    def deleta_evento_notificacao_refeita(assistido_id)
        @eventos = Evento.where(assistido_id: assistido_id, descricao: "Notificação de 90 dias de prisão.")
        if @eventos.present?
            #deleta o evento de relaxamento caso exista
            @eventos.each do |evento|
                #deleta todas as notificacoes deste evento
                @notificacoes = Notificacao.where(evento_id: evento.id)
                if @notificacoes.present?
                    @notificacoes.each do |notificacao|
                        notificacaof.destroy
                    end
                end
                evento.destroy
            end
        end
    end

    def get_cpf
      if current_colaborador
        current_colaborador.pessoa_fisica_cpf
      else
        current_defensor_sem_fronteira.pessoa_fisica_cpf
      end
    end

    def get_nome
      if current_colaborador
        current_colaborador.pessoa_fisica_nome
      else
        current_defensor_sem_fronteira.pessoa_fisica_nome
      end
    end

    def get_locais_atuacao(cpf)
        @lotacoes = LotacaoDefensor.where(cpf: cpf, data_fim: nil)
        if @lotacoes.empty?
          @lotacoes = LotacaoDefensor.where("descricao_local ilike ?", "%CRIMINAL%").order(:descricao_local).select(:descricao_local).uniq
        end
        return @lotacoes
    end

  	def enhancement_ilike(field, term)
  		"TRANSLATE(#{field}, 'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ', 'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC') ilike TRANSLATE('%#{term}%', 'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ', 'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC')"
  	end

    def listaEstados
        @estados = ["AC", "AL" ,"AP" ,"AM" ,"BA" ,"CE" ,"DF" ,"ES" ,"GO" ,"MA" ,"MT" ,"MS" ,"MG" ,"PA" ,"PB" ,"PR" ,"PE" ,"PI" ,"RJ" ,"RN" ,"RS" ,"RO" ,"RR" ,"SC" ,"SP" ,"SE" ,"TO"]
    end

    def listaEstadosCadastrados
        Cidade.select("DISTINCT (uf)").order(:uf)
    end

    def listaCidades
        Cidade.all.order("nome, uf asc")
    end

    def get_data_by_string(data)
        ano = data[0..3]
        mes = data[4..5]
        dia = data[6..7]
        return (Date.new(ano.to_i, mes.to_i, dia.to_i))
    end

    #Valida se uma string no formato AAAAMMDD de data é válida.
    def valida_string_data(data)
        ano = data[0..3]
        mes = data[4..5]
        dia = data[6..7]
        return (Date.valid_date?(ano.to_i, mes.to_i, dia.to_i))
    end

    def valida_string_only_numbers(numero)
        if (/[a-zA-Z]/.match(numero) or numero.gsub(/\s+/, "").empty?)
            return false
        else
            return true
        end
    end

    def convert_mes_referencia_to_date(mes_referencia)
        mes_ref = mes_referencia.split("-")
      mes = get_mes_by_name(mes_ref[0])
      ano = mes_ref[1].to_i
      data = Date.new(ano, mes, 1)
      return data
  end

  def convert_data_to_mes_referencia(data)
      mes = get_mes_by_num(data.month)
      ano = data.year
      return (mes+"-"+ano.to_s)
    end

    def get_meses
        #raise default_selected.inspect
        meses = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"]
    end

    def get_mes_by_num(num)
        case num
        when 1
            "Janeiro"
        when 2
            "Fevereiro"
        when 3
            "Março"
        when 4
            "Abril"
        when 5
            "Maio"
        when 6
            "Junho"
        when 7
            "Julho"
        when 8
            "Agosto"
        when 9
            "Setembro"
        when 10
            "Outubro"
        when 11
            "Novembro"
        when 12
            "Dezembro"
        end
    end

    def get_mes_by_name(name)
        case name
        when "Janeiro"
            1
        when "Fevereiro"
            2
        when "Março"
            3
        when "Abril"
            4
        when "Maio"
            5
        when "Junho"
            6
        when "Julho"
            7
        when "Agosto"
            8
        when "Setembro"
            9
        when "Outubro"
            10
        when "Novembro"
            11
        when "Dezembro"
            12
        end
    end

    def cidades
        Cidade.all
    end

    def validar_data(data)
        data.present? and data >= Date.today
    end

    def gerar_notificacoes(usuario)
        @lotacoes = get_locais_atuacao(get_cpf)
        @lotacoes.each do |lotacao|
            #recupera todos os eventos criados para as lotações deste usuário
            @eventos = Evento.where("local_atuacao = ? and data < ?", lotacao.id, Date.today)
            #verifica evento por evento se sua notificação já foi gerada para este usuário
            @eventos.each do |evento|
                notificacao = Notificacao.where(evento_id: evento.id, notificado: usuario)
                if notificacao.empty?
                    notificar(evento,usuario)
                end
            end
        end
        @notificacoes = Notificacao.where("notificado = ? and visto = ? and data <= ?", usuario, false, Date.today).order("data desc")
    end

    def yes_or_no_choices
        [['Selecione uma opção', ''], ['Sim', 1], ['Não', 0]]
    end

    def get_destrava_ultimo_andamento(processo_id)
        usuario_logado = session['warden.user.colaborador.key'].first.first
        processo = Andamento.joins(:audits).where(processo_id: processo_id, "audits.user_id": usuario_logado)
        andamento_id = ''
        if processo.size > 0
            andamento_id = processo.last.id
        end
        andamento_id
    end

    def get_remove_botao_apagar(andamento_id)
        usuario_logado = session['warden.user.colaborador.key'].first.first
        andamento = Andamento.joins(:audits).where(id: andamento_id, "audits.user_id": usuario_logado)
        andamento.size > 0
    end
end
