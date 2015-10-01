(function () {
  function smoothScrollToElement(domElement) {
    var SPEED = 1000;
    $('html, body').animate({scrollTop: domElement.offset().top}, SPEED);
  }

  function ResultsBox(submissionsResults) {
    this.submissionsresultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
    this.scrollPin = $('.scroll-pin');
  }

  ResultsBox.prototype = {
    waiting: function () {
      console.log('submitting solution');
      this.submissionsresultsArea.html(this.processingTemplate.html());
    },
    success: function (data) {
      this.submissionsresultsArea.html(data);
    },
    error: function (error) {
      this.submissionsresultsArea.html('<pre>' + error + '</pre>');
    },
    done: function () {
      if (this.scrollPin.length) {
        smoothScrollToElement(this.scrollPin);
      }
    }
  };

  $(document).on('ready page:load', function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var submitButton = $('form submitButton.btn.btn-primary');
    var resultsBox = new ResultsBox(submissionsResults);

    $('form.new_assignment').on('ajax:beforeSend',function (event, xhr, settings) {
      resultsBox.waiting();
    }).on('ajax:complete',function (xhr, status) {
      submitButton.attr('value', submitButton.attr('data-normal-text'));
      resultsBox.done();
    }).on('ajax:success',function (xhr, data, status) {
      resultsBox.success(data);
    }).on('ajax:error', function (xhr, status, error) {
      resultsBox.error(error);
    });
    console.log('submission form setup')
  });
})();
