class VisitorsController < ApplicationController

  def index
    @stories = Story.where(ready_for_display: true).order("id DESC").first(21)
    # @stories = Story.order("id DESC").all.includes(:urls)
  end
end
