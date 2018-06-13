var mumuki = mumuki || {};

mumuki.load(function () {
  var $newDiscussionModal = $('.new-discussion-modal');
  var $newDiscussion = $('#discussion-create');

  $newDiscussion.click(function () {
    $newDiscussionModal.modal({
      backdrop: 'static',
      keyboard: false
    });
  });

  var $suscriptionButton = $('.discussion-subscription');
  var $suscriptionSpans = $suscriptionButton.children('span');

  var Forum = {
    toggleSpans: function (spans) {
      spans.toggleClass('hidden');
    },
    token: new mumuki.CsrfToken(),
    discussionSubscription: function (url) {
      Forum.tokenRequest({
        url: url,
        method: 'POST',
        success: Forum.toggleSpans($suscriptionSpans),
        xhrFields: {withCredentials: true}
      })
    },
    tokenRequest: function (data) {
      $.ajax(Forum.token.newRequest(data))
    }
  };

  mumuki.Forum = Forum;

});
