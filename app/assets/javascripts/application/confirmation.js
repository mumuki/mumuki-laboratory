$(document).on('ready page:load', function () {
  $('.btn-confirmation').on('click change', function (evt) {
    $.ajax({
      method: 'POST',
      url: $(this).data('confirmation-url')
    });
    return true;
  });
});

