var mumuki = mumuki || {};

(function (mumuki) {
    $(function () {
        var token = new mumuki.CsrfToken();
        setInterval(function () {
            if ($('.badge-comments').length == 0) {
                return;
            }
            $.ajax(token.newRequest({
                url: '/comments',
                type: 'GET'
            })).done(function (res) {
                $('.badge-comments').html(res.comments_count);
                $('.comments-box').toggleClass('comments-box-empty', !res.has_comments);
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
