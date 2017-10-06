var mumuki = mumuki || {};

(function (mumuki) {
  function smoothScrollToElement(domElement) {
    var SPEED = 1000;
    $('html, body').animate({scrollTop: domElement.offset().top}, SPEED);
  }

  mumuki.pin = {
    scroll: function () {
      var scrollPin = $('.scroll-pin');
      if (scrollPin.length) {
        smoothScrollToElement(scrollPin);
      }
    }
  }
})(mumuki);
