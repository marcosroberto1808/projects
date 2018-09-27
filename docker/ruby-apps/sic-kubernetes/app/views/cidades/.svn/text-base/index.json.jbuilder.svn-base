json.array!(@cidades) do |cidade|
  json.extract! cidade, :id, :nome, :uf
  json.url cidade_url(cidade, format: :json)
end
