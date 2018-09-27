class ApplicationController < ActionController::Base
  #validações customizadas compartilhadas
  require "validacao"

  include ApplicationHelper

  #Aplica restrições de acesso do cancancan
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  #cancan user
  def current_user
    if current_colaborador
      current_colaborador
    else
      current_defensor_sem_fronteira
    end
  end

  #cancancan configs
  check_authorization :unless => :devise_controller?
  load_and_authorize_resource unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    if colaborador_signed_in? or defensor_sem_fronteira_signed_in?
      redirect_to :back, :alert => "Você não tem autorização para executar esta ação."
    else
      redirect_to :new_colaborador_session
    end
  end

  def enhancement_ilike(field, term)
    "TRANSLATE(#{field}, 'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ', 'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC') ilike TRANSLATE('%#{term}%', 'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ', 'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC')"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:pessoa_fisica_cpf, :ativo, :password) }
  end
end
