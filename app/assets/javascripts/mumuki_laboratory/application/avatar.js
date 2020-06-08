mumuki.load(function() {

  var avatar_id = $(this).attr('avatar_id');

  $("#edit-avatar-icon").on('click', function(){
    $('#avatar-picker').modal();
  });

  $("#user-form").on('submit', function(){
    $(this).append('<input type="hidden" name="user[avatar_id]" value="'+ avatar_id + '"/>');
  });

  $('.avatar-item').on('click', function(){
    $('#user-avatar').attr('src', $(this).attr('src'));
    $('#avatar-picker').modal('hide');

    avatar_id = $(this).attr('avatar_id');
  });
});
