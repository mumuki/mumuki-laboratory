module ProfileHelper
  def edit_profile_button
    link_to t(:edit_profile), edit_user_path, class: 'btn btn-success mu-profile-action'
  end
end
