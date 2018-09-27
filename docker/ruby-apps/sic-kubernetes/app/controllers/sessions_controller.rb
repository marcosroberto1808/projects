class SessionsController < Devise::SessionsController
  include Accessible
  skip_before_action :check_user, only: :destroy

  def create
    self.resource = warden.authenticate(auth_options)
    resource_name = self.resource_name

    if resource.nil?
      resource_name = :defensor_sem_fronteira
      request.params[:defensor_sem_fronteira] = params[:colaborador]

      self.resource = warden.authenticate!(auth_options.merge(scope: :defensor_sem_fronteira))
    end

    sign_in(resource_name, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end
end
