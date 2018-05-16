mumuki.load(function () {
  var $discussions = $('.discussions > .discussion');
  var $iconsDisplayMore = $discussions.find('.discussion-display-more > a > i');

  $iconsDisplayMore.click(function () {
    $(this).toggleClass( "fa-caret-down fa-caret-left");
    var $discussion = $(this).parents('.discussion');
    $discussion.children('.discussion-body').toggle();
  });

  var $newDiscussionModal = $('.new-discussion-modal');

  var $newDiscussion = $('#discussion-create');

  $newDiscussion.click(function () {
    $newDiscussionModal.modal({
      backdrop: 'static',
      keyboard: false
    });
  })

});
