var mumuki = mumuki || {};

(function (mumuki) {
  mumuki.startTimer = function (endDate) {
    var endTime = new Date(endDate).getTime();
    var currentTime = Date.now();
    var diffTime = endTime - currentTime;
    var duration = moment.duration(diffTime, 'milliseconds');
    var interval = 1000;

    setInterval(function () {
      duration = moment.duration(duration - interval, 'milliseconds');
      if(duration.milliseconds() <= 0) window.location.reload();
      $('#timer').text(duration.hours() + ":" + duration.minutes() + ":" + duration.seconds())
    }, interval);
  };
})(mumuki);
