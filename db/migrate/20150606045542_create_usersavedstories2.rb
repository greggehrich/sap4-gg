class CreateUsersavedstories2 < ActiveRecord::Migration
  def change
    create_table :usersavedstories do |t|
      t.integer :story_id
      t.integer :user_id
    end
  end
end
