mumuki.load(function() {
  $("#edit-avatar-icon").on('click', function(){
    $('#avatar-picker').modal();
  });

  $('.avatar-item').on('click', function(){
    $('#user-avatar').attr('src', $(this).attr('src'));
    $('#avatar-picker').modal('hide');
  });
});
