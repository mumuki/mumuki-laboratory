class CategoriesController < ApplicationController
  def index
    @categories = Category.at_locale
  end
end
