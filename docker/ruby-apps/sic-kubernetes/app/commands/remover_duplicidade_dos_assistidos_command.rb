class RemoverDuplicidadeDosAssistidosCommand
  def self.assistido_escolhido_com_sejus_id(result)
    Assistido.where(nome: result['nome'], nome_mae: result['nome_mae'], ativo: true).where.not(id_importacao_sejus: nil).last
  end

  def self.assistido_escolhido_sem_sejus_id(result)
    Assistido.where(nome: result['nome'], nome_mae: result['nome_mae'], ativo: true, id_importacao_sejus: nil).order(id: :desc).first
  end

  def self.assistidos_que_serao_desativados(result, escolhido_id)
    Assistido.where(nome: result['nome'], nome_mae: result['nome_mae'], ativo: true, id_importacao_sejus: nil).where.not(id: escolhido_id)
  end

  def self.unificando_assistidos(sql, assistido_escolhido_method_name, assistidos_respectivos_method_name)
    total_andamentos = 0
    total_assistidos = 0
    total_inqueritos = 0
    total_documentos = 0
    total_processos_judiciais = 0
    total_inqueritos_documentos = 0
    total_andamentos_documentos = 0

    results = ActiveRecord::Base.connection.execute sql.strip
    if results.present?
      results.each do |result|
        the_chosen = self.send assistido_escolhido_method_name, result
        the_others = self.send assistidos_respectivos_method_name, result, the_chosen.id

        total_assistidos += the_others.count
        the_others.each do |assistido|
          assistido.ativo = false
          assistido.save(:validate => false)

          inqueritos = assistido.inquerito_policial
          total_inqueritos += inqueritos.count
          inqueritos.each do |inquerito|
            novo_inquerito = InqueritoPolicial.create(inquerito.attributes.except('id').merge({'assistido_id' => the_chosen.id}))

            documentos = inquerito.documento
            total_inqueritos_documentos += documentos.count
            documentos.each do |documento|
              novo_documento = Documento.create(documento.attributes.except('id').merge({'inquerito_policial_id' => novo_inquerito.id}))
              documento.duplicar_arquivo novo_documento.get_path
            end
          end

          documentos = Documento.joins(:classificacao_documento).where(assistido_id: assistido.id, 'classificacao_documentos.tipo_documento_id' => [TipoDocumento::PESSOAL_ID, TipoDocumento::EXTRAJUDICIAL_ID])
          total_documentos += documentos.count
          documentos.each do |documento|
            novo_documento = Documento.create(documento.attributes.except('id').merge({'assistido_id' => the_chosen.id}))

            documento.duplicar_arquivo novo_documento.get_path
          end

          processos_judiciais = ProcessoJudicial.where(assistido_id: assistido.id)
          total_processos_judiciais += processos_judiciais.count
          processos_judiciais.each do |processo_judicial|
            novo_processo_judicial = ProcessoJudicial.create(processo_judicial.attributes.except('id').merge({'assistido_id' => the_chosen.id}))
            andamentos = processo_judicial.andamento
            total_andamentos += andamentos.count
            andamentos.each do |andamento|
              novo_andamento_documento_id = nil
              if andamento.documento
                total_andamentos_documentos += 1
                novo_andamento_documento = Documento.create(andamento.documento.attributes.except('id').merge({'assistido_id' => the_chosen.id}))
                novo_andamento_documento_id = novo_andamento_documento.id

                andamento.documento.duplicar_arquivo novo_andamento_documento.get_path
              end

              Andamento.create(andamento.attributes.except('id').merge({'processo_id' => novo_processo_judicial.id, 'documento_id': novo_andamento_documento_id}))
            end
          end
        end
      end
    end

    puts "Total de Assistidos: #{total_assistidos}"
    puts "Total de Inqueritos: #{total_inqueritos}"
    puts "Total de Processos Judiciais: #{total_processos_judiciais}"
    puts "Total de Andamentos: #{total_andamentos}"
    puts "Total de Documentos de Inqueritos: #{total_inqueritos_documentos}"
    puts "Total de Documentos de Andamentos: #{total_andamentos_documentos}"
    puts "Total de Documentos (Pessoais e Extrajudiciais): #{total_documentos}"
  end

  def self.unificando_assistidos_com_sejus_id
    sql = "
      SELECT nome, nome_mae, COUNT(*)
        FROM assistidos
       WHERE nome NOT IN (SELECT a.nome FROM assistidos a WHERE id_importacao_sejus IS NULL GROUP BY a.nome, a.nome_mae HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC)
    GROUP BY nome, nome_mae
      HAVING COUNT(*) > 1
    ORDER BY COUNT(*) DESC
    "

    self.unificando_assistidos sql, 'assistido_escolhido_com_sejus_id', 'assistidos_que_serao_desativados'
  end

    def self.unificando_assistidos_sem_sejus_id
    sql = "SELECT a.nome, a.nome_mae, COUNT(*) FROM assistidos a WHERE id_importacao_sejus IS NULL GROUP BY a.nome, a.nome_mae HAVING COUNT(*) > 1 ORDER BY COUNT(*) DESC"
    self.unificando_assistidos sql, 'assistido_escolhido_sem_sejus_id', 'assistidos_que_serao_desativados'
  end
end
