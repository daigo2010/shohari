class OtherController < ApplicationController
    def list
        require 'net/https'
        require 'uri'
        friend_list_uri = Shohari::Application.config.fb_friend_uri
        uri = URI.parse(friend_list_uri + session[:access_token])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        response = http.request(Net::HTTP::Get.new(uri.request_uri))

        require 'json'
        friend_list = JSON.parse(response.body)
        @friends = Array.new
        friend_list['data'].each do |f|
            res = User.where('uid = :uid', :uid => f['id'])
            next if !res
            res.each do |r|
                @friends.push({:uid => r.uid, :name => r.name})
            end
        end
    end

    def check 
        @quest = Question.where("location = :location", :location => "jp")
        @answer = Answer.where("answer_user_id = :user_id AND target_user_id = :user_id", :user_id => session[:user_id])
    end

    def post
        Answer.destroy_all(['answer_user_id = :user_id AND target_user_id = :user_id', {:user_id => session[:user_id]}])
        @quest = Question.where("location = :location", :location => "jp")
        @quest.each do |q|
            key = q.id.to_s
            if params["question_" + q.id.to_s] then
                @answer = Answer.new
                @answer.answer_user_id = session[:user_id]
                @answer.target_user_id = session[:user_id]
                @answer.question_id    = q.id
                @answer.save
            end
        end
        redirect_to :controller => 'top'
    end
end
