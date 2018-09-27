class ColaboradoresController < ApplicationController
    #CONFIGURAÇÕES DO CANCAN
    skip_authorization_check    #Ignorando Autorizações do cancan

    def edit
    @user = current_user
  end

  def validate_password(password)
        reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))(?=.*([\x21-\x2F]|[\x3A-\x40]|[\x5B-\x60]|[\x7B-\x7E]))([\x20-\x7E]){6,40}$/
        return (reg.match(password))? true : false
    end

  def update_password
      novo_password = params['colaborador']['password']
    @user = Colaborador.where(pessoa_fisica_cpf: current_user.pessoa_fisica_cpf, ativo: true).first
    if @user.tipo_contrato == "Terceirizado"
        if validate_password(novo_password)
                @user.update(user_params)
          # Sign in the user by passing validation in case his password changed
          sign_in @user, :bypass => true
        flash[:notice] = "Senha alterada com sucesso!"
          redirect_to root_path
        else
            flash[:alert] = "Verifique a senha digitada, a nova senha deve ser: <br /> - Igual nos 2 campos de nova senha <br /> - Diferente da senha atual <br /> - Conter pelo menos 1 numeral <br /> -  Conter pelo menos uma letra <br /> - Conter pelo menos um caractere especial ( ! @ # $ % & * + ; _ etc.) <br /> - Ter pelo menos 6 digitos.".html_safe
            redirect_to edit_colaborador_path
        end
      else
            if @user.update(user_params)
        # Sign in the user by passing validation in case his password changed
        sign_in @user, :bypass => true
        flash[:notice] = "Senha alterada com sucesso!"
        redirect_to root_path
      else
        flash[:alert] = "A senha deve ter no minimo 4 digitos e não pode ser vazia."
        redirect_to "/colaborador/edit"
      end
      end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.required(:colaborador).permit(:password, :password_confirmation)
  end
end
