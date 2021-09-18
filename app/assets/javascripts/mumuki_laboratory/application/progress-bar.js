mumuki.load(() => {
  $('.mu-progress-bar-inner').each(function() {
    let id = $(this).attr('data-mu-progress-bar-id');
    let percentage = $('#mu-progress-percentage-' + id).attr('data-mu-progress-percentage');

    $(this).css('width', percentage * 100 + '%');
  })
});
