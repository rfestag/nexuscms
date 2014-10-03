class UsersController < ApplicationController
  include Api
  model :user

  def whoami
    u = current_user
    if u
      #TODO: Also include list of what the user can do
      render json: current_user
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
