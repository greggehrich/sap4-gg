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
    stories.includes(:places => :location).each do |s|
      s.places.each do |p|
        res << {name: p.name, lat: p.location.lat, lng: p.location.lng}
      end
    end
    res
  end

end
