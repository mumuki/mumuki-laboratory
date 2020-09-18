mumuki.load(function() {
  let $userForm = $("#mu-user-form");
  let $userAvatar = $('#mu-user-avatar');
  let $editButton = $('#mu-edit-profile-btn');
  let $avatarPicker = $('#mu-avatar-picker');
  let $avatarItem = $('.mu-avatar-item');

  let userImage = "";
  let avatarId = "";

  let originalData = $userForm.serialize();
  let originalProfilePicture = $userAvatar.attr('src');

  $userForm.on('change keyup', function() {
    toggleEditButtonIfThereAreChanges();
  });

  $avatarItem.on('click', function() {
    $userAvatar.attr('src', $(this).attr('src'));
    $avatarPicker.modal('hide');

    const clickedAvatarId = $(this).attr('mu-avatar-id');
    avatarId = clickedAvatarId || "";

    toggleEditButtonIfThereAreChanges();
  });

  function toggleEditButtonIfThereAreChanges() {
    let shouldEnable = requiredFieldsAreFilled() && (dataChanged() || avatarChanged());

    $editButton.prop('disabled', !shouldEnable);
  }

  const requiredFieldsAreFilled = () =>
    $userForm.find('select, textarea, input').toArray().every(elem => {
      const $elem = $(elem);
      return !($elem.prop('required')) || !!$elem.val();
    });

  const dataChanged = () => $userForm.serialize() !== originalData;

  const avatarChanged = () => $userAvatar.attr('src') !== originalProfilePicture;

  $('#mu-user-image').on('click', function(){
    userImage = $userAvatar.attr('src');
  });

  $userForm.on('submit', function(){
    if (userImage) {
      setImageUrl($(this), userImage);
      setAvatarId($(this), "");
    }

    if (avatarId) {
      setAvatarId($(this), avatarId);
    }
  });

  function setImageUrl(form, url) {
    form.append(`<input type="hidden" name="user[image_url]" value="${url}"/>`);
  }

  function setAvatarId(form, id) {
    form.append(`<input type="hidden" name="user[avatar_id]" value=${id}/>`);
  }

  $("#mu-edit-avatar-icon").on('keypress click', function(e) {
    if (isEnterOrSpacePress(e) || e.type === 'click') {
      $avatarPicker.modal();
    }
  });

  function isEnterOrSpacePress(press) {
    return press.which === 13 || press.which === 32;
  }
});
