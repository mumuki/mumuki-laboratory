class Lesson < ActiveRecord::Base
  include GuideContainer

  validates_presence_of :number, :chapter

  belongs_to :guide
  belongs_to :chapter #remove me later
  belongs_to :topic
end
