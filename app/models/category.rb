class Category < ActiveRecord::Base

  include WithLocale

  has_many :starting_points

  validates_presence_of :name, :description, :image_url
end
