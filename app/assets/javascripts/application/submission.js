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
    success: function (data, submitButton) {
      this.submissionsResultsArea.html(data.html);
      mumuki.showKidsResult(data);
      data.status === 'aborted' ? this.error(submitButton) : submitButton.enable();
      mumuki.updateProgressBarAndShowModal(data);
    },
    error: function (submitButton) {
      this.submissionsResultsArea.html('');
      this.submissionsErrorTemplate.show();
      animateTimeoutError(submitButton);
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

    var bridge = new mumuki.bridge.Laboratory;

    $('.btn-submit').on('click', function () {
      submitButton.disable();
      resultsBox.waiting();

      var solutionContent = mumuki.editor.getContent();

      bridge.runTests(solutionContent).always(function () {
        $(document).renderMuComponents();
        resultsBox.done();
      }).done(function (data) {
        resultsBox.success(data, submitButton);
      }).fail(function () {
        resultsBox.error(submitButton);
      });
    });

  });

  function animateTimeoutError(submitButton) {
    var image = $('#submission-result-error-animation')[0];
    image.src = mumuki.errors.error_timeout_1.url;
    submitButton.setSendText();
    setTimeout(function () {
      image.src = mumuki.errors.error_timeout_2.url;
      setTimeout(function () {
        image.src = mumuki.errors.error_timeout_3.url;
        submitButton.enable();
      }, mumuki.errors.error_timeout_2.duration);
    }, mumuki.errors.error_timeout_1.duration);
  }

})(mumuki);
