class AddIndexUsersavedplaces < ActiveRecord::Migration
  def change
    add_index :usersavedplaces, [:user_id, :usersavedstory_id]
  end
end
