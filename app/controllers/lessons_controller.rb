class LessonsController < ApplicationController

  before_action :set_lesson, only: :show

  def show
    if current_user?
      @stats = @guide.stats_for(current_user)
      @next_exercise = @guide.next_exercise(current_user)
    else
      @next_exercise = @guide.first_exercise
    end
  end

  def index
    @q = params[:q]
    @lessons = paginated Lesson.by_full_text(@q)
  end

  private

  def subject
    @lesson
  end

  def set_lesson
    @lesson = Lesson.find(params[:id])
    @guide = @lesson.guide
  end

  def guide_params
    params.require(:guide).permit(:slug)
  end
end
