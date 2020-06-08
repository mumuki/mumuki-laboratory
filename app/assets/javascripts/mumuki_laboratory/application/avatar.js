mumuki.load(function() {
  let avatar_id = "";

  $("#edit-avatar-icon").on('click', function(){
    $('#avatar-picker').modal();
  });

  $("#user-form").on('submit', function(){
    if (!avatar_id) {
      const image_url = $('#user-avatar').attr('src');
      $(this).append('<input type="hidden" name="user[image_url]" value="' + image_url + '"/>');
    }

    $(this).append('<input type="hidden" name="user[avatar_id]" value="' + avatar_id + '"/>');
  });

  $('.avatar-item').on('click', function(){
    $('#user-avatar').attr('src', $(this).attr('src'));
    $('#avatar-picker').modal('hide');

    const item_avatar = $(this).attr('avatar_id');
    if (item_avatar) {
      avatar_id = item_avatar;
    } else {
      avatar_id = "";
    }
  });
});
