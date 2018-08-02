var mumuki = mumuki || {};

mumuki.load(function () {
  var $newDiscussionModal = $('.new-discussion-modal');
  var $newDiscussion = $('.discussion-create');

  $newDiscussion.click(function () {
    $newDiscussionModal.modal({
      backdrop: 'static',
      keyboard: false
    });
  });

  var $subscriptionSpans = $('.discussion-subscription > span');
  var $upvoteSpans = $('.discussion-upvote > span');

  function createNewMessageEditor() {
    var $textarea = $("#new-discussion-message");
    var textarea = $textarea[0];
    if(!textarea) return;
    var builder = new mumuki.editor.CodeMirrorBuilder(textarea);
    builder.setupSimpleEditor();
    builder.setupOptions($textarea.data('lines'));
    builder.build();
  }

  createNewMessageEditor();

  var Forum = {
    toggleButton: function (spans) {
      spans.toggleClass('hidden');
    },
    token: new mumuki.CsrfToken(),
    tokenRequest: function (data) {
      return $.ajax(Forum.token.newRequest(data))
    },
    discussionPost: function (url) {
      return Forum.tokenRequest({
        url: url,
        method: 'POST',
        xhrFields: {withCredentials: true}
      })
    },
    discussionSubscription: function (url) {
      Forum.discussionPostAndToggle(url, $subscriptionSpans)
    },
    discussionUpvote: function (url) {
      Forum.discussionPostAndToggle(url, $upvoteSpans)
    },
    discussionPostAndToggle: function (url, elem) {
      Forum.discussionPost(url).done(Forum.toggleButton(elem))
    },
    discussionMessageUseful : function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
      })
    }
  };

  mumuki.Forum = Forum;

});
