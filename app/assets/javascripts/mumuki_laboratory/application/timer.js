mumuki.startTimer = (() => {
  function startTimer(seconds) {
    var duration = moment.duration(seconds, 'seconds');
    var intervalDuration = 1000;

    var interval = mumuki.setInterval(function () {
      duration = moment.utc(duration - intervalDuration);
      if(duration.valueOf() <= 0) {
        clearInterval(interval);
        window.location.reload();
      } else {
        $('#timer').text(duration.format("HH:mm:ss"));
      }
    }, intervalDuration);
  }
  return startTimer;
})();
