class AuthorStoryAssignment < ActiveRecord::Base

  validates :author, :story, presence: true
  validates :author, uniqueness: {scope: :story}

  belongs_to :author
  belongs_to :story

end
