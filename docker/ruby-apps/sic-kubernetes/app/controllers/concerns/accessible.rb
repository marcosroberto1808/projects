module Accessible
  extend ActiveSupport::Concern
  included do
    before_action :check_user
  end

  protected
  def check_user
    if current_colaborador
      flash.clear
      redirect_to(root_path) && return
    elsif current_defensor_sem_fronteira
      flash.clear
      redirect_to(root_path) && return
    end
  end
end
