module Mumuki::Laboratory::Controllers::ExerciseSeed
  extend ActiveSupport::Concern

  included do
    before_action :set_seed!
  end

  def set_seed!
    if @exercise && current_user
      @assignment = @exercise.assignment_for current_user
      @assignment.seed_with! current_user.id
    end
  end
end
