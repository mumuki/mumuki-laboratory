class Exercise < ActiveRecord::Base

  has_many :submissions

  validates_presence_of :title, :description
end
