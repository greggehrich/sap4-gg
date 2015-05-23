class CreateMediacorps < ActiveRecord::Migration
  def change
    create_table(:mediacorps) do |t|
      t.string :title, null: false
      t.integer :parent_id
      t.string :name
      t.string :media_type_id
      t.string :distribution_type
      t.string :publication_name
      t.string :paywall_yn
      t.string :content_frequency_time
      t.string :content_frequence_other
      t.string :content_frequency_guide
      t.string :next_issue_yn
    end
    add_index :mediacorps, :parent_id
  end
end