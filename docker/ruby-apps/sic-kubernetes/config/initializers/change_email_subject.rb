if !Rails.env.production?
  class ChangeEmailSubject
    def self.delivering_email(mail)
      mail.from = "sistemas@defensoria.ce.def.br"
      mail.cc = ""
      mail.bcc = ""
      mail.subject = "#{mail.subject} - #{ActionMailer::Base.default_url_options[:domain].upcase}"
      mail.to = "desenvolvimento@defensoria.ce.def.br"
    end
  end
  ActionMailer::Base.register_interceptor(ChangeEmailSubject)
end
