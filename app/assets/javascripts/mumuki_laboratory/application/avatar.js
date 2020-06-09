mumuki.load(function() {
  let avatarId = "";
  let $avatarPicker = $('#avatar-picker');
  let $userAvatar = $('#user-avatar');

  $("#edit-avatar-icon").on('click', function(){
    $avatarPicker.modal();
  });

  $("#user-form").on('submit', function(){
    if (!avatarId) {
      const imageUrl = $userAvatar.attr('src');
      $(this).append(`<input type="hidden" name="user[image_url]" value="${imageUrl}"/>`);
    }

    $(this).append(`<input type="hidden" name="user[avatar_id]" value="${avatarId}"/>`);
  });

  $('.avatar-item').on('click', function(){
    $userAvatar.attr('src', $(this).attr('src'));
    $avatarPicker.modal('hide');

    const clickedAvatarId = $(this).attr('avatar_id');
    avatarId = clickedAvatarId || "";
  });
});
