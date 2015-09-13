class StorySplaceJoin < ActiveRecord::Base
  validates :story_id, :splace_category_id, presence: true

  belongs_to :story
  belongs_to :splace_category
end
