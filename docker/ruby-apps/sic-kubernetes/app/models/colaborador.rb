class Colaborador < ActiveRecord::Base
	has_many :cfue, primary_key: :codigo, foreign_key: :colaborador_codigo
	self.table_name = 'adm_pgeatv100029.colaboradores'

	#conexão com a tabela colaboradores do portaldigital
	establish_connection "colaboradores_#{Rails.env}"

	devise 	:database_authenticatable, 
					:registerable, 
					:rememberable, 
					:recoverable,
					:trackable, 
					:validatable,
					:authentication_keys => [:pessoa_fisica_cpf, :ativo]

	def email_required?
		false
	end

	# verifica se o colaborador tem a função necessaria para acessar o sistema.
	def active_for_authentication?
  	(super && get_permissao) and get_tempo_acesso
	end

	def inactive_message
	  get_tempo_acesso ? super : "Seu prazo de tempo de acesso para o sistema expirou, favor renovar."
	  get_permissao ? super : "Você não tem permissão para acessar o sistema."
	end
	
	def get_permissao
		user_areas = Cfue.where(pessoa_fisica_cpf: self.pessoa_fisica_cpf, ativo: true).pluck(:unidade_exercicio_descricao)

		if (user_areas && UNIDADE_EXERCICIO).any?
			self.cfue.where(ativo: true, funcao_descricao: FUNCTIONS_ALL).exists?
		end
	end

	def get_permissao_acesso
		PermissaoAcesso.find_by_cpf(self.pessoa_fisica_cpf)
	end

	def get_tempo_acesso
    result = false
		if self.cfue.where(ativo: true,
                       funcao_descricao: FUNCTIONS_ALL,
                       unidade_exercicio_descricao: UNIDADE_EXERCICIO).exists?
			# não tem tempo de acesso limitado
      result = true
		elsif self.cfue.where(ativo: true, funcao_descricao: "Operador SIC").exists?
			@permissao = PermissaoAcesso.where(cpf: self.pessoa_fisica_cpf)
			if @permissao.present? and @permissao[0].data > Date.today
        result = true
			else
        result = false
			end
    end
    result
	end	

	# metodo para validar password encriptografados pelos sitemas antigos	
	def valid_password?(password)
		if self.legacy_password?
			# Use Devise's secure_compare to avoid timing attacks
			if Devise.secure_compare(self.senha, Colaborador.legacy_password(password)) 
				self.password = password
				self.password_confirmation = password
				self.legacy_password = false
				self.save!
			else
				return false
			end
		end

		super(password)
	end
	
 	# algoritimo de criptografia usado nas senhas antigas dos colaboradores
	def self.legacy_password(password)
		return Digest::SHA1.hexdigest("--#{nil}--#{password}--")
	end
end
