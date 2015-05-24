class RemoveMediaIdFromStory < ActiveRecord::Migration
  def change
    remove_column :stories, :media_id, :integer
  end
end
