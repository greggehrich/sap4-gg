require 'domainatrix'
require 'screen_scraper'

class StoriesController < ApplicationController
  before_action :set_story, only: [:edit, :update, :destroy]
  # before_action :set_story, only: [:show, :edit, :update, :destroy]

  def start

  end

  # GET /stories/new
  def new
    # parse the domain
    # @data_entry_begin_time = params[:data_entry_begin_time]
    @source_url_pre = params[:source_url_pre]  #grab user input
    if @source_url_pre.present?
      get_locations_and_categories
      get_domain_info(@source_url_pre)
      @screen_scraper = ScreenScraper.new
      if @screen_scraper.scrape!(@full_web_url)
        @story = Story.new
        @image = @story.images.build
        @image_url = @image.build_url 
        @story_url = @story.urls.build

        # url = @story.urls.build
        # url.images.build
        set_scrape_fields
        # binding.pry
      else
        flash.now.alert = "We can't find that URL – give it another shot"
        render :scrape
      end
    else
      flash.now.alert = "You have to enter a URL for this to work"
      render :scrape
    end
  end

  # POST /stories
  # POST /stories.json
  def create
    # TODO:  check_manual_url(params)
    # binding.pry
    # @story = Story.new(story_params)
    my_params = set_image_params(story_params)
    @story = Story.new(my_params)

    respond_to do |format|
      if @story.save
        update_locations_and_categories(@story, story_params)
        format.html { redirect_to story_path(@story), notice: 'Story was successfully created.' }
        # format.html { redirect_to story_proof_url(@story), notice: 'Story was successfully created.' }
        format.json { render :show, status: :created, location: @story }
      else
        @source_url_pre = params["story"]["urls_attributes"]["0"]["full_url"]
        get_domain_info(@source_url_pre)
        set_fields_on_fail(story_params)
        get_locations_and_categories
        format.html { render :new }
        format.json { render json: @story.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    page = params[:page] ? params[:page] : 1
    @stories = Story.paginate(per_page: 50, page: page).order('created_at DESC')
    # @stories = Story.ready_for_display.paginate(per_page: 50, page: page).order('created_at DESC')
    @stories = @stories.where(["title ILIKE ?", "%#{params[:search]}%"]) if params[:search]

  end

  # this show will eventually go away
  def show
    @story = Story.find(params[:id])
    # @story = Story.where(ready_for_display: true).find(params[:id])
    @places = @story.places

    if user_signed_in?
      @saved_story_count = Usersavedstory.where(story_id: @story.id, user_id: current_user.id.to_i).count
      # binding.pry
    end

  end

  def edit
    @story = Story.find(params[:id])
  end

  def update
    if @story.update(story_params)
        redirect_to story_path
    else
      render :edit
    end
  end


  def save_story_show
    if user_signed_in?
      user_saved_story = Usersavedstory.new
      user_saved_story.user_id = current_user.id.to_i
      user_saved_story.story_id = params[:id].to_i

      user_saved_story_success = true if user_saved_story.save

      @story = Story.find(params[:id])
      @places_for_this_story = @story.places
      @places_for_this_story.each do |story_places|
        user_saved_place = Usersavedplace.new
        user_saved_place.user_id = current_user.id.to_i
        user_saved_place.usersavedstory_id = Usersavedstory.last.id
        user_saved_place.place_id = story_places.id
        user_saved_place.save
        # binding.pry
      end

      # if user_saved_story_success
      #   render json: {success: true}
      # else
      #   render json: {success: false}
      # end

    redirect_to :back
    # redirect_to '/stories/' + params[:id].to_s
    end
  end

  def forget_story_show
    if user_signed_in?

      user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
      user_saved_story.destroy

      redirect_to :back
      # redirect_to '/stories/' + params[:id].to_s
    end
  end

  def story_places_list
    @story = Story.where(ready_for_display: true).find(params[:id])

  end

  def story_places_map
    @story = Story.where(ready_for_display: true).find(params[:id])
    @places = @story.places

    # the hash holds all the markers for the map
    @hash = Gmaps4rails.build_markers(@places) do |place, marker|
      marker.lat place.location.lat
      marker.lng place.location.lng
      name = place.name.present? ? place.name : ''
      marker.infowindow '<a class="iwlayout" href=' + place_path(place) + '>' + name + '</a>'
    end

  end

  private

  def get_domain_info(source_url_pre)

    full_url = Domainatrix.parse(source_url_pre).url
    sub = Domainatrix.parse(source_url_pre).subdomain
    domain = Domainatrix.parse(source_url_pre).domain
    suffix = Domainatrix.parse(source_url_pre).public_suffix
    prefix = (sub == 'www' || sub == '' ? '' : (sub + '.'))
    @base_domain = prefix + domain + '.' + suffix
    # binding.pry

    # d_url = Domainatrix.parse(source_url_pre)
    # @full_domain = d_url.host
    # split_full_domain = @full_domain.split(".")
    # if split_full_domain.length == 2
    #   @base_domain = split_full_domain[0].to_s + "." + split_full_domain[1].to_s
    # else
    #   @base_domain = split_full_domain[1].to_s + "." + split_full_domain[2].to_s
    # end

    # if Mediaowner.where(url_domain: @base_domain).first.present?
    #   @name_display =  Mediaowner.where(url_domain: @base_domain).first.title
    # else
    #   @name_display = 'NO DOMAIN NAME FOUND'
    # end
    @full_web_url = full_url
  end

  def set_scrape_fields
    @title = @screen_scraper.title
    @meta_desc = @screen_scraper.meta_desc
    @meta_keywords = @screen_scraper.meta_keywords
    @meta_type = @screen_scraper.meta_type
    @meta_author = @screen_scraper.meta_author
    @year = @screen_scraper.year
    @month = @screen_scraper.month
    @day = @screen_scraper.day
    @page_imgs = @screen_scraper.page_imgs

    @itemprop_pub_date_match

  end

  def set_fields_on_fail(hash)
    @title = hash['title']['0']
    @meta_desc = hash['description']
    @meta_keywords = hash['urls_attributes']['0']['keywords']
    @meta_tagline = hash["editor_tagline"]
    # @meta_type = hash["story_type"]
    # @meta_author = hash["author"]
    @year = hash["original_published_year"]
    @month = hash["original_published_month"]
    @day = hash["original_published_date"]
    @page_imgs = []
    params['image_src_cache'].try(:each) do |key, src_url|  # in case hidden field hash is nil, added try
      @page_imgs << { 'src_url' => src_url, 'alt_text' => params['image_alt_text_cache'][key] }
    end
    @selected_slocation_ids = process_chosen_params(hash['slocation_ids'])
    @selected_splace_category_ids = process_chosen_params(hash['splace_category_ids'])
    @selected_story_category_ids = process_chosen_params(hash['story_category_ids'])
    # binding.pry
  end

  def set_image_params(story_params)
    image_data = params["story"]["images_attributes"]["0"]["image_data"]
    # image_data = params["story"]["image"]["image_data"]
    # image_data = story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_data"]
    unless image_data.nil?
      image_data_hash = JSON.parse(image_data)
      @image_url = image_data_hash["src_url"]
      # story_params["urls_attributes"]["0"]["images_attributes"]["0"]["alt_text"]= image_data_hash["alt_text"]
      story_params["images_attributes"]["0"]["image_size_h"] = image_data_hash["image_width"]
      # story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_width"] = image_data_hash["image_width"]
      story_params["images_attributes"]["0"]["image_size_v"] = image_data_hash["image_height"]
      # story_params["urls_attributes"]["0"]["images_attributes"]["0"]["image_height"]= image_data_hash["image_height"]
    end
    story_params
    # binding.pry
  end

  def get_locations_and_categories
    @slocations = Slocation.order(:name)
    @splace_categories = SplaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def update_locations_and_categories(story, my_params)
    new_slocations = Slocation.find(process_chosen_params(my_params[:slocation_ids]))
    story.slocations = new_slocations

    new_splace_categories = SplaceCategory.find(process_chosen_params(my_params[:splace_category_ids]))
    story.splace_categories = new_splace_categories

    new_story_categories = StoryCategory.find(process_chosen_params(my_params[:story_category_ids]))
    story.story_categories = new_story_categories
  end

  def process_chosen_params(my_params)
    if my_params.present?
      my_params.reject{|p| p.empty?}.map{|p| p.to_i}
    end
  end

  # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def story_params
      params.require(:story).permit( :title, :description, :editor_tagline,
              :original_published_year, :original_published_month, :original_published_date,
              :story_slocation_join_ids => [],
              :story_splace_join_ids => [],
              :story_category_ids => [],
              :slocation_ids => [],
              :splace_category_ids => [],
              :story_category_ids => [],
              slocations_attributes: [ :id, :code, :name ],
              splace_categories_attributes: [ :id, :code, :name ],
              story_categories_attributes: [ :id, :code, :name ],
              urls_attributes: [ :id, :full_url, :domain, :keywords],
              places_attributes: [ :id, :name, :email, :phone, :needs_review, :reported_closed, :_destroy,
                     location_attributes: [ :id, :address1, :city, :state, :country, :lat, :lng ]],
              images_attributes: [ :id, :image_size_h, :image_size_v, :image_type, :_destroy, :manual_url,
                    url_attributes: [ :id, :image_data, :full_url ]],
              mediacorp_attributes: [ :id, :title ],
              authors_attributes: [ :id, :display_name ])
    end

end
