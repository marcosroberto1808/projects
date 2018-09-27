class PasswordsController < Devise::PasswordsController
  def validate_password(password)
    reg = /^(?=.*\d)(?=.*([a-z]|[A-Z]))(?=.*([\x21-\x2F]|[\x3A-\x40]|[\x5B-\x60]|[\x7B-\x7E]))([\x20-\x7E]){6,40}$/
    return (reg.match(password))? true : false
  end

  def create
    if DefensorSemFronteira.find_by_email(params['colaborador']['email'])
      def resource_class
        DefensorSemFronteira
      end
    else
      def resource_class
        Colaborador
      end
    end

    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    else
      respond_with(resource)
    end
  end


  def update
    novo_password = params["colaborador"]["password"].inspect
    cpf = params["cpf"].gsub('-', '').gsub('.', '')

    if DefensorSemFronteira.find_by_pessoa_fisica_cpf(cpf)
      def resource_class
        DefensorSemFronteira
      end
    else
      def resource_class
        Colaborador
      end
    end

    if resource_class == Colaborador
      colaborador = Colaborador.where(pessoa_fisica_cpf: cpf, ativo: true).first

      if colaborador.present? && colaborador.tipo_contrato == "Terceirizado"
        if validate_password(novo_password)
          #Action default de reset password do devise
          self.resource = resource_class.reset_password_by_token(resource_params)
          yield resource if block_given?
          if resource.errors.empty?
            resource.unlock_access! if unlockable?(resource)
            flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
            set_flash_message(:notice, flash_message) if is_flashing_format?
            sign_in(resource_name, resource)
            respond_with resource, location: after_resetting_password_path_for(resource)
          else
            respond_with resource
          end
        else
          flash[:alert] = "Verifique a senha digitada, a nova senha deve ser: <br /> - Igual nos 2 campos de nova senha <br /> - Diferente da senha atual <br /> - Conter pelo menos 1 numeral <br /> -  Conter pelo menos uma letra <br /> - Conter pelo menos um caractere especial ( ! @ # $ % & * + ; _ etc.) <br /> - Ter pelo menos 6 digitos.".html_safe
          redirect_to  :back
        end
      else #não é terceirizado, não precisa validar senha complexa
        #Action default de reset password do devise
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?
        if resource.errors.empty?
          resource.unlock_access! if unlockable?(resource)
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message(:notice, flash_message) if is_flashing_format?
          sign_in(resource_name, resource)
          respond_with resource, location: after_resetting_password_path_for(resource)
        else
          flash[:alert] = "A senha deve ter no minimo 4 digitos e não pode ser vazia."
          redirect_to :back
        end
      end
    else
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?
      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        flash[:alert] = "Senha Atualizada Com Sucesso"
        respond_with resource, location: after_resetting_password_path_for(resource)
      else
        flash[:alert] = "A senha deve ter no minimo 4 digitos e não pode ser vazia."
        redirect_to :back
      end
    end
  end

end
