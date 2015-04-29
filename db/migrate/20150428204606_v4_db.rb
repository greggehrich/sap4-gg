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

    create_table(:stories) do |t|
      t.date :original_published_at
      # research just month and year
      t.integer :original_published_month
      t.integer :original_publish_year
      t.date :sap_published_at
      t.string :editor_tagline
      t.boolean :author_track
      t.boolean :story_ready_for_display
      t.boolean :story_list_complete
      t.boolean :track_original_published_at
      t.boolean :track_original_published_month
      t.boolean :track_original_published_day
      t.decimal :data_entry_time
      t.decimal :data_entry_user_id
      t.integer :media_id
      t.string :status
      t.hstore :aux_data
      t.timestamps
    end

    create_table(:places) do |t|
      t.integer :location_id, null: false
      t.string :email
      t.string :phone
      t.boolean :needs_review
      t.boolean :reported_closed
      t.hstore :aux_data
      t.timestamps
    end
    add_index :places, :location_id

    create_table(:stories_places) do |t|
      t.integer :stories_id, null: false
      t.integer :places_id, null: false
      t.hstore :aux_data
      t.timestamps
    end
    add_index :stories_places, [:stories_id, :places_id], unique: true

    create_table(:stories_story_categories) do |t|
      t.integer :stories_id, null: false
      t.integer :story_categories_id, null: false
      t.timestamps
    end
    add_index :stories_story_categories, [:stories_id, :story_categories_id], unique: true, name: 'idx_stories_story_categories_ids'

    create_table(:story_categories) do |t|
      t.integer :parent_id
      t.string :code
      t.string :name
      t.timestamps
    end
    add_index :story_categories, :parent_id

    create_table(:places_place_categories) do |t|
      t.integer :places_id, null: false
      t.integer :place_categories_id, null: false
      t.timestamps
    end
    add_index :places_place_categories, [:places_id, :place_categories_id], unique: true, name: 'idx_places_place_categories_ids'

    create_table(:place_categories) do |t|
      t.integer :parent_id
      t.string :code
      t.string :name
      t.timestamps
    end
    add_index :place_categories, :parent_id

    create_table(:locations) do |t|
      t.string :lat, null: false
      t.string :lng, null: false
      t.string :name, null: false
      t.integer :parent_id
      t.integer :zip_codes_id
      t.integer :msa_infos_id
      t.integer :fips_id
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :country
      t.timestamps
    end
    add_index :locations, :lat
    add_index :locations, :lng
    add_index :locations, :name
    add_index :locations, :parent_id
    add_index :locations, :zip_codes_id

    create_table(:zip_codes) do |t|
      t.string :fips_id, null: false
      t.string :postal_code, null: false
      t.timestamps
    end
    add_index :zip_codes, :postal_code

    create_table(:fips) do|t|
      t.integer :fips, null: false
      t.string :msa_infos_id, null: false
      t.timestamps
    end
    add_index :fips, :fips
    add_index :fips, :msa_infos_id

    create_table(:msa_infos) do |t|
      t.string :name, null: false
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

    create_table(:authors_stories) do |t|
      t.integer :authors_id, null: false
      t.integer :stories_id, null: false
      t.timestamps
    end
    add_index :authors_stories, [:authors_id, :stories_id], unique: true

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
