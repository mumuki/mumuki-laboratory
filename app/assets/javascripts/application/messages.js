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
    function success(data) {
        $('#view-messages-template').html(data);
        $('#messages-modal').modal();
    }

    function error(xhr) {
        console.log(xhr);
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
    $('#new-message-modal').modal();
}
