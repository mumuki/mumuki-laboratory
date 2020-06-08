mumuki.load(function() {
  $("#edit-avatar-icon").on('click', function(){
    $('#avatar-picker').modal();
  });

  $('.avatar-item').on('click', function(){
    $('#user-avatar').attr('src', $(this).attr('src'));
    $('#avatar-picker').modal('hide');

    const avatar_id = $(this).attr('avatar_id');
    $('#user-form').append('<input type="hidden" name="user[avatar_id]" value="'+ avatar_id + '"/>');
  });
});
