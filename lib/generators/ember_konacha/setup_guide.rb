module EmberKonacha
  module SetupGuide
    def guide?
      options[:guide]
    end

    def setup_example
      %Q{#{routes_ex}
#{base_controllers_ex}
}
    end

    def routes_ex
      %q{
# Using 'sweet_routing' gem API

EmberRailsAPI::Application.routes.draw do

  app_root 'application#index'
  
  json_resource :users, :except => :edit
end
}
    end    

    def base_controllers_ex
      %q{
# Only for root page 
class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
  end
end

# Base class for all REST API controllers used with Ember
class APIController < ActionController::API
end

# Authorization controller
class AuthController < APIController
  helper_method :current_user_json

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  # Perhaps check out ActiveSerializer CanCan
  def current_user_json
    if current_user
      UserSerializer.new(current_user, :scope => current_user, :root => false).to_json
    else
      {}.to_json
    end
  end
end
}
    end
  end
end
