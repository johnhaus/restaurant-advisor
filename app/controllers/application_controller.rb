class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  include Pundit

  after_action :verify_authorized, except: [:index, :top, :show], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: [:index, :top, :show], unless: :skip_pundit?


  # before_action :configure_permitted_parameters, if: :devise_controller?

  # def configure_permitted_parameters
  #   update_attrs = [:password, :password_confirmation, :current_password]
  #   devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  # end

  private

  def skip_pundit?
    devise_controller?
  end
end
