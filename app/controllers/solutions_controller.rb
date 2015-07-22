class SolutionsController < ApplicationController
  include NestedInUser

  before_action :authenticate!
  def index
    @solutions = paginated @user.solutions.order(updated_at: :desc), 50
  end
end
