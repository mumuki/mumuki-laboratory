var mumuki = mumuki || {};

(function (mumuki) {
  function ResultsBox(submissionsResults) {
    this.submissionsResultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
    this.submissionsErrorTemplate = $(".submission-result-error");
  }

  ResultsBox.prototype = {
    waiting: function () {
      this.submissionsResultsArea.html(this.processingTemplate.html());
      this.submissionsErrorTemplate.hide();
    },
    success: function (data) {
      this.submissionsResultsArea.html(data);
    },
    error: function () {
      this.submissionsResultsArea.html('');
      this.submissionsErrorTemplate.show();
    },
    done: function () {
      mumuki.pin.scroll();
    }
  };

  function SubmitButton() {
    this.submitButton = $('.btn-submit');
    this.submissionControls = $('.submission_control');
  }

  SubmitButton.prototype = {
    disable: function () {
      this.setWaitingText();
      this.submissionControls.attr('disabled', 'disabled');
    },
    setWaitingText: function () {
      document.prevSubmitState = this.submitButton.html();
      this.submitButton.html('<i class="fa fa-refresh fa-spin"></i> ' + this.submitButton.attr('data-waiting'));
    },
    setSendText: function () {
      this.submitButton.html(document.prevSubmitState);
    },
    enable: function () {
      this.setSendText();
      this.submissionControls.removeAttr('disabled');
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var resultsBox = new ResultsBox(submissionsResults);
    var submitButton = new SubmitButton();

    $('form.new_solution').on('ajax:beforeSend', function (event) {
      submitButton.disable();
      resultsBox.waiting();
    }).on('ajax:complete', function (event) {
      $(document).renderMuComponents();
      resultsBox.done();
      $('#messages-tab').removeClass('hidden');
    }).on('ajax:success', function (event) {
      var data = event.detail[0].body.outerHTML;
      submitButton.enable();
      resultsBox.success(data);
    }).on('ajax:error', function (event) {
      resultsBox.error(submitButton);
      animateTimeoutError(submitButton);
    });
  });

  function animateTimeoutError(submitButton) {
    var image = $('#submission-result-error-animation')[0];
    image.src = mumuki.errors.error_timeout_1;
    submitButton.setSendText();
    setTimeout(function () {
      image.src = mumuki.errors.error_timeout_2;
      setTimeout(function () {
        image.src = mumuki.errors.error_timeout_3;
        submitButton.enable();
      }, 4000);
    }, 10333);
  }

})(mumuki);
