class CreateNewBridgeTables < ActiveRecord::Migration
  def change
    create_table :story_splace_joins do |t|
      t.integer  :story_id
      t.integer  :splace_category_id
      t.timestamps
    end
    create_table :story_slocation_joins do |t|
      t.integer  :story_id
      t.integer  :slocation_id
      t.timestamps
    end
  end
end