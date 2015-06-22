class ChangefieldsInLocation < ActiveRecord::Migration
  def change
    change_column :locations, :lat, 'float USING CAST(lat AS float)'
    change_column :locations, :lng, 'float USING CAST(lng AS float)'
  end
end
