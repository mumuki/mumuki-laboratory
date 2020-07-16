mumuki.load(function() {
  let $userForm = $("#mu-user-form");
  let $editButton = $('#mu-edit-profile-btn');
  let $userAvatar = $('#mu-user-avatar');
  let $avatarItem = $('.mu-avatar-item');

  let originalData = $userForm.serialize();
  let originalProfilePicture = $userAvatar.attr('src');

  $avatarItem.on('click', function() {
    toggleEditButtonIf(avatarChanged());
  });

  $userForm.on('change keyup', function() {
    toggleEditButtonIf(dataChanged());
  });

  function toggleEditButtonIf(criteria) {
    if (criteria) {
      $editButton.prop('disabled', false);
    } else {
      $editButton.prop('disabled', true);
    }
  }

  function avatarChanged() {
    return ($userAvatar.attr('src') != originalProfilePicture);
  }

  function dataChanged() {
    return $userForm.serialize() != originalData;
  }
});
