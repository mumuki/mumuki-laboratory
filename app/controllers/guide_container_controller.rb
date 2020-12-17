class GuideContainerController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content

  before_action :set_guide

  def show
    @stats = subject.stats_for(current_user)
    @next_exercise = subject.next_exercise(current_user)
  end

  private

  def set_guide
    @guide = subject.guide
  end
end
