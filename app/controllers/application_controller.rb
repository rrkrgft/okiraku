class ApplicationController < ActionController::Base
  require "openai"
  require 'dotenv'
  Dotenv.load

  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to main_app.root_path, alert: '画面を閲覧する権限がありません。'}
    end
  end
  
  private
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  
  def set_common_variable
    @client = OpenAI::Client.new(access_token: ENV["CHATGPT_API_KEY"])
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
