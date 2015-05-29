class FixTypeInUrls < ActiveRecord::Migration
  def change
    rename_column :urls, :type, :urls_type
  end
end
