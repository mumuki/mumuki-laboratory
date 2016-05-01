class Lesson < ActiveRecord::Base
  validates_presence_of :guide, :number, :chapter

  belongs_to :chapter #remove me later
  belongs_to :topic
  belongs_to :guide

end
