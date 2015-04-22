ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  collection_action :notify_non_active, method: :post do
    User.inactive.each { |user| UserMailer.motivation_email(user).deliver_later }
    redirect_to collection_path, notice: 'Non active users notified'
  end

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    column :email
    column (:submissions_count) {|user| Submission.where(submitter_id: user.id).count}
    column (:exercises_count) {|user| user.exercises.count}
    column (:guides_count) {|user| user.guides.count}
    actions
  end

  action_item :notify_non_active_users do
    link_to 'Send email to non active users', notify_non_active_admin_users_path, method: :post
  end

  filter :name
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at
  filter :email

  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
