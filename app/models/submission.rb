class Submission < ActiveRecord::Base

  belongs_to :exercise
  validates_presence_of :exercise
end
