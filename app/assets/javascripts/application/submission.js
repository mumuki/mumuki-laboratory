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
      data.status === 'aborted' ? this.error(submitButton) : submitButton.enable();
      mumuki.updateProgressBarAndShowModal(data);
    },
    error: function (submitButton) {
      this.submissionsResultsArea.html('');
      this.submissionsErrorTemplate.show();
      animateTimeoutError(submitButton);
    },
    done: function (data, submitButton) {
      submitButton.updateAttemptsLeft(data);
      mumuki.pin.scroll();
    }
  };

  function SubmitButton(submitButton, submissionControls) {
    this.submitButton = submitButton;
    this.submissionControls = submissionControls;
  }

  SubmitButton.prototype = {
    disable: function () {
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
    },
    reachedMaxAttempts: function () {
      return $('#attempts-left-text').attr('data-disabled') === "true";
    },
    updateAttemptsLeft: function (data) {
      $('#attempts-left-text').replaceWith(data['remaining_attempts_html']);
      this.checkAttemptsLeft();
    },
    preventSubmission: function () {
      this.disable();
      this.submitButton.on('click', function (e) {
        e.preventDefault();
      })
    },
    checkAttemptsLeft: function () {
      if (this.reachedMaxAttempts()) {
        this.preventSubmission();
      }
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var resultsBox = new ResultsBox(submissionsResults);

    var btnSubmit = $('.btn-submit');
    var submissionControl = $('.submission_control');

    var submitButton = new SubmitButton(btnSubmit, submissionControl);

    var bridge = new mumuki.bridge.Laboratory;

    btnSubmit.on('click', function (e) {
      e.preventDefault();
      submitButton.disable();
      submitButton.setWaitingText();
      resultsBox.waiting();

      mumuki.editor.syncContent();
      var solution = getContent();

      bridge.runLocalTests(solution).done(function (data) {
        resultsBox.success(data, submitButton);
      }).fail(function () {
        resultsBox.error(submitButton);
      }).always(function (data) {
        $(document).renderMuComponents();
        resultsBox.done(data, submitButton);
      });
    });

    submitButton.checkAttemptsLeft();
  });

  function getEditorsContent() {
    return $('.new_solution').serializeArray().concat(mumuki.CustomEditor.getContent())
  }

  function getContent(){
    var content = {};

    getEditorsContent().forEach(function(it) {
      content[it.name] = it.value;
    });

    return content;
  }

  function animateTimeoutError(submitButton) {
    var ch = new mumuki.Scene(document.getElementById('submission-result-error-animation'));
    ch.addState(new mumuki.State('error_timeout_1', mumuki.errors.error_timeout_1).onStart(submitButton.setSendText.bind(submitButton)).onEndSwitch(ch, 'error_timeout_2'))
      .addState(new mumuki.State('error_timeout_2', mumuki.errors.error_timeout_2).onEndSwitch(ch, 'error_timeout_3'))
      .addState(new mumuki.State('error_timeout_3', mumuki.errors.error_timeout_3).onStart(submitButton.enable.bind(submitButton)))
      .play();
  }

  mumuki.submission = {
    animateTimeoutError: animateTimeoutError,
    SubmitButton: SubmitButton
  };

})(mumuki);
