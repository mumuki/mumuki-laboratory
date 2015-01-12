class UserGuidesController < ApplicationController
  include NestedInUser

  def index
    @guides = paginated @user.guides
    render 'guides/index'
  end
end
