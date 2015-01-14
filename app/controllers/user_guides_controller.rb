class UserGuidesController < ApplicationController
  include NestedInUser

  def index
    @guides = paginated @user.guides
  end
end
