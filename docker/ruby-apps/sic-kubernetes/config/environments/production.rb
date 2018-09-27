Sic::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_mailer.default_options = { from: "sistemas@defensoria.ce.def.br" }


  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'sic.defensoria.ce.def.br', domain: 'PRODUCAO' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address:              '192.168.0.6',
      port:                 25,
      domain:               'mail.defensoria.ce.def.br',
      openssl_verify_mode:  'none'
  }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.middleware.use ExceptionNotification::Rack,
                        :email => {
                            :deliver_with => :deliver, # Rails >= 4.2.1 do not need this option since it defaults to :deliver_now
                            :email_prefix => "[SIC ERRO] ",
                            :sender_address => %{<sistemas@defensoria.ce.def.br>},
                            :exception_recipients => %w{desenvolvimento@defensoria.ce.def.br}
                        }

  Rails.application.middleware.use ConciseLogging::LogMiddleware
  ConciseLogging::LogSubscriber.attach_to :action_controller

  config.log_level = :debug
  config.log_tags = ["cv-#{Rails.env[0]}"]
  config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(File.join(Rails.root, "log", "#{Rails.env}.log")))
end
