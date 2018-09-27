json.array!(@inquerito_policiais) do |inquerito_policial|
  json.extract! inquerito_policial, :id, :assistido_id, :origem, :cidade, :uf, :logradouro, :numero, :complemento, :bairro, :infracao_cep, :data_abertura, :observacao, :instauracao, :data_crime, :latitude, :longitude, :cep
  json.url inquerito_policial_url(inquerito_policial, format: :json)
end
