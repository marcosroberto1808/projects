json.array!(@classificacao_documentos) do |classificacao_documento|
  json.extract! classificacao_documento, :id, :descricao
  json.url classificacao_documento_url(classificacao_documento, format: :json)
end
