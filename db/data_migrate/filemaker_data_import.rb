require 'csv'
class FilemakerDataImport

  STORY_CATEGORIES_MEMO = {}
  PLACE_CATEGORIES_MEMO = {}
  STORIES_MEMO = {}
  LOCATIONS_MEMO = {}
  PLACES_MEMO = {}

  PLACES_WITHOUT_LOCATION = []

  def self.run!
    fr = "#{Rails.root.to_s}/db/data_imports/"
    place_category_assignments_csv = "#{fr}/Categories\ in\ a\ Place.xlsx\ -\ Sheet1.csv"
    place_categories_csv = "#{fr}/Category\ \&\ Subcategory\ List.xlsx\ -\ Sheet1.csv"
    places_csv = "#{fr}/places.csv"
    stories_places_csv = "#{fr}/STORIES_PLACES.xlsx\ -\ Sheet1.csv"
    stories_csv = "#{fr}/stories.csv"
    story_categories_csv = "#{fr}/story_categories.csv"
    urls_csv = "#{fr}/URLS-A.xlsx\ -\ Sheet1.csv"
    url_places_assignments = "#{fr}/URLs\ in\ Places.xlsx\ -\ Sheet1.csv"
    locations_csv = "#{fr}/LOCATIONS.xlsx\ -\ Sheet1.csv"

    # LOCATIONS
    puts "\n\n\n\n\nIMPORTING LOCATIONS DATA..."
    CSV.foreach(locations_csv, {headers: true}) do |row|
      find_or_create_location(row)
    end

    # PLACES
    puts "\n\n\n\n\nIMPORTING PLACES DATA..."
    CSV.foreach(places_csv, {headers: true}) do |row|
      find_or_create_place(row)
    end

    # ROOT PLACE CATEGOIRES
    puts "\n\n\n\n\nIMPORTING PLACE CATEGORIES DATA..."
    root_place_cats = []
    CSV.foreach(place_categories_csv, {headers: true}) do |row|
      root_place_cats << row[1] unless root_place_cats.include?(row[1])
    end
    root_place_cats.each{ |cat| PlaceCategory.create!(name: cat) }

    # PLACE CATEGORIES
    CSV.foreach(place_categories_csv, {headers: true}) do |row|
      find_or_create_place_cat(row)
    end

    # STORIES
    puts "\n\n\n\n\nIMPORTING STORIES DATA..."
    CSV.foreach(stories_csv, {headers: true}) do |row|
      find_or_create_story(row)
    end

    # STORY_CATEGORIES
    puts "\n\n\n\n\nIMPORTING STORY CATEGORIES DATA..."
    CSV.foreach(story_categories_csv, {headers: true}) do |row|
      find_or_create_story_cat(row)
    end

    # TODO: first import urls, then update the places and stories fields for name/title and description
    # # URLS
    # CSV.foreach(urls_csv, {headers: true}) do |row|
    #   find_or_create_url(row)
    # end

    # TODO: assign places to stories

    # TODO: assigns urls to places or stories

    # TODO: assign stories to story_categories

    # TODO: assign places to place_categories

  end

  private

  def self.find_or_create_location(row)
    aux_data = {}
    legacy_location_id = row[0]
    needs_review = row[1] == 'Yes'
    address_from_web = row[2]
    city = row[3]
    state_province = row[4]
    postal_code = row[5]
    country = row[6]
    lat = row[7]
    lng = row[8]
    street_num = row[9]
    street = row[10]
    zip_code = ZipCode.where(postal_code: postal_code).first
    aux_data[:web_address] = address_from_web
    my_atts = {
      zip_code_id: zip_code ? zip_code.id : nil,
      needs_review: needs_review,
      address1: street_num.to_s + ' ' + street.to_s,
      city: city,
      state: state_province,
      country: country,
      lat: lat,
      lng: lng
    }
    l = Location.where(my_atts).first
    l = l ? l : Location.create!(my_atts.merge(aux_data: aux_data))
    LOCATIONS_MEMO[legacy_location_id.to_i] = l.id
  end

  def self.find_or_create_place(row)
    aux_data = {}
    legacy_location_id = row[0]
    legacy_place_id = row[1]
    needs_review = (row[2] == 'Yes')
    aux_data[:reported_closed] = (row[3] == 'Yes')
    aux_data[:no_url_title] = (row[4] == 'Yes')
    multiple_location_unique_name = row[5]
    legacy_parent_id = row[6]
    aux_data[:place_tags] = row[7]
    phone = row[8]
    email = row[9]
    location_id = LOCATIONS_MEMO[legacy_location_id.to_i]
    my_atts = {location_id: location_id, email: email, phone: phone, needs_review: needs_review}
    if location_id
      p = Place.where(my_atts).first
      p = p ? p : Place.create!(my_atts.merge(aux_data: aux_data))
      PLACES_MEMO[legacy_place_id.to_i] = {id: p.id, parent_name: multiple_location_unique_name}
    else
      PLACES_WITHOUT_LOCATION << my_atts.merge(aux_data).merge(legacy_place_id: legacy_place_id)
    end
  end

  def self.find_or_create_story(row)
    aux_data = {}
    legacy_story_id = row[0]
    legacy_url_id = row[1]
    ready_for_display = row[2] == 'Yes' ? true : false
    list_complete = row[3] == 'Yes' ? true : false
    date_to_review = row[4]
    aux_data[:media_series] = row[5]
    aux_data[:alt_title] = row[6]
    aux_data[:alt_description] = row[7]
    orig_pub_year = row[8]
    orig_pub_month = row[9]
    orig_pub_day = row[10]
    aux_data[:tv_season] = row[11]
    aux_data[:tv_episode_number] = row[12]
    aux_data[:tv_episode_sequence] = row[13]
    aux_data[:tv_episode_title] = row[14]
    aux_data[:tv_episode_airdate] = "#{row[15]}-#{row[16]}-#{row[17]}"
    aux_data[:note] = row[18]
    aux_data[:recurring_event_number] = row[19]
    my_atts = {
      ready_for_display: ready_for_display,
      list_complete: list_complete
    }
    if orig_pub_year.present? && orig_pub_month.present? && orig_pub_day.present?
      my_atts[:original_published_at] = "#{orig_pub_year}-#{orig_pub_month}-#{orig_pub_day}"
    else
      my_atts[:original_published_year] = orig_pub_year
      my_atts[:original_published_month] = orig_pub_month
    end
    # NOTE: we do not have enough data to check if the story exists yet
    # s = Story.where(my_atts).first
    s = Story.create!(my_atts.merge(aux_data: aux_data))
    STORIES_MEMO[legacy_story_id.to_i] = {id: s.id, legacy_url_id: legacy_url_id.to_i}
  end

  def self.find_or_create_story_cat(row)
    legacy_id = row[0]
    code = row[1]
    name = row[2]
    sc = StoryCategory.where(name: name, code: code).first_or_create!
    STORY_CATEGORIES_MEMO[legacy_id.to_i] = sc.id
  end

  def self.find_or_create_place_cat(row)
    legacy_id = row[0]
    parent_cat_name = row[1]
    name = row[2]
    description = row[3]
    parent_pc = PlaceCategory.where(name: parent_cat_name, parent_id: nil).first
    pc = PlaceCategory.where(parent_id: parent_pc.id, name: name, description: description).first_or_create!
    PLACE_CATEGORIES_MEMO[legacy_id.to_i] = pc.id
  end

end
