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

  /**
   * Copies current solution from it native rendering components
   * to the appropriate submission form elements.
   *
   * Both editors and runners with a custom editor should
   * register its own syncer function in order to {@link syncContent} work properly.
   *
   * @see registerContentSyncer
   */
  function _syncContent() {
    if (mumuki.submission.contentSyncer) {
      mumuki.submission.contentSyncer();
    }
  }

  /**
   * Sets a content syncer, that will be used by {@link _syncContent}
   * in ordet to dump solution into the submission form fields.
   *
   * Each editor should have its own syncer registered - otherwise previous or none may be used
   * causing unpredicatble behaviours - or cleared by passing {@code null}.
   *
   * As a particular case, runners with custom editors should set
   * the {@code #mu-custom-editor-value} value within its syncer.
   *
   * @param {() => void} [syncer] the syncer, or null, if no sync'ing is needed
   */
  function registerContentSyncer(syncer = null) {
    mumuki.submission.contentSyncer = syncer;
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
    _syncContent,
    registerContentSyncer,
    animateTimeoutError: animateTimeoutError,
    SubmitButton: SubmitButton
  };

})(mumuki);
