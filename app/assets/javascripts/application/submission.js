function smoothScrollToElement(domElement) {
  var SPEED = 1000;
  $('html, body').animate({scrollTop: domElement.offset().top}, SPEED);
}

$(document).on('ready page:load', function(){
  var resultsBox = $('.submission-results');
  var scrollPin = $('.scroll-pin');
  if(!resultsBox) return;

  var processingTemplate = $('#processing-template');
  $('form.new_solution').on('ajax:beforeSend',function (event, xhr, settings) {
    console.log('submitting solution');
    resultsBox.html(processingTemplate.html());
  }).on('ajax:complete',function (xhr, status) {
    var button = $('form button.btn.btn-primary');
    button.attr('value', button.attr('data-normal-text'));
    if(scrollPin.length) {
      smoothScrollToElement(scrollPin);
    }
  }).on('ajax:success',function (xhr, data, status) {
    resultsBox.html(data);
  }).on('ajax:error', function (xhr, status, error) {
    resultsBox.html('<pre>' + error + '</pre>');
  });
  console.log('submission form setup')
});
