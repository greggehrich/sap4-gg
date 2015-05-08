class V4Db < ActiveRecord::Migration
  def change

    enable_extension "hstore"

    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name
      t.string :last_name

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.timestamps
    end
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true

    create_table(:urls) do |t|
      t.string :urlable_type, null: false
      t.integer :urlable_id, null: false
      t.string :full_url, null: false
      t.string :domain
      t.string :category
      t.string :title
      t.string :description
      t.boolean :needs_review
      t.boolean :hold
      t.boolean :archive, default: false
      t.text :keywords, array: true, default: []
      t.integer :legacy_url_id
      t.timestamps
    end
    add_index :urls, :urlable_id, unique: true
    add_index :urls, :urlable_type

    create_table(:story_screen_scrape) do |t|
      t.string :url
      t.string :title
      t.string :description
      t.text :keywords, array: true, default: []
      t.string :published_at_year
      t.string :published_at_month
      t.string :published_at_day
      t.string :author
      t.timestamps
    end

    create_table(:place_screen_scrape) do |t|
      t.string :url
      t.string :name
      t.string :description
      t.text :keywords, array: true, default: []
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state_province
      t.string :zip_code
      t.string :country
      t.string :email
      t.string :phone
      t.timestamps
    end

    create_table(:stories) do |t|
      t.integer :story_screen_scrape_id
      t.date :original_published_at
      t.string :original_published_month
      t.string :original_published_year
      t.date :needs_review_at
      t.string :title
      t.text :description
      t.date :sap_published_at
      t.string :editor_tagline
      t.boolean :ready_for_display
      t.boolean :list_complete
      t.decimal :data_entry_time
      t.decimal :data_entry_user_id
      t.integer :media_id
      t.string :status
      t.hstore :aux_data
      t.timestamps
    end

    create_table(:places) do |t|
      t.integer :place_screen_scrape_id
      t.integer :location_id, null: false
      t.string :name
      t.text :description
      t.string :email
      t.string :phone
      t.boolean :needs_review
      t.boolean :reported_closed
      t.hstore :aux_data
      t.timestamps
    end
    add_index :places, :location_id

    create_table(:story_place_assignments) do |t|
      t.integer :story_id, null: false
      t.integer :place_id, null: false
      t.hstore :aux_data
      t.timestamps
    end
    add_index :story_place_assignments, [:story_id, :place_id], unique: true, name: 'idx_story_place_assignment_ids'

    create_table(:story_category_assignments) do |t|
      t.integer :story_id, null: false
      t.integer :story_category_id, null: false
      t.timestamps
    end
    add_index :story_category_assignments, [:story_id, :story_category_id], unique: true, name: 'idx_story_category_assignment_ids'

    create_table(:story_categories) do |t|
      t.integer :parent_id
      t.string :code
      t.string :name
      t.text :description
      t.timestamps
    end
    add_index :story_categories, :parent_id

    create_table(:place_category_assignments) do |t|
      t.integer :place_id, null: false
      t.integer :place_category_id, null: false
      t.timestamps
    end
    add_index :place_category_assignments, [:place_id, :place_category_id], unique: true, name: 'idx_place_category_assignment_ids'

    create_table(:place_categories) do |t|
      t.integer :parent_id
      t.string :code
      t.string :name
      t.text :description
      t.timestamps
    end
    add_index :place_categories, :parent_id

    create_table(:locations) do |t|
      t.boolean :needs_review
      t.string :lat, null: false
      t.string :lng, null: false
      t.integer :parent_id
      t.integer :zip_code_id
      t.integer :msa_info_id
      t.integer :fip_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.hstore :aux_data
      t.timestamps
    end
    add_index :locations, :lat
    add_index :locations, :lng
    add_index :locations, :name
    add_index :locations, :parent_id
    add_index :locations, :zip_code_id

    create_table(:zip_codes) do |t|
      t.string :fip_id, null: false
      t.string :postal_code, null: false
      t.hstore :aux_data
      t.timestamps
    end
    add_index :zip_codes, :postal_code

    create_table(:fips) do|t|
      t.integer :external_fip_id, null: false
      t.string :msa_info_id, null: false
      t.hstore :aux_data
      t.timestamps
    end
    add_index :fips, :external_fip_id
    add_index :fips, :msa_info_id

    create_table(:msa_infos) do |t|
      t.string :name, null: false
      t.string :description
      t.timestamps
    end
    add_index :msa_infos, :name

    create_table(:authors) do |t|
      t.string :email
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.timestamps
    end

    create_table(:author_story_assignments) do |t|
      t.integer :author_id, null: false
      t.integer :story_id, null: false
      t.timestamps
    end
    add_index :author_story_assignments, [:author_id, :story_id], unique: true

    create_table(:medias) do |t|
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
    add_index :medias, :parent_id

    create_table(:media_types) do |t|
      t.string :name, null: false
    end

    create_table(:images) do |t|
      t.string :image_type, null: false
      t.string :image_size_h
      t.string :image_size_v
      t.string :source, default: 'scraped'
    end
    add_index :images, :image_type

    create_table(:release_queue) do |t|
      t.integer :ordinal, null: false
      t.integer :story_id, null: false
    end

  end
end
