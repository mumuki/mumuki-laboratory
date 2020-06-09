mumuki.load(function() {
  let avatarId = "";
  let $avatarPicker = $('#mu-avatar-picker');
  let $userAvatar = $('#mu-user-avatar');

  $("#mu-edit-avatar-icon").on('click', function(){
    $avatarPicker.modal();
  });

  $("#mu-user-form").on('submit', function(){
    if (!avatarId) {
      const imageUrl = $userAvatar.attr('src');
      $(this).append(`<input type="hidden" name="user[image_url]" value="${imageUrl}"/>`);
    }

    $(this).append(`<input type="hidden" name="user[avatar_id]" value="${avatarId}"/>`);
  });

  $('.mu-avatar-item').on('click', function(){
    $userAvatar.attr('src', $(this).attr('src'));
    $avatarPicker.modal('hide');

    const clickedAvatarId = $(this).attr('mu-avatar-id');
    avatarId = clickedAvatarId || "";
  });
});
