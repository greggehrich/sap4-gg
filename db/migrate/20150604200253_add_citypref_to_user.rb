class AddCityprefToUser < ActiveRecord::Migration
  def change
    add_column :users, :city_preference, :string
  end
end
