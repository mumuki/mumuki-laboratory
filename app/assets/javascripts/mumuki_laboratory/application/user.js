mumuki.load(() => {
  const $userMenuHeader = $('.mu-user-menu-header');

  $userMenuHeader.click(() => {
    $('.mu-user-menu').toggleClass('hidden-sm-screen');
    $('#mu-user-menu-header-icon').toggleClass('fa-chevron-up fa-chevron-down');
  });

  if (document.querySelector('.mu-profile-info') !== null) {
    $userMenuHeader.click();
  }
});
