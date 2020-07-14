mumuki.load(function() {
  let $userForm = $("#mu-user-form");
  let $editButton = $('#mu-edit-profile-btn');
  let originalData = $userForm.serialize();

  $userForm.on('change keyup', function() {
    if ($userForm.serialize() != originalData) {
      $editButton.prop('disabled', false);
    } else {
      $editButton.prop('disabled', true);
    }
  });
});
