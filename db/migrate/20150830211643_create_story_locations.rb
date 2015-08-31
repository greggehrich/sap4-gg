class CreateStoryLocations < ActiveRecord::Migration
  def change
    create_table :story_locations do |t|
      t.integer  :story_id
      t.integer  :slocation_id
      t.timestamps
    end
  end
end