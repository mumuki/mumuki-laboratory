mumuki.startTimer = (() => {
  function startTimer(endDate) {
    var endTime = new Date(endDate).getTime();
    var currentTime = Date.now();
    var diffTime = endTime - currentTime;
    var duration = moment.duration(diffTime, 'milliseconds');
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
