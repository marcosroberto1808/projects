json.array!(@infracoes) do |infracao|
  json.extract! infracao, :id, :inquerito_policial_id, :descricao_codigo, :descricao_nome
  json.url infracao_url(infracao, format: :json)
end
