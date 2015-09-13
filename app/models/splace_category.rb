class SplaceCategory < ActiveRecord::Base

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :story_splace_joins, dependent: :destroy
  has_many :stories, through: :story_splace_joins

end