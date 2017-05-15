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
    $("a[data-target='#messages']").click();
    var $container = $('#mu-messages-container');

    function renderHTML(data) {
        $container.empty();
        $container.html(data);
    }

    function success(data) {
        renderHTML(data);
    }

    function error(xhr) {
        $.ajax({
            url: '/messages/errors',
            success: function (html) {
                renderHTML(html)
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
    $('body').removeClass("new-message-modal-open");
}
