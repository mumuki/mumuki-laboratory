var mumuki = mumuki || {};

(function (mumuki) {
  function preparePopover() {
    $('[data-toggle="popover"]').popover({trigger: 'hover', html: true});
  }

  mumuki.load(preparePopover);
})(mumuki);
