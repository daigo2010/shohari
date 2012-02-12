class ShohariController < ApplicationController
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
        bind_tmp      = Hash.new

        self_awareness.each do |s|
            open_self_flg = false
            other_awareness.each do |o|
                if s.question_id == o.question_id then
                    @open_self[s.question_id] = s.question.question
                    open_self_flg = true
                    bind_tmp[s.question_id] = true
                end
            end
            if open_self_flg == false then
                @hidden_self[s.question_id] = s.question.question
                bind_tmp[s.question_id] = true
            end
        end

        other_awareness.each do |o|
            empty_flg = true
            bind_tmp.each_pair do |user_id, exist_flg|
                if !exist_flg then
                    empty_flg = false
                    break
                end
            end
            if empty_flg then
                @bind_self[o.question_id] = o.question.question
                bind_tmp[o.question_id] = true
            end
        end

        unknown_awareness = Question.where('location = :location', :location => 'jp')
        unknown_awareness.each do |u|
            @unknown_self[u.id] = u.question
        end
        bind_tmp.each_pair do |user_id, exist_flg|
            @unknown_self.delete(user_id)
        end
    end
end
