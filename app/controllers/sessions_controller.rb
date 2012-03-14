class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) 
    if !user then
        User.create_with_omniauth(auth)
        user = User.find_by_uid(auth["uid"])

        # 登録をPOST
        require 'net/https'
        require 'uri'

        post_uri = Shohari::Application.config.fb_base + 
                    auth['info']['nickname'] + 
                    '/feed' 
        uri = URI.parse(post_uri)

        http = Net::HTTP.new(uri.host, uri.port) 
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data({:message => 'ソーシャルなジョハリの窓「ショハリ」に登録しました！ あなたはどれだけ自己評価できていますか？ ショハリでチェックしましょう！', 
                               :access_token => auth["credentials"]["token"]})
        response = http.request(request)
    end

    session[:user_id] = user.id
    session[:graph_user_id] = auth["uid"]
    session[:name] = auth["info"]["name"]
    session[:access_token]  = auth["credentials"]["token"]
    session[:provider]      = auth["provider"]
    
    redirect_to "/"
  end

  def destroy
    reset_session
    redirect_to "/"
  end
end
