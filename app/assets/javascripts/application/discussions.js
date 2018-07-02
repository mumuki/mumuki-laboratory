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

  var $subscriptionSpans = $('.discussion-subscription > span');
  var $upvoteSpans = $('.discussion-upvote > span');

  var Forum = {
    toggleButton: function (spans) {
      spans.toggleClass('hidden');
    },
    token: new mumuki.CsrfToken(),
    discussionSubscription: function (url) {
      Forum.discussionPostAndToggle(url, $subscriptionSpans)
    },
    discussionUpvote: function (url) {
      Forum.discussionPostAndToggle(url, $upvoteSpans)
    },
    discussionPostAndToggle: function (url, elem) {
      Forum.tokenRequest({
        url: url,
        method: 'POST',
        success: Forum.toggleButton(elem),
        xhrFields: {withCredentials: true}
      })
    },
    tokenRequest: function (data) {
      $.ajax(Forum.token.newRequest(data))
    }
  };

  mumuki.Forum = Forum;

});
