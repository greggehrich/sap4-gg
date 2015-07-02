class AddZipprefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :zip_preference, :string
  end
end
