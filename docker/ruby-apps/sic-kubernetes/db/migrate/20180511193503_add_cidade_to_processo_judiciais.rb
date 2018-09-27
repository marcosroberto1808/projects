class AddCidadeToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_reference :processo_judiciais, :cidade, index: true
    add_foreign_key :processo_judiciais, :cidades
  end
end
