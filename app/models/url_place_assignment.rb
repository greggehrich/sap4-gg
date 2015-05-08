class UrlPlaceAssignment < ActiveRecord::Base

  belongs_to :urlable, polymorphic: true
  belongs_to :places

end
