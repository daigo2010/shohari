class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
        t.integer :answer_user_id
        t.integer :target_user_id
        t.integer :question_id
      t.timestamps
    end
    add_index :answers, :answer_user_id
    add_index :answers, :target_user_id
  end
end
