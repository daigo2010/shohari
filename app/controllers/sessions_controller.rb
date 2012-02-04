class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to "/", :notice => "ログインに成功しました！"
  end

  def destroy
    reset_session
    redirect_to "/", :notice => "ログアウトしました！"
  end
end
