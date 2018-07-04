module Mumuki::Laboratory::Controllers::ExerciseSeed
  extend ActiveSupport::Concern

  included do
    before_action :set_seed!
  end

  def set_seed!
    @exercise.seed_with! current_user&.id if @exercise
  end
end
