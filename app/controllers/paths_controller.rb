class PathsController < ApplicationController
  before_action :authenticate!

  def show
    @path = Path.find(params[:id])
  end
end
