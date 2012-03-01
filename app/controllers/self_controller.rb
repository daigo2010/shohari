class SelfController < ApplicationController
    def check 
        @quest = Question.where("location = :location", :location => "jp")
        @answer = Answer.where("answer_user_id = :user_id AND target_user_id = :user_id", :user_id => session[:user_id])
        @uid = session[:graph_user_id]
        @uname = session[:name]
    end

    def post
        redirect_to '/self/check' if Shohari::Application.config.maxCount < params['nowCount'].to_i
        Answer.destroy_all(['answer_user_id = :user_id AND target_user_id = :user_id', {:user_id => session[:user_id]}])
        @quest = Question.where("location = :location", :location => "jp")
        Answer.transaction do
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
        end
        redirect_to :controller => 'top'
    end
end
