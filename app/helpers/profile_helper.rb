module ProfileHelper
  def edit_profile_button
    link_to t(:edit_profile), :edit_user, class: 'btn btn-complementary'
  end

  def cancel_edit_profile_button
    link_to t(:cancel), :user, class: 'btn btn-secondary' if current_user.profile_completed?
  end

  def save_edit_profile_button(form)
    form.submit t(:save), class: 'btn btn-complementary mu-edit-profile-btn'
  end

  def show_verified_full_name_notice?(user, organization)
    user.has_verified_full_name? && organization.private?
  end
end
