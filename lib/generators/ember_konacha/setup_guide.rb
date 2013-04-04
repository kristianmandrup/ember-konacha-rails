module EmberKonacha
  module SetupGuide
    def guide?
      options[:guide]
    end

    def setup_example
      %Q{#{routes_ex}
#{base_controllers_ex}        
#{users_controller_ex}
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
class EmberController < ActionController::API
end

class AuthEmberController < EmberController
  helper_method :current_user_json

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

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

    def routes_ex
      %q{require 'routing/format_test'
EmberRailsAPI::Application.routes.draw do

  root to: 'application#index',         :constraints => Routing::FormatTest.new(:html)

  resources :users, :except => :edit,   :constraints => Routing::FormatTest.new(:json)
end

# lib/routing/format_test
module Routing
  class FormatTest
    attr_accessor :mime_type

    def initialize(format)
      @mime_type = Mime::Type.lookup_by_extension(format)
    end

    def matches?(request)
      request.format == mime_type
    end
  end
end
}
    end

    def users_controller_ex
%q{class UsersController < EmberController
  def index
    render json: users
  end

  def show
    render json: user
  end

  def destroy
    user.destroy
    render json: user
  end

  def update    
    user.update user_params
    render json: user
  end

  def create
    user.save
    render json: user
  end

  protected

  def new_user
    @new_user ||= User.new user_params
  end

  def users
    User.all.to_a
  end

  def user
    @user ||= User.find user_id
  end

  def user_id
    params[:id]
  end

  def user_params
    params[:user]
  end  
end}  
    end  
  end
end
