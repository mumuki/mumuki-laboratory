mumuki.load(function () {
  var svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  mumuki.errors = mumuki.errors || {};

  svgs.forEach(function (svgErrorSuffix) {
    var image = 'error_' + svgErrorSuffix;
    var url = '/' + image + '.svg';
    if (!mumuki.errors[image]) {
      $.get(url, function (data) {
        var duration = parseFloat($(data).find('animate').attr('dur') || 0, 10) * 1000;
        mumuki.errors[image] = {
          url: url,
          duration: duration
        };
      });
    }
  });
});
