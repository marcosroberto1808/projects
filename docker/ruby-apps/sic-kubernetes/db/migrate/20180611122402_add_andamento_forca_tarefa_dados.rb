class AddAndamentoForcaTarefaDados < ActiveRecord::Migration
  def self.up
    ClassificacaoAndamento.delete_all(:id => 60)
    ClassificacaoAndamento.delete_all(:id => 50)
    ClassificacaoAndamento.delete_all(:id => 44)
    ClassificacaoAndamento.delete_all(:id => 46)
    ClassificacaoAndamento.delete_all(:id => 42)
    ClassificacaoAndamento.delete_all(:id => 43)

    ClassificacaoAndamento.create(:descricao => "Atendimento a presos")
    ClassificacaoAndamento.create(:descricao => "Ciências")
    ClassificacaoAndamento.create(:descricao => "Progressões para regime semiaberto")
    ClassificacaoAndamento.create(:descricao => "Progressões para regime aberto")
    ClassificacaoAndamento.create(:descricao => "Carta ao Preso")
    ClassificacaoAndamento.create(:descricao => "Cotas nos Autos")
    ClassificacaoAndamento.create(:descricao => "Outras petições")
    ClassificacaoAndamento.create(:descricao => "Recurso – Minuta de Agravo")
    ClassificacaoAndamento.create(:descricao => "Recurso – Contraminuta de Agravo")
    ClassificacaoAndamento.create(:descricao => "Isenção de fiança")

    ClassificacaoAndamento.where(:descricao => "Audiencia Extrajudicial").each do |a|
      a.update_attributes(descricao: "Audiência Extrajudicial")
    end
  end
  def self.down
    ClassificacaoAndamento.delete_all(:descricao => "Atendimento a presos")
    ClassificacaoAndamento.delete_all(:descricao => "Ciências")
    ClassificacaoAndamento.delete_all(:descricao => "Progressões para regime semiaberto")
    ClassificacaoAndamento.delete_all(:descricao => "Progressões para regime aberto")
    ClassificacaoAndamento.delete_all(:descricao => "Carta ao Preso")
    ClassificacaoAndamento.delete_all(:descricao => "Cotas nos Autos")
    ClassificacaoAndamento.delete_all(:descricao => "Outras petições")
    ClassificacaoAndamento.delete_all(:descricao => "Recurso – Minuta de AgravoOutras petições")
    ClassificacaoAndamento.delete_all(:descricao => "Recurso – Contraminuta de Agravo")
    ClassificacaoAndamento.delete_all(:descricao => "Isenção de fiança")
  end
end
