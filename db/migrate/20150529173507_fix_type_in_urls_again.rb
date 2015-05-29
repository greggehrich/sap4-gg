class FixTypeInUrlsAgain < ActiveRecord::Migration
  def change
    rename_column :urls, :urls_type, :url_type
  end
end
