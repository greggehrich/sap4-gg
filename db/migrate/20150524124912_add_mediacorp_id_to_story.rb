class AddMediacorpIdToStory < ActiveRecord::Migration
  def change
    add_column :stories, :mediacorp_id, :integer
  end
end
