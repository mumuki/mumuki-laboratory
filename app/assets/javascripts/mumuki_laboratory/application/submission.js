mumuki.submission = (() => {

  // =============
  // UI Components
  // =============

  function animateTimeoutError(submitButton) {
    let scene = new muvment.Scene($('.submission-result-error-animation'));
    scene.addState(mumuki.errorState('timeout_1').onStart(submitButton.setOriginalContent.bind(submitButton)).onEndSwitch(scene, 'timeout_2'))
      .addState(mumuki.errorState('timeout_2').onEndSwitch(scene, 'timeout_3'))
      .addState(mumuki.errorState('timeout_3').onStart(submitButton.enable.bind(submitButton)))
      .play();
  }

  class ResultsBox {
    constructor(submissionsResults) {
      this.submissionsResultsArea = submissionsResults;
      this.processingTemplate = $('#processing-template');
      this.submissionsErrorTemplate = $(".submission-result-error");
    }
    waiting() {
      this.submissionsResultsArea.html(this.processingTemplate.html());
      this.submissionsErrorTemplate.addClass('d-none');
    }
    success(data, submitButton) {
      this.submissionsResultsArea.html(data.html);
      data.status === 'aborted' ? this.error(submitButton) : submitButton.enable();
      mumuki.updateProgressBarAndShowModal(data);
      mumuki.gamification.currentLevelProgression.setExpMessage(data);
    }
    error(submitButton) {
      this.submissionsResultsArea.html('');
      this.submissionsErrorTemplate.addClass('d-block');
      this.submissionsErrorTemplate.removeClass('d-none');
      animateTimeoutError(submitButton);
    }
    done(data, submitButton) {
      submitButton.updateAttemptsLeft(data);
      mumuki.pin.scroll();
    }
  }

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

    solutionSender(bridge, solution) {
      return bridge._submitSolution(solution);
    }

    solutionProcessor(bridge, $submissionsResults, solution) {
      const resultsBox = new ResultsBox($submissionsResults);
      this.disable();
      this.setWaitingText();
      resultsBox.waiting();
      return this.solutionSender(bridge, solution)
        .done((data) => resultsBox.success(data, this))
        .fail(() => resultsBox.error(this))
        .always((data) => {
          $(document).renderMuComponents({ webBrowser: { allowScript: true } });
          resultsBox.done(data, this);
        });
    }
  }

  class KidsSubmitButton extends SubmitButton {

    wait() {
      mumuki.kids.showOverlay();
      super.wait();
    }

    continue() {
      mumuki.kids.hideOverlay();
      super.continue();
    }

    solutionProcessor(bridge, $submissionsResults, solution) {
      this.wait();
      return this.solutionSender(bridge, solution)
        .then((data) => mumuki.kids.showResult(data))
        .always((data) => {
          this.ready(() => {
            mumuki.kids.restart();
            this.continue();
          });
        });
    }
  }

  // ==========
  // Processing
  // ==========

  /**
   * Process solution, which consist of making buttons wait, sending to server, rendering results,
   * restoring buttons state.
   *
   * The actual implementation of this method depends on contextual {@link _solutionProcessor}, which can
   * be configured using {@link _registerSolutionProcessor}. Currently there are only two available processors
   * which are automatically choosen depending on the exercise DOM.
   *
   * @param {Submission} solution
  */
  function processSolution(solution) {
    return mumuki.submission._solutionProcessor(solution);
  }

  /**
   * Just sends solution to the server without any further processing afterwards.
   *
   * Consider using {@link processSolution} instead if you want the whole functionality (making buttons wait, sending to server, rendering results,
   * restoring buttons state).
   * The implementation of this method isn't contextual, it always sends the solution using bridge module.
   *
   * @see mumuki.bridge
   *
   * @param {Submission} solution
   */
  function sendSolution(solution) {
    return mumuki.submission._solutionSender(solution);
  }

  /**
   * Configures a callback for processing a solution.
   *
   * This method is called internally by {@link _selectSolutionProcessor}
   * and should normally not be called by runners editor, but is exposed
   * for further non-standard customizations.
   *
   * @param {SubmitButton} submitButton
   * @param {$ElementType} $submissionsResults
   * @param {mumuki.bridge} bridge
   */
  function _registerSolutionProcessor(submitButton, $submissionsResults, bridge) {
    mumuki.submission._solutionSender = submitButton.solutionSender.bind(submitButton, bridge);
    mumuki.submission._solutionProcessor = submitButton.solutionProcessor.bind(submitButton, bridge, $submissionsResults);
  }

  /** Selects the most appropriate solution processor */
  function _selectSolutionProcessor(submitButton, $submissionsResults) {
    const bridge = new mumuki.bridge.Laboratory();
    mumuki.submission._registerSolutionProcessor(submitButton, $submissionsResults, bridge);
  }


  // ===========
  // Entry Point
  // ===========

  mumuki.load(() => {
    var $submissionsResults = $('.submission-results');
    if (!$submissionsResults) return;

    const $btnSubmit = $('.btn-submit');
    const buttonClass = mumuki.isKidsExercise() ? KidsSubmitButton : SubmitButton;
    const submitButton = new buttonClass($btnSubmit, $('.submission_control'));
    mumuki.submission._selectSolutionProcessor(submitButton, $submissionsResults);

    submitButton.start(() => {
      mumuki.submission.processSolution(mumuki.editors.getSubmission());
    });

    submitButton.checkAttemptsLeft();
  });

  /**
   * This module contains methods for submitting solution  in at high level, dealing with network communication,
   * and layout-sensitive UI updates. It is intended to be both used internally by standard editors and by runners
   * custom editors.
   *
   * Runners can choose to bypass this module under kids layouts, and handling all that low-level details. In order
   * to do that {@code .mu-kids-submit-button} selector must be overiden. Customizing submission in classic layout
   * or in a layout-agnostic way can be accomplish by overriding {@code .mu-submit-button}.
   *
   * @see mumuki.kids.showResult
   * @see mumuki.bridge.Laboratory.runTests
   *
   * @module mumuki.submission
   */
  return {
    processSolution,
    sendSolution,

    _registerSolutionProcessor,
    _selectSolutionProcessor,

    animateTimeoutError,
    SubmitButton,
    KidsSubmitButton,
  };
})();
