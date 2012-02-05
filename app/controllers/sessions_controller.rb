class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    session[:graph_user_id] = auth["uid"]
    session[:access_token]  = auth["credentials"]["token"]
    session[:provider]      = auth["provider"]
    redirect_to "/"
  end

  def destroy
    reset_session
    redirect_to "/"
  end
end
