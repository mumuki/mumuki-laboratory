ActiveAdmin.register Submission do

  filter :status
  filter :submitter
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:exercise_title){|sub| sub.exercise.title}
    column(:status)
    column(:submitter_name){|sub| sub.submitter.name}

    actions
  end
end
