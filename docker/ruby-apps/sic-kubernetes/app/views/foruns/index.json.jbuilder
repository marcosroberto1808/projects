json.array!(@foruns) do |forum|
  json.extract! forum, :id, :nome
  json.url forum_url(forum, format: :json)
end
