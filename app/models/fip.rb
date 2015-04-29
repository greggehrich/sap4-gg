class Fip < ActiveRecord::Base

  validates :msa_info, presence: true

  belongs_to :msa_info

  has_many :zip_codes

end
