mumuki.load(function() {
  let $userForm = $("#mu-user-form");
  let $editButton = $('#mu-edit-profile-btn');
  let $userAvatar = $('#mu-user-avatar');
  let $avatarItem = $('.mu-avatar-item');

  let originalData = $userForm.serialize();
  let originalProfilePicture = $userAvatar.attr('src');

  $avatarItem.on('click', function() {
    if (avatarChanged()) {
      $editButton.prop('disabled', false);
    } else {
      $editButton.prop('disabled', true);
    }
  });

  $userForm.on('change keyup', function() {
    if ($userForm.serialize() != originalData) {
      $editButton.prop('disabled', false);
    } else {
      $editButton.prop('disabled', true);
    }
  });

  function avatarChanged() {
    return ($userAvatar.attr('src') != originalProfilePicture);
  }
});
