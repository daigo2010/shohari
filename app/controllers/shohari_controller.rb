class ShohariController < ApplicationController
    caches_action :showme, :expires_in => 5.minutes
    def showme
        self_awareness  = Answer.where('answer_user_id = :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).
                                 select('question_id')
        other_awareness = Answer.where('answer_user_id <> :user_id AND target_user_id = :user_id', :user_id => session[:user_id]).
                                 select('question_id').
                                 group('question_id')
        @open_self    = Hash.new
        @bind_self    = Hash.new
        @hidden_self  = Hash.new
        @unknown_self = Hash.new
        exist_flgs    = Hash.new
        @exist        = false;

        self_awareness.each do |s|
            other_awareness.each do |o|
                if s.question_id == o.question_id then
                    @open_self[s.question_id] = s.question.question
                    exist_flgs[s.question_id] = true
                    @exist = true;
                end
            end
            if exist_flgs[s.question_id] != true then
                @hidden_self[s.question_id] = s.question.question
                exist_flgs[s.question_id] = true
            end
        end

        other_awareness.each do |o|
            if exist_flgs[o.question_id] != true then
                @bind_self[o.question_id] = o.question.question
                exist_flgs[o.question_id] = true
                @exist = true;
            end
        end

        if @exist then
            unknown_awareness = Question.where('location = :location', :location => 'jp')
            unknown_awareness.each do |u|
                @unknown_self[u.id] = u.question
            end
            exist_flgs.each_pair do |user_id, exist_flg|
                @unknown_self.delete(user_id)
            end
        end
    end
end
