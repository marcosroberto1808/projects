class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "documentos", "assistidos", name: "documentos_assistido_id_fk"
    add_foreign_key "documentos", "classificacao_documentos", name: "documentos_classificacao_documento_id_fk"
    add_foreign_key "documentos", "inquerito_policiais", name: "documentos_inquerito_policial_id_fk", dependent: :delete
    add_foreign_key "documentos", "processo_judiciais", name: "documentos_processo_judicial_id_fk", dependent: :delete
    add_foreign_key "eventos", "assistidos", name: "eventos_assistido_id_fk"
    add_foreign_key "foruns", "cidades", name: "foruns_cidade_fk", column: "cidade"
    add_foreign_key "informacao_socioeconomicas", "assistidos", name: "informacao_socioeconomicas_assistido_id_fk"
    add_foreign_key "infracoes", "inquerito_policiais", name: "infracoes_inquerito_policial_id_fk", dependent: :delete
    add_foreign_key "inquerito_policiais", "assistidos", name: "inquerito_policiais_assistido_id_fk"
    add_foreign_key "local_atuacao_processos", "processo_judiciais", name: "local_atuacao_processos_processo_judicial_id_fk", dependent: :delete
    add_foreign_key "localizacao_processos", "processo_judiciais", name: "localizacao_processos_processo_judicial_id_fk", dependent: :delete
    add_foreign_key "notificacoes", "assistidos", name: "notificacoes_assistido_id_fk"
    add_foreign_key "notificacoes", "eventos", name: "notificacoes_evento_id_fk"
    add_foreign_key "origem_inqueritos", "cidades", name: "origem_inqueritos_cidade_id_fk"
    add_foreign_key "processo_judiciais", "assistidos", name: "processo_judiciais_assistido_id_fk"
    add_foreign_key "processo_judiciais", "inquerito_policiais", name: "processo_judiciais_inquerito_policial_id_fk"
    add_foreign_key "situacoes", "assistidos", name: "situacoes_assistido_id_fk"
    add_foreign_key "varas", "foruns", name: "varas_forum_id_fk"
  end
end
