class DropTableStoryPlaceCategory < ActiveRecord::Migration
  def change
    drop_table :story_place_categories
  end
end
