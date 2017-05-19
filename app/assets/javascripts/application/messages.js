var mumuki = mumuki || {};

(function (mumuki) {

    MessagesService = {
        $body: $('body'),
        $newMessageModal: $('#new-message-modal'),
        token: new mumuki.CsrfToken(),
        setMessages: function (data) {
            $('.badge-notifications').html(data.messages_count);
            $('.notifications-box').toggleClass('notifications-box-empty', !data.has_messages);
            $('.pending-messages-filter').removeClass('pending-messages-filter');
            $('button.btn-submit').removeClass('disabled');
            $('.pending-messages-text').remove()
        },
        readMessages: function (url) {
            MessagesService.tokenRequest({
                url: url,
                method: 'POST',
                success: MessagesService.setMessages,
                xhrFields: {withCredentials: true}
            })
        },
        tokenRequest: function (data) {
            $.ajax(MessagesService.token.newRequest(data))
        },
        getMessages: function () {
            if ($('.badge-messages').length == 0) {
                return;
            }
            MessagesService.tokenRequest({
                url: '/messages',
                type: 'GET'
            }).done(function (res) {
                MessagesService.setMessages(res);
            }).fail(function (_error) {
                //ignoring error, not important
            });
        },
        setMessagesInterval: function () {
            setInterval(MessagesService.getMessages, 60000);
        },
        submitMessagesForm: function (url, readUrl) {
            var $container = $('.mu-view-messages');

            function renderHTML(data) {
                $container.empty();
                $container.html(data);
                $("a[data-target='#messages']").click();
            }
           
            function success(data) {
                renderHTML(data);
                MessagesService.readMessages(readUrl);
            }

            function error(xhr) {
                MessagesService.tokenRequest({
                    url: '/messages/errors',
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
            MessagesService.$newMessageModal.modal({backdrop: false, keyboard: false});
            MessagesService.$body.addClass("new-message-modal-open");
            MessagesService.$body.removeClass("modal-open");
        },
        closeNewMessageModal: function () {
            MessagesService.$body.removeClass("new-message-modal-open");
        }
    };

    MessagesService.setMessagesInterval();

}(mumuki));
