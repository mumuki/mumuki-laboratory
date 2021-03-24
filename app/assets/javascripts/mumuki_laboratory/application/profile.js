mumuki.load(function() {
  let $userForm = $("#mu-user-form");
  let $userAvatar = $('#mu-user-avatar');
  let $editButton = $('.mu-edit-profile-btn');
  let $avatarPicker = $('#mu-avatar-picker');
  let $avatarItem = $('.mu-avatar-item:not(.mu-locked)');

  let userImage = "";
  let avatarId = "";
  let avatarType = "";

  let originalData = $userForm.serialize();
  let originalProfilePicture = $userAvatar.attr('src');

  $userForm.on('change keyup', function() {
    toggleEditButtonIfThereAreChanges();
  });

  $avatarItem.on('keypress click', function(e) {
    onClickOrSpacebarOrEnter($(this), e, function() {
      $userAvatar.attr('src', $(this).attr('src'));
      $avatarPicker.modal('hide');

      const clickedAvatarId = $(this).attr('mu-avatar-id');
      const clickedAvatarType = $(this).attr('type');
      avatarId = clickedAvatarId || "";
      avatarType = clickedAvatarType || "";

      toggleEditButtonIfThereAreChanges();
    });
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

  $('#mu-user-image').on('keypress click', function(e){
    onClickOrSpacebarOrEnter($(this), e, function() {
      userImage = $userAvatar.attr('src');
    });
  });

  $userForm.on('submit', function(){
    if (userImage) {
      setImageUrl($(this), userImage);
      setAvatarIdAndType($(this), "", "");
    }

    if (avatarId) {
      setAvatarIdAndType($(this), avatarId, avatarType);
    }
  });

  function setImageUrl(form, url) {
    form.append(`<input type="hidden" name="user[image_url]" value="${url}"/>`);
  }

  function setAvatarIdAndType(form, id, type) {
    form.append(`<input type="hidden" name="user[avatar_id]" value="${id}"/>`);
    form.append(`<input type="hidden" name="user[avatar_type]" value="${type}"/>`);
  }

  function onClickOrSpacebarOrEnter(element, e, func) {
    if (e.which === 13 || e.which === 32 || e.type === 'click') {
      func.apply(element);
    }
  }
});
