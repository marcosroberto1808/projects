class Cfue < ActiveRecord::Base
    belongs_to :colaborador, -> { where ativo: true }, primary_key: :codigo, foreign_key: :colaborador_codigo

    #conexão com a tabela cfue do portaldigital
    self.table_name = 'colaboradores_funcoes_unidades_exercicios'
    establish_connection "cfue_#{Rails.env}"
end
