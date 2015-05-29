class AddTypeToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :type, :string
  end
end
