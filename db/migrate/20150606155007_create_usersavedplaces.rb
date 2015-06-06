class CreateUsersavedplaces < ActiveRecord::Migration
  def change
    create_table :usersavedplaces do |t|
      t.integer :user_id
      t.integer :usersavedstory_id
      t.integer :place_id
      t.timestamps
    end
  end
end
