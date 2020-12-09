mumuki.pin = (() => {
  function smoothScrollToElement(domElement) {
    var SPEED = 1000;
    $('html, body').animate({scrollTop: domElement.offset().top}, SPEED);
  }

  return {
    scroll: function () {
      var scrollPin = $('.scroll-pin');
      if (scrollPin.length) {
        smoothScrollToElement(scrollPin);
      }
    }
  };
})();
