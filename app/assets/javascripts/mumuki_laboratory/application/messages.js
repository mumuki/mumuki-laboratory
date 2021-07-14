mumuki.load(() => {
  var Chat = {
    $body: function () {
      return $('body');
    },
    $newMessageModal: function () {
      return $('.new-message-modal');
    },
    $newMessageModalComponents: function () {
      return Chat.$newMessageModal().find('.modal-body, .modal-footer');
    },
    collapseNewMessageModal: function () {
      Chat.$newMessageModalComponents().toggleClass('d-none');
    },
    token: new mumuki.CsrfToken(),
    setMessages: function (data) {
      $('.badge-notifications').html(data.messages_count);
      $('.notifications-box').toggleClass('d-none', !data.has_messages);
      $('.pending-messages-filter').removeClass('pending-messages-filter');
      $('button.btn-submit').removeClass('disabled');
      $('.pending-messages-text').remove();
      $("a[data-bs-target='#messages']")[0].click();
    },
    readMessages: function (url) {
      Chat.tokenRequest({
        url: url,
        method: 'POST',
        success: Chat.setMessages,
        xhrFields: {withCredentials: true}
      });
    },
    tokenRequest: function (data) {
      $.ajax(Chat.token.newRequest(data));
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

});
