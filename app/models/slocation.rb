class Slocation < ActiveRecord::Base

  validates :code, presence: true
  validates :code, uniqueness: true

  has_many :story_slocation_joins, dependent: :destroy
  has_many :stories, through: :story_slocation_joins

end