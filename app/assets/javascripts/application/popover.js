mumuki.load(() => {
  let $popover = $('.mu-popover');

  $('html').click(function(e) {
    if (!e.target.closest('.popover')) {
      $popover.popover('hide');
    }
  });

  $popover.popover({
      html: true,
      trigger: 'manual',
      container: 'body'
  }).click(function(e) {
      $(this).popover('toggle');
      e.stopPropagation();
  });
});
