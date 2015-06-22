class Location < ActiveRecord::Base

  validates :lat, :lng, presence: true

  has_many :places
  belongs_to :zip_code

  geocoded_by :full_address, :latitude  => :lat, :longitude => :lng
  def full_address
    [address1, city, state, country].compact.join(', ')
  end
  after_validation :geocode

  reverse_geocoded_by :lat, :lng
  after_validation :reverse_geocode

end
