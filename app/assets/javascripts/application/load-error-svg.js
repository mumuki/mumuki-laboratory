mumuki.load(function () {
  var error_svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  mumuki.errors = mumuki.errors || {};

  error_svgs.forEach(function (svgErrorSuffix) {
    addImage(mumuki.errors, 'error_' + svgErrorSuffix, '/');
  });

  function addImage(object, imageName, urlPrefix) {
    var url = urlPrefix + imageName + '.svg';
    if (!object[imageName]) {
      $.get(url, function (data) {
        var duration = parseFloat($(data).find('animate').attr('dur') || 0, 10) * 1000;
        object[imageName] = new mumuki.Clip(url, duration);
      });
    }
  }
});
