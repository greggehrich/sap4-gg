class Author < ActiveRecord::Base

  # TODO: no validations ?!

  has_many :author_story_assignments, dependent: :destroy
  has_many :stories, through: :author_story_assignments

end
