class Mediacorp < ActiveRecord::Base

  validates :title, presence: true

  has_many :stories # TODO: or is it has_one ?

end