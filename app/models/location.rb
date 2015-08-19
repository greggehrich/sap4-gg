class Location < ActiveRecord::Base

  validates :lat, :lng, presence: true

  validates :address1, :presence => { :message => "STREET ADDRESS is required" }
  validates :city, :presence => { :message => "CITY is required" }
  validates :state, :presence => { :message => "STATE is required" }
  validates :country, :presence => { :message => "COUNTRY is required" }

  has_many :places
  belongs_to :zip_code

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng

  def self.nearby_places(area_text, distance = 50)
    res = []
    Location.near(area_text, distance).includes(:places => {:place_categories => :parent}).each do |l|
      l.places.each do |p|
        next unless p.name.present?
        base_cat = p.get_parent_categories.first ? p.get_parent_categories.first.name : 'other'
        res << {name: p.name, base_category: base_cat, place_url: '/places/' + p.id.to_s, lat: p.location.lat, lng: p.location.lng}
      end
    end
    res
  end

  def full_address
    [address1, city, state, country].compact.join(', ')
  end
  after_validation :geocode

  # reverse_geocoded_by :lat, :lng
  # after_validation :reverse_geocode

end
