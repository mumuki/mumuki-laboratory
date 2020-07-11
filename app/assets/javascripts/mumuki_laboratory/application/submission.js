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

  class SubmitButton extends mumuki.Button {

    reachedMaxAttempts () {
      return $('#attempts-left-text').attr('data-disabled') === "true";
    }

    updateAttemptsLeft (data) {
      $('#attempts-left-text').replaceWith(data['remaining_attempts_html']);
      this.checkAttemptsLeft();
    }

    checkAttemptsLeft () {
      if (this.reachedMaxAttempts()) {
        this.preventClick();
      }
    }
  }

  function syncContent() {
    if (mumuki.submission.contentSyncer) {
      mumuki.submission.contentSyncer();
    }
  }

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

      mumuki.submission.syncContent();
      var solution = getContent();

      bridge._submitSolution(solution).done(function (data) {
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
    let scene = new muvment.Scene($('.submission-result-error-animation'));
    scene.addState(mumuki.errorState('timeout_1').onStart(submitButton.setOriginalContent.bind(submitButton)).onEndSwitch(scene, 'timeout_2'))
      .addState(mumuki.errorState('timeout_2').onEndSwitch(scene, 'timeout_3'))
      .addState(mumuki.errorState('timeout_3').onStart(submitButton.enable.bind(submitButton)))
      .play();
  }

  mumuki.submission = {
    syncContent,
    animateTimeoutError: animateTimeoutError,
    SubmitButton: SubmitButton
  };

})(mumuki);
