class HomeController < ApplicationController

  def index
    @languages = Language.all
  end
end
