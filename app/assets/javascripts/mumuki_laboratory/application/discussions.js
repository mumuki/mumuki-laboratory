var mumuki = mumuki || {};

mumuki.load(function () {
  var $subscriptionSpans = $('.discussion-subscription > span');
  var $upvoteSpans = $('.discussion-upvote > span');

  function createNewMessageEditor() {
    var $textarea = $("#new-discussion-message");
    var textarea = $textarea[0];
    if (!textarea) return;

    return new mumuki.editor.CodeMirrorBuilder(textarea)
      .setupSimpleEditor()
      .setupMinLines($textarea.data('lines'))
      .build();
  }

  function createReadOnlyEditors() {
    return $(".read-only-editor").map(function (index, textarea) {
      var $textarea = $("#solution_content");

      return new mumuki.editor.CodeMirrorBuilder(textarea)
        .setupReadOnlyEditor()
        .setupMinLines($textarea.data('lines'))
        .setupLanguage()
        .build();
    });
  }

  createReadOnlyEditors();
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
    discussionMessageToggleApprove: function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
      })
    },
    discussionMessageToggleNotActuallyAQuestion: function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
      })
    }
  };

  mumuki.Forum = Forum;

});
