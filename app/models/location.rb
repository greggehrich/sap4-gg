class Location < ActiveRecord::Base

  validates :lat, :lng, presence: true

  has_many :places
  belongs_to :zip_code

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng

  def self.nearby_places(area_text, distance = 50)
    res = []
    Location.near(area_text, distance).includes(:places).each do |l|
      l.places.each do |p|
        res << {name: p.name, lat: l.lat, lng: l.lng}
      end
    end
    res
  end

  def full_address
    [address1, city, state, country].compact.join(', ')
  end
  after_validation :geocode

  reverse_geocoded_by :lat, :lng
  after_validation :reverse_geocode

end
