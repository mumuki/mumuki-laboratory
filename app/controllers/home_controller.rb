class HomeController < ApplicationController

  def index
    @categories = Category.all
  end
end
