module AndamentoForcaTarefa
  extend ActiveSupport::Concern

  def self.filters_relatorio_atividades_realizadas(data_inicial, data_final, forca_tarefa_id, defensor_cpf)
    totais = {
        providencia: {},
    }

    providencia = ClassificacaoAndamento.all.order("descricao").pluck(:descricao)
    totais.keys.each do |total_key|
      binding.local_variable_get(total_key).each do |i|
        totais[total_key][i] = 0
      end
    end

    andamentos = Andamento.joins(:classificacao_andamento).joins(:audits)
    andamentos = andamentos.where(filtros_methods(forca_tarefa_id,data_inicial,data_final,defensor_cpf, '',''))

    andamentos.each do |andamento|
      if totais[:providencia][andamento.classificacao_andamento.descricao].present?
        totais[:providencia][andamento.classificacao_andamento.descricao] += 1
      end
    end

    totais
  end

  def self.filters_relatorio_forca_tarefa(data_inicial, data_final, forca_tarefa_id, defensor_cpf, type, key)
    totais = {
        providencia: {},
        tipo_andamento: {},
        problema_identificado: {},
    }

    providencia = ClassificacaoAndamento::providencias.sort
    problema_identificado = Andamento::problemas_identificados.sort
    tipo_andamento = [:at_presencial, :at_analise_processual, :total_assistidos, :total_processos]

    totais.keys.each do |total_key|
      binding.local_variable_get(total_key).each do |i|
        totais[total_key][i] = 0
      end
    end

    andamentos = Andamento.joins(:classificacao_andamento).joins(:audits)
    andamentos = andamentos.where(filtros_methods(forca_tarefa_id,data_inicial,data_final,defensor_cpf, type, key))

    totais[:tipo_andamento][:at_presencial] = andamentos.where(at_presencial: true).count
    totais[:tipo_andamento][:at_analise_processual] = andamentos.where(at_analise_processual: true).count
    totais[:tipo_andamento][:total_assistidos] = ProcessoJudicial.where(id: andamentos.pluck(:processo_id)).pluck(:assistido_id).uniq.count
    totais[:tipo_andamento][:total_processos] = andamentos.select(:processo_id).distinct(:processo_id).count

    andamentos.each do |andamento|
      if totais[:providencia][andamento.classificacao_andamento.descricao].present?
        totais[:providencia][andamento.classificacao_andamento.descricao] += 1
      end

      problema_identificado.each do |pi|
        if andamento.problemas_identificados.include?(pi)
          totais[:problema_identificado][pi] += 1
        end
      end
    end

    totais
  end

  def self.filtros_methods(forca_tarefa_id,data_inicial,data_final,defensor_cpf, type, key)
    result = []
    user_id = buscar_id_defensor(defensor_cpf)
    result << "forca_tarefa_id = '#{forca_tarefa_id}'" if forca_tarefa_id.present?
    result << "forca_tarefa = '#{ true }'" if forca_tarefa_id.present?
    result << "data >= '#{data_inicial}'" if data_inicial.present?
    result << "data <= '#{data_final}'" if data_final.present?
    result << "user_id = '#{user_id}'" if defensor_cpf.present?
    result << "classificacao_andamentos.descricao = '#{ key }'" if type == 'providencia'
    result << "problemas_identificados ilike %#{ key }%" if type == 'problema-identificado'
    result << "key = #{ true }" if type == 'tipo-de-andamento'
    result.join(' and ')
  end

  def self.buscar_id_defensor(cpf)
    begin
      DefensorSemFronteira.where(pessoa_fisica_cpf: cpf, ativo: true).first.id
    rescue
      if cpf.present?
        Colaborador.where(pessoa_fisica_cpf: cpf, ativo: true).first.id
      end
    end
  end

end
