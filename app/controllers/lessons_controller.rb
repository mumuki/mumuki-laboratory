class LessonsController < ApplicationController

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

  def subject
    @lesson ||= Lesson.find_by(id: params[:id])
  end

  def set_guide
    @guide = @lesson.guide
  end

  def guide_params
    params.require(:guide).permit(:slug)
  end
end
