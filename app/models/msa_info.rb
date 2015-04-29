class MsaInfo < ActiveRecord::Base

  validates :name, presence: true

  has_many :fips

end
