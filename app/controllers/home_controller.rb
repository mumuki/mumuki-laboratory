class HomeController < ApplicationController

  def index
    @languages_icon_urls = Language.pluck(:image_url)
  end
end
