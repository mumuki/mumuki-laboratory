class Exam < ActiveRecord::Base
  validates_presence_of :duration

  belongs_to :guide
  belongs_to :organization
end
