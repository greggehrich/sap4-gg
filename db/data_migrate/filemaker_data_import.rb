require 'csv'
class FilemakerDataImport

  STORY_CATEGORIES_MEMO = {}
  PLACE_CATEGORIES_MEMO = {}
  STORIES_MEMO = {}
  URL_STORY_ASSIGNMENTS_MEMO = {}
  LOCATIONS_MEMO = {}
  PLACES_MEMO = {}
  URL_PLACE_ASSIGNMENTS_MEMO = {}
  URLS_MEMO = {}

  PLACES_WITHOUT_LOCATION = []

  def self.run!
    fr = "#{Rails.root.to_s}/db/data_imports/"
    place_category_assignments_csv = "#{fr}/place_category_assignments.csv"
    place_categories_csv = "#{fr}/place_categories.csv"
    places_csv = "#{fr}/places.csv"
    stories_places_csv = "#{fr}/story_place_assignments.csv"
    stories_csv = "#{fr}/stories.csv"
    story_categories_csv = "#{fr}/story_categories.csv"
    urls_csv = "#{fr}/urls.csv"
    url_place_assignments_csv = "#{fr}/url_place_assignments.csv"
    locations_csv = "#{fr}/locations.csv"

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

    # URLS
    puts "\n\n\n\n\nIMPORTING URLS DATA..."
    # first store url place-assignments in memory (url story-assignments have already been stored)
    CSV.foreach(url_place_assignments_csv, {headers: true}) do |row|
      legacy_place_id = row[0]
      legacy_url_id = row[1]
      URL_PLACE_ASSIGNMENTS_MEMO[legacy_url_id.to_i] = legacy_place_id.to_i
    end
    # now create urls
    CSV.foreach(urls_csv, {headers: true}) do |row|
      find_or_create_url(row)
    end

    # TODO: assign places to stories

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
      if multiple_location_unqiue_name.present?
        parent_place = Place.where(name: multiple_location_unique_name, location_id: 0).first_or_create!
        my_atts.merge!(parent_id: parent_place.id) if parent_place
      end
      p = Place.where(my_atts).first
      p = p ? p : Place.create!(my_atts.merge(aux_data: aux_data))
      PLACES_MEMO[legacy_place_id.to_i] = p.id
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
    STORIES_MEMO[legacy_story_id.to_i] = s.id
    URL_STORY_ASSIGNMENTS_MEMO[legacy_url_id.to_i] = s.id
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

  def self.find_or_create_url(row)
    legacy_url_id = row[0]
    urlable_type = row[1]
    if urlable_type == 'PLACES'
      urlable_type = 'Place'
    elsif urlable_type == 'STORIES'
      urlable_type = 'Story'
    end
    needs_review = (row[2] == 'Yes')
    full_url = row[3]
    url_domain = row[4]
    legacy_category = row[5]
    url_title = row[6]
    url_desc = row[7]
    url_keywords = row[8]
    urlable_id = nil
    if urlable_type == 'Place'
      urlable_id = PLACES_MEMO[URL_PLACE_ASSIGNMENTS_MEMO[legacy_url_id.to_i]]
    elsif urlable_type == 'Story'
      urlable_id = URL_STORY_ASSIGNEMNTS_MEMO[legacy_url_id.to_i]
    end
    aux_data = {
      legacy_url_id: legacy_url_id.to_i,
      legacy_category: legacy_category
    }
    my_atts = {
      urlable_type: urlable_type,
      urlable_id: urlable_id,
      full_url: full_url,
      needs_review: needs_review,
      domain: url_domain
    }
    u = Url.where(my_atts).first
    u = u ? u : Url.create!(my_atts.merge(aux_data: aux_data))
    URLS_MEMO[legacy_url_id.to_i] = u.id
    # now... update the appropriate place or story with title/name and description data
    if u.urlable_type == 'Place'
      place = u.urlable
      place.update_attributes({name: url_title, description: url_desc})
    elsif u.urlable_type == 'Story'
      story = u.urlable
      story.update_attributes({title: url_title, description: url_desc})
    end
  end

end
