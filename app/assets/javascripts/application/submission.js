function smoothScrollToElement(domElement) {
  var SPEED = 1000;
  $('html, body').animate({scrollTop: domElement.offset().top}, SPEED);
}
