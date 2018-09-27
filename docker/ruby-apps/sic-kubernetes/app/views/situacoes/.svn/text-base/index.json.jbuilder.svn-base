json.array!(@situacoes) do |situacao|
  json.extract! situacao, :id, :preso, :instituicao, :cidade, :uf, :data_prisao, :motivo, :assistido_id
  json.url situacao_url(situacao, format: :json)
end
