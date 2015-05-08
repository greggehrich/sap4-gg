class Url < ActiveRecord::Base

  validates :urlable_type, :urlable_id, :full_url, presence: true
  validates :urlable_type, uniqueness: {scope: [:urlable_id, :full_url]}

  belongs_to :urlable, polymorphic: true

end
