/*var mumuki = mumuki || {};

(function (mumuki) {
  $(document).on('ready page:load', function () {
    var token = new mumuki.CsrfToken();
    setInterval(function () {
      $.ajax(token.newRequest({
          url: '/comments',
          type: 'GET'
        })).
        done(function (res) {
          $('.badge-comments').html(res.comments_count);
          $('.comments-box').toggleClass('comments-box-empty', !res.has_comments);
        }).
        fail(function(_error) {
          //ignoring error, not important
        });
    }, 60000);
  });
})(mumuki);*/
