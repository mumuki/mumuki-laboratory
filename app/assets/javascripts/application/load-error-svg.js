mumuki.load(function () {
  var svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  svgs.forEach(function (svgErrorSuffix) {
    var url = '/error_' + svgErrorSuffix + '.svg';
    $.get(url, function () {
    });
  });
});
