module ProfileHelper
  def edit_profile_button
    link_to t(:edit_profile), :edit_user, class: 'btn btn-complementary'
  end

  def cancel_edit_profile_button
    link_to t(:cancel), :user, class: 'btn btn-secondary' if current_user.profile_completed?
  end

  def save_edit_profile_button(form)
    form.submit t(:save), disabled: true, class: 'btn btn-complementary mu-edit-profile-btn'
  end
end
