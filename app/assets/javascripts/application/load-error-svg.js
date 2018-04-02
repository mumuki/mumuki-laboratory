mumuki.load(function () {
  var svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  mumuki.errors = mumuki.errors || {};
  mumuki.characters = mumuki.characters || {};

  svgs.forEach(function (svgErrorSuffix) {
    addImage(mumuki.errors, 'error_' + svgErrorSuffix, '/');
  });

  addImage(mumuki.characters, 'yellow_context', '/character/kids/');

  function addImage(object, imageName, urlPrefix) {
    var url = urlPrefix + imageName + '.svg';
    if (!object[imageName]) {
      $.get(url, function (data) {
        var duration = parseFloat($(data).find('animate').attr('dur') || 0, 10) * 1000;
        object[imageName] = {
          url: url,
          duration: duration
        };
      });
    }
  }

});
