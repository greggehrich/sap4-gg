class Location < ActiveRecord::Base

  validates :lat, :lng, presence: true

  has_many :places

  belongs_to :zip_code

end
