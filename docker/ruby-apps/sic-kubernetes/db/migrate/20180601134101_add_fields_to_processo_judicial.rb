class AddFieldsToProcessoJudicial < ActiveRecord::Migration
  def change
    add_column :processo_judiciais, :capitulacao, :string
    add_column :processo_judiciais, :regime, :string
    add_column :processo_judiciais, :pena, :string
    add_column :processo_judiciais, :genero_delitivo, :string
    add_column :processo_judiciais, :natureza_delitiva, :string
    add_column :processo_judiciais, :tempo_medida_cautelar, :string

  end
end
