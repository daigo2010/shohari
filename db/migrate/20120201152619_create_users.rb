class CreateUsers < ActiveRecord::Migration
  def change
    drop_table :users
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :screen_name
      t.string :email

      t.timestamps
    end
  end
end
