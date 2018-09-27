class UpdateClassificacaoAndamentoFromAndamento < ActiveRecord::Migration
  def change
    Andamento.where(:classificacao_andamento_id => 60).each do |a|
      a.update_attributes(classificacao_andamento_id: 5)
    end
    Andamento.where(:classificacao_andamento_id => 50).each do |a|
      a.update_attributes(classificacao_andamento_id: 36)
    end
    Andamento.where(:classificacao_andamento_id => 44).each do |a|
      a.update_attributes(classificacao_andamento_id: 2)
    end
    Andamento.where(:classificacao_andamento_id => 36).each do |a|
      a.update_attributes(classificacao_andamento_id: 3)
    end
    Andamento.where(:classificacao_andamento_id => 42).each do |a|
      a.update_attributes(classificacao_andamento_id: 1)
    end
    Andamento.where(:classificacao_andamento_id => 43).each do |a|
      a.update_attributes(classificacao_andamento_id: 4)
    end
  end
end
