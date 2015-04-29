class Url < ActiveRecord::Base

  validates :urlable_type, :urlable_id, :full_url, presence: true

  belongs_to :urlable, polymorphic: true

end
