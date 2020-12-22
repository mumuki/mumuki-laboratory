mumuki.load(() => {
  if (JSON.parse($('#mu-uppercase-mode-enabled').val())) {
    $('body').addClass('mu-uppercase');
  }
});
