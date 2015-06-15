class Location < ActiveRecord::Base

  validates :lat, :lng, presence: true

  has_many :places
  belongs_to :zip_code

  geocoded_by :full_address
  def full_address
    "#{address1}, #{city}, #{state}, #{country}"
  end
  
end
