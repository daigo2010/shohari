class TopController < ApplicationController
    def index
        if session[:user_id] then
            @done_self_check = true if Answer.where('answer_user_id = :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).count > 0
            @done_other_check = true if Answer.where('answer_user_id = :user_id AND target_user_id <> :user_id', :user_id => session[:user_id]).count > 0
            @exists_my_shohari = true if Answer.where('answer_user_id <> :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).count > 0
        else
            redirect_to '/auth/facebook'
        end
    end
end

