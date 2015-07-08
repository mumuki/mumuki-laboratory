class Category < ActiveRecord::Base
  include WithLocale
  include WithMarkup

  has_many :paths

  validates_presence_of :name, :description, :image_url

  markup_on :description
end
