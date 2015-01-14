class DashboardController < ApplicationController

  def show
    redirect_to controller: 'submissions', action: 'index'
  end
end
