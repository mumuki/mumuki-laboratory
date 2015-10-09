class PathsController < ApplicationController
  before_action :authenticate!

  def show
    @path = Path.find(params[:id])
  end

  def subject
    @path
  end
end
