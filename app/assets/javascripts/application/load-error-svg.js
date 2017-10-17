mumuki.load(function () {
  [403, 404, 500].forEach(function (errorCode) {
    var url = '/error_' + errorCode + '.svg';
    $.get(url, function () {
      console.log('Loaded', url);
    });
  });
});
