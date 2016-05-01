class Complement < ActiveRecord::Base
  include GuideContainer

  validates_presence_of :book

  belongs_to :guide
  belongs_to :book
end
