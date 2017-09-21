class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    # if resource.admin?
    #   rails_admin_path
    # else
    #   products_path
    # end
    products_path
  end
end
