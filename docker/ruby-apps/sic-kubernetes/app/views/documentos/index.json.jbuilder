json.array!(@documentos) do |documento|
  json.extract! documento, :id, :tipo_documento_id, :assistido_id, :inquerito_policial_id, :processo_judicial_id, :data, :nome_url, :resposta_necessidade, :resposta
  json.url documento_url(documento, format: :json)
end
