class Category < ActiveRecord::Base

  include WithLocale

  has_many :paths

  validates_presence_of :name, :description, :image_url
end
