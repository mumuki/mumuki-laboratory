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
  var hash = document.location.hash;
  if (hash) {
    $(".nav-tabs a[data-target='" + hash + "']").tab('show');
  }
  $('a[data-toggle="tab"]').on('show.bs.tab', function (e) {
    window.location.hash = $(e.target).attr('data-target');
  });

  mumuki.user.load()
});
