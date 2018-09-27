Sic::Application.routes.draw do

  resources :vinculo_defensores
  get  '/vinculo_defensores/new/:assistido_id' => 'vinculo_defensores#new'

  resources :classificacao_andamentos

  resources :andamentos do
    collection do
      match :consultar, via: [:get, :post]
      match :atividades_realizadas, via: [:get, :post]
      get '/get-assistidos/' => 'andamentos#get_assistidos', as: 'get_assistidos'
    end
  end

  resources :permissao_acessos
  post '/liberar' => 'permissao_acessos#liberar'
  post '/atualizar' => 'permissao_acessos#atualizar'
  get  '/filtrar' => 'permissao_acessos#filtrar'
  get  '/json_autocomplete_usuario' => 'permissao_acessos#json_autocomplete_usuario'

  resources :origem_inqueritos

  resources :eventos

  resources :situacoes

  resources :classificacao_documentos

  resources :varas

  resources :foruns

  resources :informacao_socioeconomicas
  resources :notificacoes
  get '/pesquisar' => 'notificacoes#pesquisar'

  resources :infracoes
  resources :assinatura_virtuais
  resources :local_atuacao_processos
  resources :tipo_documentos
  resources :processo_judiciais do
    collection do
      delete '/apagar_andamento/:andamento_id/:processo_id', :to => 'processo_judiciais#apagar_andamento', :as => "apagar_andamento"
    end
  end  
  
  post '/add_local' => 'processo_judiciais#add_local'
  get '/destroy_penal' => 'processo_judiciais#destroy_penal'
  get '/gerar_ficha' => 'processo_judiciais#gerar_ficha'
  post '/add_local' => 'processo_judiciais#add_local'
  get '/destroy_penal' => 'processo_judiciais#destroy_penal'
  get '/gerar_ficha' => 'processo_judiciais#gerar_ficha'

  resources :inquerito_policiais
  post '/add_infracao_new' => 'inquerito_policiais#add_infracao_new'
  post '/add_infracao_edit' => 'inquerito_policiais#add_infracao_edit'

  resources :documentos
  resources :assistidos

  post '/sincronizar' => 'assistidos#sincronizar'
  post '/update_resumo' => 'assistidos#update_resumo'
  post '/update_dados_pessoais' => 'assistidos#update_dados_pessoais'
  post '/update_situacao' => 'assistidos#update_situacao'
  post '/download' => 'assistidos#download'
  post '/update_socioeconomicas' => 'assistidos#update_socioeconomicas'
  get '/pesquisar_assistidos' => 'assistidos#pesquisar_assistidos'
  get  '/json_autocomplete_assistido' => 'assistidos#json_autocomplete_assistido'
  get  '/json_autocomplete_assistido_notificacao' => 'assistidos#json_autocomplete_assistido_notificacao'
  get '/json_webservice_sejus/:nome_assistido' => 'assistidos#json_webservice_sejus'
  get '/json_webservice_sejus_detalhado/:seq_assistido_sejus' => 'assistidos#json_webservice_sejus_detalhado'

  resources :forca_tarefas

  root 'home#index'

  devise_for  :colaboradores,
              :controllers => { :passwords => "passwords", :sessions => 'sessions' },
              :path => '',
              :path_names => {sign_in: :login, sign_out: :logout}


  devise_for :defensor_sem_fronteiras,
             :controllers => { :passwords => "passwords", sessions: 'sessions' },
             :path => '',
             :path_names => {sign_in: :login, sign_out: :logout}

end
