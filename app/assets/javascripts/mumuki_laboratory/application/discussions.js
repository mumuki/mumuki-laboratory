mumuki.load(() => {
  var $subscriptionSpans = $('.discussion-subscription > span');
  var $upvoteSpans = $('.discussion-upvote > span');
  let $messagePreviewButton = $('.discussion-new-message-preview-button.preview');
  let $messageEditButton = $('.discussion-new-message-preview-button.edit');
  let $discussionNewMessageContent = $('.discussion-new-message-content');
  let $newDiscussionMessagePreview = $('#new-discussion-message-preview');

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
  let editor = createNewMessageEditor();

  var Forum = {
    toggleButton: function (spans) {
      spans.toggleClass('hidden');
    },
    token: new mumuki.CsrfToken(),
    tokenRequest: function (data) {
      return $.ajax(Forum.token.newRequest(data));
    },
    discussionPost: function (url) {
      return Forum.tokenRequest({
        url: url,
        method: 'POST',
        xhrFields: {withCredentials: true}
      });
    },
    discussionSubscription: function (url) {
      Forum.discussionPostAndToggle(url, $subscriptionSpans);
    },
    discussionUpvote: function (url) {
      Forum.discussionPostAndToggle(url, $upvoteSpans);
    },
    discussionPostAndToggle: function (url, elem) {
      Forum.discussionPost(url).done(Forum.toggleButton(elem));
    },
    discussionMessageToggleApprove: function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
      });
    },
    discussionMessageToggleNotActuallyAQuestion: function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
      });
    },
    discussionsToggleCheckbox: function (elem) {
      const key = elem.attr('name');
      const params = new URLSearchParams(location.search);
      elem.is(':checked') ? params.set(key, elem.val()) : params.delete(key);
      location.search = params.toString();
    },
    discussionMessagePreview: function (url) {
      return Forum.tokenRequest({
        url: url,
        method: 'GET',
        processData: false,
        dataType: 'json',
        data: new URLSearchParams({ content: encodeURIComponent(editor.getValue()) } ),
        success: function (response) {
          showPreview(response.preview);
        },
        xhrFields: {withCredentials: true}
      });
    },
    hidePreviewAndShowEditor: function(elem) {
      togglePreviewAndEditButtons();
      togglePreviewAndContentMessage();
    }
  };

  function showPreview(preview) {
    $newDiscussionMessagePreview.html($.parseHTML(preview));
    togglePreviewAndEditButtons();
    togglePreviewAndContentMessage();
  }

  function togglePreviewAndEditButtons() {
    $messagePreviewButton.toggleClass('hidden');
    $messageEditButton.toggleClass('hidden');
  }

  function togglePreviewAndContentMessage() {
    $newDiscussionMessagePreview.toggleClass('hidden');
    $discussionNewMessageContent.toggleClass('hidden');
  }

  mumuki.Forum = Forum;

});
