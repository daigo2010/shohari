class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:provider, :uid]
  end
end
