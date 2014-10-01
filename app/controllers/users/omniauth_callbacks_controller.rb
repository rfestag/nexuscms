class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    identity = Identity.from_omniauth(request.env["omniauth.auth"])
    @user = identity.find_or_create_user(current_user)
    session["devise.facebook_data"] = request.env["omniauth.auth"].except("extra")
    puts "User: #{@user.inspect}"

    if @user.valid?
      flash.notice = "Signed in!"
      sign_in_and_redirect @user, :event => :authentication
      puts "Current: #{current_user}"
    else
      sign_in @user
      puts "ECurrent: #{current_user}"
      redirect_to edit_user_registration_url
      puts "ECurrent2: #{current_user}"
    end
  end

  alias_method :facebook, :all
  alias_method :twitter, :all
end
