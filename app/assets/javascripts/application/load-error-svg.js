mumuki.load(function () {
  var error_svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  mumuki.errors = mumuki.errors || {};

  error_svgs.forEach(function (svgErrorSuffix) {
    mumuki.animation.addImage(mumuki.errors, 'error_' + svgErrorSuffix, '/');
  });
});
