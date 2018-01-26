var mumuki = mumuki || {};

(function (mumuki) {
  function ResultsBox(submissionsResults) {
    this.submissionsresultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
    this.submissionsErrorTemplate = $(".submission-result-error");
  }

  ResultsBox.prototype = {
    waiting: function () {
      this.submissionsresultsArea.html(this.processingTemplate.html());
      this.submissionsErrorTemplate.hide();
    },
    success: function (data) {
      this.submissionsresultsArea.html(data);
    },
    error: function () {
      this.submissionsresultsArea.html('');
      this.submissionsErrorTemplate.show();
    },
    done: function () {
      mumuki.pin.scroll();
    }
  };

  function SubmissionController() {
    this.submitButton = $('.btn-submit');
    this.submissionControls = $('.submission_control');
  }

  SubmissionController.prototype = {
    disable: function () {
      document.prevSubmitState = this.submitButton.html();
      this.submitButton.html('<i class="fa fa-refresh fa-spin"></i> ' + this.submitButton.attr('data-waiting'));
      this.submissionControls.attr('disabled', 'disabled');
    },
    enable: function () {
      this.submitButton.html(document.prevSubmitState);
      this.submissionControls.removeAttr('disabled');
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var resultsBox = new ResultsBox(submissionsResults);
    var submissionController = new SubmissionController();

    $('form.new_solution').on('ajax:beforeSend', function (event) {
      submissionController.disable();
      resultsBox.waiting();
    }).on('ajax:complete', function (event) {
      $(document).renderMuComponents();
      resultsBox.done();
      $('#messages-tab').removeClass('hidden');
    }).on('ajax:success', function (event) {
      var data = event.detail[0].body.outerHTML;
      submissionController.enable();
      resultsBox.success(data);
    }).on('ajax:error', function (event) {
      resultsBox.error(submissionController);
      animateTimeoutError(submissionController);
    });
  });

  function animateTimeoutError(submissionController) {
    var image = $('#submission-result-error-animation')[0];
    image.src = mumuki.errors.error_timeout_1;
    setTimeout(function () {
      image.src = mumuki.errors.error_timeout_2;
      setTimeout(function () {
        image.src = mumuki.errors.error_timeout_3;
        submissionController.enable();
      }, 4000);
    }, 10333);
  }

})(mumuki);
