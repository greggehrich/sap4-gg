class CreateSlocations < ActiveRecord::Migration
  def change
    create_table :slocations do |t|
      t.string   :code
      t.string   :name
      t.timestamps
    end
  end
end

