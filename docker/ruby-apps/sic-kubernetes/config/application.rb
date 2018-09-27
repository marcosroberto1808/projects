require File.expand_path('../boot', __FILE__)

require 'rails/all'
Bundler.require(:default, Rails.env)

module Sic
  class Application < Rails::Application
		#Configuração iFrame#
		config.action_dispatch.default_headers = {
				'X-Frame-Options' => 'ALLOWALL'
		}
		
		# Add fonts path
		config.assets.paths << "#{Rails.root}/app/assets/fonts"

		# Precompile additional assets
		config.assets.precompile += %w( .svg .eot .woff .ttf ) 

		#Timezone / Linguagem
		config.time_zone = 'America/Fortaleza'
		I18n.enforce_available_locales = false
    	config.i18n.default_locale = 'pt-BR'

		#Correção problema de wrapper do field_with_error nos forms
	  config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
	  	"<span class='field_with_errors'>#{html_tag}</span>".html_safe 
	  }
  end
end


