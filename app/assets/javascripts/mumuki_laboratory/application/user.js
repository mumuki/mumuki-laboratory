mumuki.load(() => {
  const $userMenuHeader = $('.mu-user-menu-header');
  let onUserProfile = document.querySelector('.mu-profile-info') !== null;

  $userMenuHeader.click(() => {
    $('.mu-user-menu-items').toggleClass('hidden-sm-screen');
    $('#mu-user-menu-header-icon').toggleClass('fa-chevron-up fa-chevron-down');
  });

  if (onUserProfile) {
    $userMenuHeader.click();
  }

  $('.mu-user-menu-item .active').click((e) => {
    if (onUserProfile) {
      e.preventDefault();
      $userMenuHeader.click();
    }
  });
});
