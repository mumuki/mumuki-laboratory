ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column (:submissions_count) {|user| Submission.where(submitter_id: user.id).count}
    column (:exercises_count) {|user| user.exercises.count}
    column (:guides_count) {|user| user.guides.count}
    actions
  end

  filter :name
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
