class PermissaoAcesso < ActiveRecord::Base
	validates_uniqueness_of :cpf, message: "Já existe permissão para este usuário."

	def nome
		Colaborador.where(pessoa_fisica_cpf: self.cpf)
	end

	def get_data
		if self.data
			self.data.strftime("%d/%m/%Y")
		else
			"Sem Permissão"
		end
	end
end