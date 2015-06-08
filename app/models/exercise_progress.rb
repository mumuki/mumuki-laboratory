class ExerciseProgress < ActiveRecord::Base
  belongs_to :user
  belongs_to :exercise
  belongs_to :last_submission, class_name: 'Submission'
end
