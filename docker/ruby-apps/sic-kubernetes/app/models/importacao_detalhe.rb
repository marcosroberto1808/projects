class ImportacaoDetalhe < ActiveRecord::Base
  belongs_to :assistido

  PARECER = 'Parecer'
  PETICAO = 'Petição'
  OFICIO = 'Ofício'
  PROCESSO = 'Processo'
end
