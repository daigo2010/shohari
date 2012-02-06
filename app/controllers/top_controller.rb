class TopController < ApplicationController
    def index
        if session[:user_id] then
            require 'net/https'
            require 'uri'

            friend_list_uri = Shohari::Application.config.fb_friend_uri
            uri = URI.parse(friend_list_uri + session[:access_token])

            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            response = http.request(Net::HTTP::Get.new(uri.request_uri))
        else
            redirect_to '/auth/facebook'
        end
    end
end

