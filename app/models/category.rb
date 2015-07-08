class Category < ActiveRecord::Base
  include WithLocale
  include WithMarkup

  has_many :paths

  validates_presence_of :name, :description, :image_url

  markup_on :description

  def single_path?
    paths.size == 1
  end

  def single_path
    paths.first
  end
end
