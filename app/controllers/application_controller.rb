class ApplicationController < ActionController::Base
    protect_from_forgery

    helper_method :current_user
    before_filter :session_check, :except => 'create'

    private
    def current_user
        if session['user_id'] then
            begin
                @current_user ||= User.find(session[:user_id]) if session[:user_id]
            rescue
                reset_session
                redirect_to '/auth/facebook'
                return
            end
        end
    end
    def session_check
        if session[:access_token] then
            require 'net/https'
            require 'uri'
            friend_list_uri = Shohari::Application.config.fb_friend_uri
            uri = URI.parse(friend_list_uri + session[:access_token])
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = http.request(Net::HTTP::Get.new(uri.request_uri))
            if response.code != "200" then
                reset_session
                redirect_to '/auth/facebook'
                return
            end
            @friend_list = response.body
        else
            reset_session
            return
        end
    end
end
