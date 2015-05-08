class ZipCode < ActiveRecord::Base

  validates :postal_code, :fip_id, presence: true
  validates :postal_code, uniqueness: true

  belongs_to :fip

end
