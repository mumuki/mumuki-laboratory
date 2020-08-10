mumuki.load(() => {
  var Chat = {
    $body: function () {
      return $('body')
    },
    $newMessageModal: function () {
      return $('.new-message-modal');
    },
    $newMessageModalComponents: function () {
      return Chat.$newMessageModal().find('.modal-body, .modal-footer');
    },
    collapseNewMessageModal: function () {
      Chat.$newMessageModalComponents().toggleClass('hidden');
    },
    token: new mumuki.CsrfToken(),
    setMessages: function (data) {
      $('.badge-notifications').html(data.messages_count);
      $('.notifications-box').toggleClass('notifications-box-empty', !data.has_messages);
      $('.pending-messages-filter').removeClass('pending-messages-filter');
      $('button.btn-submit').removeClass('disabled');
      $('.pending-messages-text').remove()
    },
    readMessages: function (url) {
      Chat.tokenRequest({
        url: url,
        method: 'POST',
        success: Chat.setMessages,
        xhrFields: {withCredentials: true}
      })
    },
    tokenRequest: function (data) {
      $.ajax(Chat.token.newRequest(data))
    },
    getMessages: function () {
      if ($('.badge-messages').length == 0) {
        return;
      }
      Chat.tokenRequest({
        url: '/messages',
        type: 'GET'
      }).done(function (res) {
        Chat.setMessages(res);
      }).fail(function (_error) {
        //ignoring error, not important
      });
    },
    setMessagesInterval: function () {
      mumuki.setInterval(Chat.getMessages, 60000);
    },
    submitMessagesForm: function (url, readUrl, errorUrl) {
      var $container = $('.mu-view-messages');

      function renderHTML(data) {
        $container.empty();
        $container.html(data);
        $("a[data-target='#messages']").click();
      }

      function success(data) {
        renderHTML(data);
        Chat.readMessages(readUrl);
      }

      function error(xhr) {
        Chat.tokenRequest({
          url: errorUrl,
          success: renderHTML,
          xhrFields: {withCredentials: true}
        });
      }

      $.ajax({
        url: url,
        success: success,
        error: error,
        xhrFields: {withCredentials: true}
      })
    },
    openNewMessageModal: function () {
      Chat.$newMessageModal().modal({backdrop: false, keyboard: false});
      Chat.$body().addClass("new-message-modal-open");
      Chat.$body().removeClass("modal-open");
    },
    closeNewMessageModal: function () {
      Chat.$body().removeClass("new-message-modal-open");
    }
  };

  Chat.setMessagesInterval();
  mumuki.Chat = Chat;

})

