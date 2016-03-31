class Comment < ActiveRecord::Base

  belongs_to :assignment, foreign_key: :submission_id

end
