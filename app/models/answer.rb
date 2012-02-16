class Answer < ActiveRecord::Base
    belongs_to :question
    validates :answer_user_id, :target_user_id, :question_id,
        :presence => true,
        :numericality => {:only_integer => true}
end
