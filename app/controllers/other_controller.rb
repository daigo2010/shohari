# encoding: utf-8
class OtherController < ApplicationController
    def list
        require 'json'
        friend_list = JSON.parse(@friend_list)
        @friends = Array.new
        friend_list['data'].each do |f|
            res = User.where('uid = :uid', :uid => f['id'])
            next if !res
            res.each do |r|
                @friends.push({:user_id => r.id, :name => r.name, :id => f['id']})
            end
        end
    end

    def check 
        @quest = Question.where("location = :location", :location => "jp")
        @answer = Answer.where("answer_user_id = :answer_user_id AND target_user_id = :target_user_id", :answer_user_id => session[:user_id], :target_user_id => params[:user_id])
        @user_id = params[:user_id]
        @uid = params[:uid]
        @uname = params[:uname]
    end

    def post
        redirect_to '/other/check?user_id=' + params[:user_id] + 'uid=' + params[:uid] + '&uname=' + params[:uname]  if Shohari::Application.config.maxCount < params['nowCount'].to_i

        Answer.transaction do
            Answer.destroy_all(['answer_user_id = :answer_user_id AND target_user_id = :target_user_id', {:answer_user_id => session[:user_id], :target_user_id => params[:user_id]}])

            @quest = Question.where("location = :location", :location => "jp")
            @quest.each do |q|
                key = q.id.to_s
                if params["question_" + q.id.to_s] then
                    @answer = Answer.new
                    @answer.answer_user_id = session[:user_id]
                    @answer.target_user_id = params[:user_id]
                    @answer.question_id    = q.id
                    @answer.save
                end
            end
        end
        redirect_to :controller => 'top'
    end
end
