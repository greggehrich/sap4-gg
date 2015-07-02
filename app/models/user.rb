class User < ActiveRecord::Base

  validates :zip_preference, presence: true
  validates_format_of :zip_preference, :with => /\A\d{5}\z/, :message => "should be in the form 12345"
  # validates_format_of :zip_preference, :with => /^\d{5}$/

  has_many :usersavedstories, dependent: :destroy
  has_many :stories, through: :usersavedstories

  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :associate, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  # TODO: right we are just using all the places associated with a favorited story
  #       i think the goal is to use the usersavedplaces association once that is being used
  def favorite_place_coords
    res = []
    stories.includes(:places => [{:place_categories => :parent}, :location]).each do |s|
      s.places.each do |p|
        next unless p.name.present?
        base_cat = p.get_parent_categories.first ? p.get_parent_categories.first.name : 'other'
        res << {name: p.name, base_category: base_cat, lat: p.location.lat, lng: p.location.lng}
      end
    end
    res
  end

  # def get_zip_code
  #   '92101' # TEMP stubbing this method out
  # end

end
