class LotacaoDefensor < ActiveRecord::Base
	self.table_name = 'informar_lotacao_defensores'
	establish_connection "lotacao_#{Rails.env}"
	has_many :local_atuacao_processo, :dependent => :delete_all

	def self.get_lotacao_defensor(cpf)
		LotacaoDefensor.where(cpf: cpf, data_fim: nil)
	end

end