class ReleaseQueue < ActiveRecord::Base

  self.table_name = 'release_queue'

  validates :ordinal, :story, presence: true

  belongs_to :story

end
