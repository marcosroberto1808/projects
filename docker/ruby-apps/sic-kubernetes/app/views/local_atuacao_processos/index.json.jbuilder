json.array!(@local_atuacao_processos) do |local_atuacao_processo|
  json.extract! local_atuacao_processo, :id, :processo_judicial_id
  json.url local_atuacao_processo_url(local_atuacao_processo, format: :json)
end
