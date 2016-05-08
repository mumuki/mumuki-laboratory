class ComplementsController < ApplicationController

  before_action :set_complement, only: :show

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
    @complement
  end

  def set_complement
    @complement = Complement.find(params[:id])
    @guide = @complement.guide
  end
end
