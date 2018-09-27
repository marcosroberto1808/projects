class AddDataPublicacaoAcordaoToProcessoJudiciais < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :data_publicacao_acordao, :date
  end
end
