json.array!(@eventos) do |evento|
  json.extract! evento, :id, :data, :descricao, :tipo, :local_atuacao, :assistido_id
  json.url evento_url(evento, format: :json)
end
