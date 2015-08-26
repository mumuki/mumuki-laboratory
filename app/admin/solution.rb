ActiveAdmin.register Solution do

  filter :status
  filter :submitter
  filter :exercise_language_id, as: :select, collection: proc { Language.all }, label: 'Language'
  filter :exercise_guide_id, as: :select, collection: proc { Guide.all }, label: 'Guide'
  filter :created_at

  index do
    column(:id)
    column(:exercise_title){|sub| sub.exercise.title}
    column(:exercise_guide){|sub| sub.exercise.guide.name if sub.exercise.guide}
    column(:language){|sub| sub.exercise.language.name}
    column(:status)
    column(:submitter_name){|sub| sub.submitter.name}

    actions
  end
end
