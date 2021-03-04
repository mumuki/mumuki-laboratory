mumuki.load(() => {
  $('.mu-user-menu-header').click(() => {
    $('.mu-user-menu').toggleClass('hidden-sm-screen');
    $('#mu-user-menu-header-icon').toggleClass('fa-chevron-up fa-chevron-down');
  });
});
