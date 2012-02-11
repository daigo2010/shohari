class OtherController < ApplicationController
    def list
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
