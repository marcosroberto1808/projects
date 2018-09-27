module AndamentosHelper

  def get_cadastrador(andamento_id)
    cadastrador_id = Audit.find_by_auditable_id(andamento_id)
    if cadastrador_id.present?
      Colaborador.find_by_id_and_ativo(cadastrador_id.user_id, true).present? ?
          Colaborador.find_by_id_and_ativo(cadastrador_id.user_id, true).pessoa_fisica_nome :
          DefensorSemFronteira.find_by_id_and_ativo(cadastrador_id.user_id, true).pessoa_fisica_nome
    end
  end
end
