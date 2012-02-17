class TopController < ApplicationController
    def index
        if session[:user_id] then
            @done_self_check = true if Answer.where('answer_user_id = :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).count > 0
            @done_other_check = true if Answer.where('answer_user_id = :user_id AND target_user_id <> :user_id', :user_id => session[:user_id]).count > 0
            @exists_my_shohari = true if Answer.where('answer_user_id <> :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).count > 0
            
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
        else
            redirect_to '/auth/facebook'
        end
    end
end

