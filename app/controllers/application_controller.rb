class ApplicationController < ActionController::Base
  respond_to :html, :json
#  include Pundit
  protect_from_forgery with: :exception
  before_filter :check_registration
  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_filter :set_csrf_cookie_for_ng

  rescue_from Pundit::NotAuthorizedError do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end


  private

  def check_registration
    if current_user && !current_user.valid?
      flash[:warning] = "Please finish your #{view_context.link_to "registration", edit_user_registration_url }  before continuing.".html_safe
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :first_name, :last_name, :roles => []) }
  end
  def verified_request?
    super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end
end
