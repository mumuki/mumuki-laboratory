mumuki.load(() => {
  var $subscriptionButtons = $('.discussion-subscription > button');
  var $upvoteButtons = $('.discussion-upvote > button');
  var $responsibleButton = $('.discussion-responsible > button');
  let $messagePreviewButton = $('.discussion-new-message-preview-button.preview');
  let $messageEditButton = $('.discussion-new-message-preview-button.edit');
  let $newMessageContent = $('.discussion-new-message-content');
  let $newMessagePreview = $('#discussion-new-message-preview');

  function createNewMessageEditor() {
    var $textarea = $("#discussion-new-message");
    var editorContainer = $(".mu-spell-checked-editor")[0];
    if (!editorContainer) return;

    return new mumuki.editor.CodeMirrorBuilder(editorContainer)
      .setupSpellCheckedEditor()
      .setupMinLines($textarea.data('lines'))
      .setupLanguage()
      .build();
  }

  let editor = createNewMessageEditor();

  var Forum = {
    toggleButton: function (elements) {
      elements.toggleClass('d-none');
    },
    disableButton: function (elements) {
      elements.attr('disabled', true);
    },
    reenableButton: function (elements) {
      elements.attr('disabled', false);
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
      Forum.discussionPostAndToggle(url, $subscriptionButtons);
    },
    discussionUpvote: function (url) {
      Forum.discussionPostAndToggle(url, $upvoteButtons);
    },
    discussionResponsible: function (url) {
      Forum.disableButton($responsibleButton);
      Forum.discussionPostToggleAndRenderToast(url, $responsibleButton);
      $('.responsible-moderator-badge').toggleClass('d-none');
    },
    discussionPostAndToggle: function (url, elem) {
      Forum.discussionPost(url).done(Forum.toggleButton(elem));
    },
    discussionPostToggleAndRenderToast: function (url, elem) {
      Forum.discussionPost(url)
        .done(function (response) {
          Forum.toggleButton(elem);
          Forum.reenableButton(elem);
          mumuki.toast.addToast(response);
        })
        .fail(function (response) {
          mumuki.toast.addToast(response.responseText);
        });
    },
    discussionMessageToggleApprove: function (url, elem) {
      Forum.discussionPost(url).done(function () {
        elem.toggleClass("selected");
        elem.attr('data-bs-original-title', '');
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
        data: new URLSearchParams({ content: editor.getValue() } ),
        success: function (response) {
          showPreview(response.preview);
        },
        error: function (e) {
          error = $messagePreviewButton.attr('error-text');
          showPreview(error);
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
    $newMessagePreview.html($.parseHTML(preview));
    togglePreviewAndEditButtons();
    togglePreviewAndContentMessage();
  }

  function togglePreviewAndEditButtons() {
    $messagePreviewButton.toggleClass('d-none');
    $messageEditButton.toggleClass('d-none');
  }

  function togglePreviewAndContentMessage() {
    $newMessagePreview.toggleClass('d-none');
    $newMessageContent.toggleClass('d-none');
  }

  mumuki.Forum = Forum;

});
