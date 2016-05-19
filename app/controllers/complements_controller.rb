class ComplementsController < ApplicationController

  before_action :set_guide

  def show
    if current_user?
      @stats = @guide.stats_for(current_user)
      @next_exercise = @guide.next_exercise(current_user)
    else
      @next_exercise = @guide.first_exercise
    end
  end

  private

  def set_guide
    @guide = subject.guide
  end
end
