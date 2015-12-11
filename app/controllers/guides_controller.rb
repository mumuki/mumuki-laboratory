class GuidesController < ApplicationController

  before_action :authenticate!, except: [:index, :show]
  before_action :set_guide, only: :show

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
    @guides = paginated Guide.by_full_text(@q)
  end

  private

  def subject
    @guide
  end


  def set_guide
    @guide = Guide.find(params[:id])
  end

  def guide_params
    params.require(:guide).permit(:slug)
  end
end
