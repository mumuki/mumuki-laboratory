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
      this.submissionsErrorTemplate.hide();
    }
    success(data, submitButton) {
      this.submissionsResultsArea.html(data.html);
      data.status === 'aborted' ? this.error(submitButton) : submitButton.enable();
      mumuki.updateProgressBarAndShowModal(data);
    }
    error(submitButton) {
      this.submissionsResultsArea.html('');
      this.submissionsErrorTemplate.show();
      animateTimeoutError(submitButton);
    }
    done(data, submitButton) {
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


  // ==========
  // Processing
  // ==========

  /**
   * Process solution, which consist of making buttons wait, sending to server, rendering results,
   * restoring buttons state.
   *
   * The actual implementation of this method depends on contextual {@link _solutionProcessor}, which can
   * be configured using {@link _registerSolutionProcessor}. Currently there are only two available processors -
   * {@link _kidsSolutionProcessor} and {@link _classicSolutionProcessor} - which are automatically choosen depending
   * on the exercise DOM.
   *
   * @param {Submission} solution
  */
  function processSolution(solution) {
    mumuki.submission._solutionProcessor(solution);
  }

  /**
   * Configures a callback for processing a solution.
   *
   * This method is called internally by {@link _selectSolutionProcessor}
   * and should normally not be called by runners editor, but is exposed
   * for further non-standard customizations.
   *
   * @param {({solution: object}) => void} processor
   */
  function _registerSolutionProcessor(processor) {
    mumuki.submission._solutionProcessor = processor;
  }

  /** Processor for kids layouts */
  function _kidsSolutionProcessor(bridge, submitButton) {
    return (solution) => {
      submitButton.wait();
      bridge._submitSolution(solution).always(function (data) {
        submitButton.ready(() => {
          mumuki.kids.restart();
          submitButton.continue();
        });
        mumuki.kids.showResult(data);
      });
    }
  }

  /** Processor for non-kids layouts */
  function _classicSolutionProcessor(bridge, submitButton, resultsBox) {
    return (solution) => {
      submitButton.disable();
      submitButton.setWaitingText();
      resultsBox.waiting();
      bridge._submitSolution(solution).done(function (data) {
        resultsBox.success(data, submitButton);
      }).fail(function () {
        resultsBox.error(submitButton);
      }).always(function (data) {
        $(document).renderMuComponents();
        resultsBox.done(data, submitButton);
      });
    }
  }

  /** Selects the most appropriate solution processor */
  function _selectSolutionProcessor(submitButton, $submissionsResults) {
    const bridge = new mumuki.bridge.Laboratory();
    let processor;
    if ($('.mu-kids-exercise').length) {
      processor = _kidsSolutionProcessor(bridge, submitButton);
    } else {
      processor = _classicSolutionProcessor(bridge, submitButton, new ResultsBox($submissionsResults));
    }
    mumuki.submission._registerSolutionProcessor(processor);
  }


  // ===========
  // Entry Point
  // ===========

  mumuki.load(() => {
    var $submissionsResults = $('.submission-results');
    if (!$submissionsResults) return;

    const $btnSubmit = $('.btn-submit');
    const submitButton = new SubmitButton($btnSubmit, $('.submission_control'));

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
    _registerSolutionProcessor,
    _selectSolutionProcessor,

    animateTimeoutError,
    SubmitButton,
  };
})();
