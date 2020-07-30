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

  // ============
  // Content Sync
  // ============

  /**
   * Syncs and returns the content objects of the standard editor form
   *
   * This content object may include keys like {@code content},
   * {@code content_extra} and {@code content_test}
   *
   * @returns {EditorProperty[]}
   */
  function getStandardEditorContents() {
    mumuki.submission._syncContent();
    return $('.new_solution').serializeArray();
  }

  /**
   * Answers a content object with a key for each of the current
   * editor sources.
   *
   * This method will use CustomEditor's sources if availble, or
   * standard editor's content sources otherwise
   *
   * @returns {Submission}
   */
  function getContent() {
    let content = {};
    let contents;

    if (mumuki.CustomEditor.hasSources) {
      contents = mumuki.CustomEditor.getContents();
    } else {
      contents = mumuki.submission.getStandardEditorContents();
    }

    contents.forEach((it) => {
      content[it.name] = it.value;
    });

    // @ts-ignore
    return content;
  }

  /**
   * Copies current solution from it native rendering components
   * to the appropriate submission form elements.
   *
   * Both editors and runners with a custom editor that don't register a source should
   * register its own syncer function in order to {@link syncContent} work properly.
   *
   * @see registerContentSyncer
   * @see CustomEditor#addSource
   */
  function _syncContent() {
    if (mumuki.submission._contentSyncer) {
      mumuki.submission._contentSyncer();
    }
  }

  /**
   * Sets a content syncer, that will be used by {@link _syncContent}
   * in ordet to dump solution into the submission form fields.
   *
   * Each editor should have its own syncer registered - otherwise previous or none may be used
   * causing unpredicatble behaviours - or cleared by passing {@code null}.
   *
   * As a particular case, runners with custom editors that don't add sources using {@link CustomEditor#addSource}
   * should set the {@code #mu-custom-editor-value} value within its syncer.
   *
   * @param {() => void} [syncer] the syncer, or null, if no sync'ing is needed
   */
  function registerContentSyncer(syncer = null) {
    mumuki.submission._contentSyncer = syncer;
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

  mumuki.load(function () {
    var $submissionsResults = $('.submission-results');
    if (!$submissionsResults) return;

    const $btnSubmit = $('.btn-submit');
    const submitButton = new SubmitButton($btnSubmit, $('.submission_control'));

    mumuki.submission._selectSolutionProcessor(submitButton, $submissionsResults);

    submitButton.start(() => {
      var solution = mumuki.submission.getContent();
      mumuki.submission.processSolution(solution);
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

    _syncContent,
    registerContentSyncer,
    getStandardEditorContents,
    getContent,

    animateTimeoutError,
    SubmitButton,
  };
})();
