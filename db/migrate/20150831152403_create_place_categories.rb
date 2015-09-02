class CreatePlaceCategories < ActiveRecord::Migration
  def change
    create_table :splace_categories do |t|
      t.string   :code
      t.string   :name
      t.timestamps
    end
    create_table :story_place_categories, force: true do |t|
      t.integer  :story_id
      t.integer  :splace_category_id
      t.timestamps
    end
  end
end
