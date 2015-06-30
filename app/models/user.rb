class User < ActiveRecord::Base
  has_many :usersavedstories
  has_many :stories, through: :usersavedstories

  # devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  enum role: [:user, :associate, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def favorite_place_coords
    res = []
    stories.includes(:places => [{:place_categories => :parent}, :location]).each do |s|
      s.places.each do |p|
        next unless p.name.present?
        base_cat = p.get_parent_categories.first.name ? p.get_parent_categories.first.name : 'other'
        res << {name: p.name, base_category: base_cat, lat: p.location.lat, lng: p.location.lng}
      end
    end
    res
  end

  def get_zip_code
    '92101' # TEMP stubbing this method out
  end

end
