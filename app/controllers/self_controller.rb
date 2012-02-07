class SelfController < ApplicationController
    def check 
        @quest = Question.where("location = :location", :location => "jp")    
    end

    def post
        @answer = Answer.new
    end
end
