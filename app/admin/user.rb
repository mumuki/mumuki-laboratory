ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :last_submission_date
    column :created_at
    column :updated_at
    column :sign_in_count
    column (:submissions_count) {|user| Submission.where(submitter_id: user.id).count}
    column (:exercises_count) {|user| user.exercises.count}
    column (:guides_count) {|user| user.guides.count}
    actions
  end

  filter :name
  filter :email
  filter :created_at
  filter :updated_at
  filter :sign_in_count
  filter :last_submission_date

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
