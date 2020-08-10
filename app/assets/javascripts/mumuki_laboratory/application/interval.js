(function () {
  // When using Turbolinks, intervals loaded inside <body> aren't destroyed on page changes
  // Use this function instead if you want the behaviour of a regular setInterval
  mumuki.setInterval = function (intervalFunction, milliseconds) {
    const interval = setInterval.apply(this, [intervalFunction, milliseconds]);

    // Using one to avoid calling clearInterval on every page chance.
    $(document).one('turbolinks:before-cache turbolinks:before-render', function () {
      clearInterval(interval);
    });

    return interval;
  }.bind(this);

}());
