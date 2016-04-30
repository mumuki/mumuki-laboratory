class Lesson < ActiveRecord::Base
  include GuideContainer

  validates_presence_of :number

  belongs_to :guide
  belongs_to :topic
end
