class UpdateFieldDescricaoClassificacaoAndamento < ActiveRecord::Migration
  def self.up
    ClassificacaoAndamento.where(:descricao => "Ciências").each do |a|
      a.update_attributes(descricao: "Ciência")
    end
    ClassificacaoAndamento.where(:descricao => "Ciências de Atos Processuais").each do |a|
      a.update_attributes(descricao: "Ciência de Atos Processuais")
    end
    ClassificacaoAndamento.where(:descricao => "Atendimento a presos").each do |a|
      a.update_attributes(descricao: "Atendimento no estabelecimento penal")
    end
    ClassificacaoAndamento.where(:descricao => "Calculo de pena").each do |a|
      a.update_attributes(descricao: "Liquidação de pena")
    end
    ClassificacaoAndamento.create(:descricao => "PAD no estabelecimento prisional")
  end

  def self.down
    ClassificacaoAndamento.where(:descricao => "Ciência").each do |a|
      a.update_attributes(descricao: "Ciências")
    end
    ClassificacaoAndamento.where(:descricao => "Ciência de Atos Processuais").each do |a|
      a.update_attributes(descricao: "Ciências de Atos Processuais")
    end
    ClassificacaoAndamento.where(:descricao => "Atendimento no estabelecimento penal").each do |a|
      a.update_attributes(descricao: "Atendimento a presos")
    end
    ClassificacaoAndamento.where(:descricao => "Liquidação de pena").each do |a|
      a.update_attributes(descricao: "Calculo de pena")
    end
    ClassificacaoAndamento.delete_all(:descricao => "PAD no estabelecimento prisional")
  end
end
