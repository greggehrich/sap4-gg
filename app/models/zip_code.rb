class ZipCode < ActiveRecord::Base

  validates :postal_code, presence: true

  belongs_to :fip

end
