class AddYearToStories < ActiveRecord::Migration
  def change
    add_column :stories, :original_published_date, :string
  end
end
