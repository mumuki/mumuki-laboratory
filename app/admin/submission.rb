ActiveAdmin.register Submission do

  filter :status
  filter :submitter
  filter :exercise_language_id, as: :select, collection: proc { Language.all }, label: 'Language'
  filter :created_at

  index do
    column(:id)
    column(:exercise_title){|sub| sub.exercise.title}
    column(:language){|sub| sub.exercise.language.name}
    column(:status)
    column(:submitter_name){|sub| sub.submitter.name}

    actions
  end
end