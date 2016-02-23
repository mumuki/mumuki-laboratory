class Lesson < ActiveRecord::Base
  validates_presence_of :guide, :number, :chapter

  belongs_to :guide
  belongs_to :chapter

end
