mumuki.load(function () {
  var error_svgs = ['403', '404', '500', 'timeout_1', 'timeout_2', 'timeout_3'];

  mumuki.errors = mumuki.errors || {};
  mumuki.characters = mumuki.characters || {};

  error_svgs.forEach(function (svgErrorSuffix) {
    addImage(mumuki.errors, 'error_' + svgErrorSuffix, '/');
  });

  addImage(mumuki.characters, 'kibi_context', '/character/kids/');
  addImage(mumuki.characters, 'magnifying_glass_apparition', '/');
  addImage(mumuki.characters, 'magnifying_glass_loop', '/');

  function addImage(object, imageName, urlPrefix) {
    var url = urlPrefix + imageName + '.svg';
    if (!object[imageName]) {
      $.get(url, function (data) {
        var duration = parseFloat($('data').find('animate').attr('dur') || 0, 10) * 1000;
        object[imageName] = new mumuki.State(image, url, duration);
      });
    }
  }

});
