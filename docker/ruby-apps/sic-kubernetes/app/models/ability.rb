class Ability
  include CanCan::Ability

  def initialize(user)
   if user.is_a?(Colaborador)
      funcoes = Cfue.where(pessoa_fisica_cpf: user.pessoa_fisica_cpf,
                           ativo:  true, unidade_exercicio_descricao: UNIDADE_EXERCICIO).pluck(:funcao_descricao)
      #OPERADOR
      if funcoes.include? 'Operador SIC'
        can :manage, :all
        cannot :destroy, Assistido
        cannot :destroy, Documento
        cannot :destroy_penal, ProcessoJudicial
        cannot :manage, PermissaoAcesso
      end

      #DEFENSOR
      if funcoes.include? 'Defensor Público'
        can :manage, :all
        cannot :destroy_penal, ProcessoJudicial
      end

      #NUDEP/NUAP
      for area in UNIDADE_EXERCICIO
        if funcoes.include?(area)
          can :manage, :all
          can :destroy_penal, ProcessoJudicial
          cannot :manage, PermissaoAcesso
        end
      end
    elsif user.is_a?(DefensorSemFronteira)
      # Nesse caso o devensor sem fronteiras está com as mesmas permissoes de operador
      can :manage, :all
      cannot :destroy, Assistido
      cannot :destroy, Documento
      cannot :destroy_penal, ProcessoJudicial
      cannot :manage, PermissaoAcesso
    end

  end
end
