class CategoriesController < ApplicationController
  def index
    @categories = Category.at_locale.order(:position)
  end
end
