class Exam < ActiveRecord::Base
  belongs_to :guide
  belongs_to :organization
end
