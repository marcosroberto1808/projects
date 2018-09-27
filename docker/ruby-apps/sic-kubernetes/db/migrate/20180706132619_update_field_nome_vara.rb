class UpdateFieldNomeVara < ActiveRecord::Migration
  def self.up
    Vara.where(nome: "1ª Vara de Execuções Penais").each do |a|
      a.update_attributes(nome: "1ª Vara de Execução Penal")
    end
    Vara.where(nome: "2ª Vara de Execuções Penais").each do |a|
      a.update_attributes(nome: "2ª Vara de Execução Penal")
    end
    Vara.where(nome: "3ª Vara de Execuções Penais").each do |a|
      a.update_attributes(nome: "3ª Vara de Execução Penal")
    end
  end

  def self.down
    Vara.where(nome: "1ª Vara de Execução Penal").each do |a|
      a.update_attributes(nome: "1ª Vara de Execuções Penais")
    end
    Vara.where(nome: "2ª Vara de Execução Penal").each do |a|
      a.update_attributes(nome: "2ª Vara de Execuções Penais")
    end
    Vara.where(nome: "3ª Vara de Execução Penal").each do |a|
      a.update_attributes(nome: "3ª Vara de Execuções Penais")
    end
  end
end
