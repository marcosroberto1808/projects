class ChangeForeignKeysClassificacaoDocumentos < ActiveRecord::Migration
  def change
    add_foreign_key :classificacao_documentos, :tipo_documentos, column: :tipo_documento_id,
                    class_name: :tipo_documento
  end
end
