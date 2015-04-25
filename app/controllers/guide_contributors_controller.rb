class GuideContributorsController < ApplicationController
  include NestedInGuide

  def index
    @contributors = paginated @guide.contributors
  end
end
