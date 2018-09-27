json.array!(@origem_inqueritos) do |origem_inquerito|
  json.extract! origem_inquerito, :id, :uf, :cidade_id, :nome
  json.url origem_inquerito_url(origem_inquerito, format: :json)
end
