mumuki.load(function() {
  let avatarId = "";
  let userImage = "";
  let $avatarPicker = $('#mu-avatar-picker');
  let $userAvatar = $('#mu-user-avatar');

  $("#mu-edit-avatar-icon").on('click', function(){
    $avatarPicker.modal();
  });

  $("#mu-user-form").on('submit', function(){
    if (userImage) {
      setImageUrl($(this), userImage);
      setAvatarId($(this), "");
    }

    if (avatarId) {
      setAvatarId($(this), avatarId);
    }
  });

  $('.mu-avatar-item').on('click', function(){
    $userAvatar.attr('src', $(this).attr('src'));
    $avatarPicker.modal('hide');

    const clickedAvatarId = $(this).attr('mu-avatar-id');
    avatarId = clickedAvatarId || "";
  });

  $('#mu-user-image').on('click', function(){
    userImage = $userAvatar.attr('src');
  });

  function setImageUrl(form, url) {
    form.append(`<input type="hidden" name="user[image_url]" value="${url}"/>`);
  }

  function setAvatarId(form, id) {
    form.append(`<input type="hidden" name="user[avatar_id]" value=${id}/>`);
  }
});
