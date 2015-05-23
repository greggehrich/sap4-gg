class DropMediastable < ActiveRecord::Migration
  def change
    drop_table :medias
  end
end