 mumuki.user = {

  /**
   * The current user's id
   *
   * @type {number?}
   * */
  _id: null,

  /**
   * The current user's id
   *
   * @type {number?}
   * */
  get id() {
    return this._id;
  },

  /**
   * Set global current user information
   */
  load() {
    const $muUserId = $('#mu-user-id');
    if ($muUserId.length) {
      this._id = $muUserId.val();
    } else {
      this._id = null;
    }
  }
};

mumuki.load(() => {
  const $userMenuHeader = $('.mu-user-menu-header');
  let onUserProfile = document.querySelector('.mu-profile-info') !== null;

  $userMenuHeader.click(() => {
    $('.mu-user-menu-items').toggleClass('mu-hidden-sm-screen');
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

  mumuki.user.load()
});
