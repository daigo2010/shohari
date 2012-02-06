class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question
      t.string :location

      t.timestamps

    end
    add_index :questions, :location
  end
end
