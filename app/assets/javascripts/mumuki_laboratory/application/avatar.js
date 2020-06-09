mumuki.load(function() {
  let avatarId = "";

  $("#edit-avatar-icon").on('click', function(){
    $('#avatar-picker').modal();
  });

  $("#user-form").on('submit', function(){
    if (!avatarId) {
      const imageUrl = $('#user-avatar').attr('src');
      $(this).append(`<input type="hidden" name="user[image_url]" value="${imageUrl}"/>`);
    }

    $(this).append(`<input type="hidden" name="user[avatar_id]" value="${avatarId}"/>`);
  });

  $('.avatar-item').on('click', function(){
    $('#user-avatar').attr('src', $(this).attr('src'));
    $('#avatar-picker').modal('hide');

    const clickedAvatarId = $(this).attr('avatar_id');
    if (clickedAvatarId) {
      avatarId = clickedAvatarId;
    } else {
      avatarId = "";
    }
  });
});
