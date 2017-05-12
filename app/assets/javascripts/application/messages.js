var mumuki = mumuki || {};

(function (mumuki) {
    $(function () {
        var token = new mumuki.CsrfToken();
        setInterval(function () {
            if ($('.badge-messages').length == 0) {
                return;
            }
            $.ajax(token.newRequest({
                url: '/messages',
                type: 'GET'
            })).done(function (res) {
                $('.badge-messages').html(res.messages_count);
                $('.messages-box').toggleClass('messages-box-empty', !res.has_messages);
            }).fail(function (_error) {
                //ignoring error, not important
            });
        }, 60000);
    });


}(mumuki));

function submitMessagesForm(url) {
    function renderModal(data) {
        $('#view-messages-template').html(data);
        $('#messages-modal').modal();
    }

    function success(data) {
        renderModal(data);
    }

    function error(xhr) {
        $.ajax({
            url: '/messages/errors',
            success: function (html) {
                renderModal(html)
            },
            xhrFields: {
                withCredentials: true
            }
        });
    }

    $.ajax({
        url: url,
        success: success,
        error: error,
        xhrFields: {
            withCredentials: true
        }
    });
}

function openNewMessageModal() {
    $('#new-message-modal').modal({backdrop: false, keyboard: false});
    $('body').addClass("new-message-modal-open");
    $('body').removeClass("modal-open");
}

function closeNewMessageModal() {
    $('#new-message-modal').modal("close");
    $('body').removeClass("new-message-modal-open");
}
