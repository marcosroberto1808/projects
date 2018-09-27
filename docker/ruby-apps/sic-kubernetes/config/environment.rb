# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Sic::Application.initialize!

PATH_DOCS_SIC = '/home/defensoria/sistemas/repositorios/repositorio_sic'
UNIDADE_EXERCICIO = ['NUAPP', 'Núcleo de Execuções Penais - NUDEP']
FUNCTIONS_ALL = ['Defensor Público', 'Operador SIC']
API_SEJUS = 'http://172.24.21.2:8082/pesquisa/preso/'
API_SEJUS_USERNAME = 'defensoria'
API_SEJUS_PASSWORD = '6D?^pu8JSP7[}:tM'
if Rails.env.development?
  URL_SIC = "localhost:3000"
elsif Rails.env.homolog?
  URL_SIC = "hg.sic.defensoria.ce.def.br"
elsif Rails.env.production?
  URL_SIC = "sic.defensoria.ce.def.br"
elsif Rails.env.stage?
  URL_SIC = "stage.sic.defensoria.ce.def.br"
end
