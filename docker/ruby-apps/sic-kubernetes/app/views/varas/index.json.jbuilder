json.array!(@varas) do |vara|
  json.extract! vara, :id, :nome, :forum_id
  json.url vara_url(vara, format: :json)
end
