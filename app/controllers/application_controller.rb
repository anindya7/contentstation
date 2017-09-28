class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  layout :layout_by_resource

  def layout_by_resource
    if (devise_controller? && resource_name == :user && action_name != 'edit') ||  
      (controller_path.eql?('devise/passwords') && resource_name == :user)
      "homepages"
    elsif controller_name == 'home' && action_name == 'index'
      "landing"
    else
      "application"
    end
  end

  def check_guest
    if user_signed_in?
      redirect_to products_path
    end
  end

  def after_sign_in_path_for(resource)
    # if resource.admin?
    #   rails_admin_path
    # else
    #   products_path
    # end
    products_path
  end
end
