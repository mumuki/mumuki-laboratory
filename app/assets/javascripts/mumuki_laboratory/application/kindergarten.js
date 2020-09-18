mumuki.load(() => {

  let $context = $('#mu-kindergarten-context');
  let contextModalButton = new mumuki.Button($('.mu-kindergarten-context .modal-footer button'));

  // It is important that context is shown as early as possible
  // in order to display the loading animation
  function showContext() {
    $context.modal({
      backdrop: 'static',
      keyboard: false
    });
  }

  $context.on('hidden.bs.modal', function () {
    animateSpeech();
  });

  showContext();

  /**
   * Assigns propert widths to the states and blocks areas
   * depending on the presence and type of available states
   *
   * @param {*} $muKidsStateImage
   * @param {*} $muKidsStatesContainer
   * @param {*} $muKidsBlocks
   * @param {number} fullMargin
   */
  function distributeAreas($muKidsStateImage, $muKidsStatesContainer, $muKidsBlocks, fullMargin) {
    if ($muKidsStateImage.children().length) {
      var ratio = $muKidsStatesContainer.hasClass('mu-kids-single-state') ? 1 : 2;
      $muKidsStatesContainer.width($muKidsStatesContainer.height() / ratio * 1.25 - fullMargin);
    } else {
      $muKidsStatesContainer.width(0);
      $muKidsBlocks.width('100%');
    }
  }

  mumuki.kindergarten = {

    // ==========
    // Public API
    // ==========

    // Sets a function that will be called each
    // time the states need to be resized. The function takes:
    //
    // * $state: a single state area
    // * fullMargin
    // * preferredWidth
    // * preferredHeight
    //
    // Runners must call this method on within the runner's editor.js extension
    registerStateScaler: function (scaler) {
      this._stateScaler = scaler;
    },

    // Sets a function that will be called each
    // time the blocks area needs to be resized. The function takes:
    //
    // * $blocks: the blocks area
    //
    // Runners must call this method on within the runner's editor.js extension
    registerBlocksAreaScaler: function (scaler) {
      this._blocksAreaScaler = scaler;
    },

    // Scales a single state.
    //
    // This method is called by the kids code, but the runner's editor.js extension may need
    // to perform additional calls to it.
    scaleState: function ($state, fullMargin) {
      const preferredWidth = $state.width() - fullMargin * 2;
      const preferredHeight = $state.height() - fullMargin * 2;
      this._stateScaler($state, fullMargin, preferredWidth, preferredHeight);
    },

    // Scales the blocks area.
    //
    // This method is called by the kids code, but the runner's editor.js extension may need
    // to perform additional calls to it.
    scaleBlocksArea: function ($blocks) {
      this._blocksAreaScaler($blocks);
    },

    // Displays the kids results, updating the progress bar
    // firing the modal and running appropriate animations.
    //
    // This method needs to be called by the runner's editor.html extension
    // in order to finish an exercise
    showResult: function (data) {
      mumuki.updateProgressBarAndShowModal(data);
      if (data.guide_finished_by_solution) return;
      mumuki.kindergarten.resultAction[data.status](data);
    },

    // Restarts the kids exercise.
    //
    // This method may need to be called by the runner's editor.html extension
    // in order to recover from a failed submission
    restart: function () {
      mumuki.kindergarten._hideMessageOnCharacterBubble();
      var $bubble = mumuki.kindergarten._getCharacterBubble();
      Object.keys(mumuki.kindergarten.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.presenterCharacter.playAnimation('talk', mumuki.kindergarten._getCharacterImage());
    },

    disableContextModalButton: function () {
      contextModalButton.setWaiting();
    },

    enableContextModalButton: function () {
      contextModalButton.enable();
    },

    showContext,

    // ===========
    // Private API
    // ===========

    _updateSubmissionResult: function (html) {
      return $('.submission-results').html(html);
    },

    _getResultsModal: function () {
      return $('#kids-results');
    },

    _getResultsAbortedModal: function () {
      return $('#kids-results-aborted');
    },

    _getCharacterImage: function () {
      return $('.mu-kids-character > img');
    },

    _getCharacterBubble: function () {
      return $('.mu-kids-character-speech-bubble');
    },

    _getOverlay: function () {
      return $('.mu-kids-overlay');
    },

    _hideMessageOnCharacterBubble: function () {
      var $bubble = mumuki.kindergarten._getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').show();
      $bubble.find('.mu-kids-character-speech-bubble-normal').show();
      $bubble.find('.mu-kids-character-speech-bubble-failed').hide();
      $bubble.find('.mu-kids-discussion-link').remove();
      Object.keys(mumuki.kindergarten.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.kindergarten._getOverlay().hide()
    },

    _showMessageOnCharacterBubble: function (data) {
      const renderer = new mumuki.renderers.SpeechBubbleRenderer(mumuki.kindergarten._getCharacterBubble());
      renderer.setDiscussionsLinkHtml(discussionsLinkHtml);
      renderer.setResponseData(data);
      renderer.render();
      mumuki.kindergarten._getOverlay().show();
    },

    _showOnSuccessPopup: function (data) {
      mumuki.kindergarten._updateSubmissionResult(data.html);
      mumuki.presenterCharacter.playAnimation('success_l', mumuki.kindergarten._getCharacterImage());
      mumuki.kindergarten._showMessageOnCharacterBubble(data);
      mumuki.presenterCharacter.playAnimation('success2_l', $('.mu-kids-character-success'));
      setTimeout(function () {
        var $resultsKidsModal = mumuki.kindergarten._getResultsModal();
        if ($resultsKidsModal) {
          $resultsKidsModal.modal({
            backdrop: 'static',
            keyboard: false
          });
          $resultsKidsModal.find('.modal-header').first().html(data.title_html);
          $resultsKidsModal.find('.modal-footer').first().html(data.button_html);
          mumuki.kindergarten._showCorollaryCharacter();
          $('.mu-close-modal').click(() => mumuki.kindergarten._getResultsModal().modal('hide'));
        }
      }, 1000 * 4);
    },

    _showOnFailurePopup: function () {
      mumuki.kindergarten.submitButton.disable();
      mumuki.kindergarten._getResultsAbortedModal().modal();
      mumuki.submission.animateTimeoutError(mumuki.kindergarten.submitButton);
    },

    _showOnCharacterBubble: function (data) {
      mumuki.presenterCharacter.playAnimation('failure', mumuki.kindergarten._getCharacterImage());
      mumuki.kindergarten._showMessageOnCharacterBubble(data);
    },

    _showCorollaryCharacter: function () {
      mumuki.characters.magnifying_glass.playAnimation('show', $('.mu-kids-corollary-animation'));
    },

    _stateScaler: function ($state, fullMargin, preferredWidth, preferredHeight) {
      var $table = $state.find('gs-board > table');
      if (!$table.length) return setTimeout(() => this.scaleState($state, fullMargin));

      console.warn("You are using the default states scaler, which is gobstones-specific. Please register your own scaler in the future");

      $table.css('transform', 'scale(1)');
      var scaleX = preferredWidth / $table.width();
      var scaleY = preferredHeight / $table.height();
      $table.css('transform', 'scale(' + Math.min(scaleX, scaleY) + ')');
    },

    _blocksAreaScaler: function ($blocks) {
      console.warn("You are using the default blocks scaler, which is blockly-specific. Please register your own scaler in the future");

      var $blockArea = $blocks.find('#blocklyDiv');
      var $blockSvg = $blocks.find('.blocklySvg');

      $blockArea.width($blocks.width());
      $blockArea.height($blocks.height());

      $blockSvg.width($blocks.width());
      $blockSvg.height($blocks.height());
    },

    resultAction: {}

  };

  mumuki.kindergarten.submitButton = new mumuki.submission.SubmitButton($('#kids-btn-retry'), $('.submission_control'));

  function showPrevParagraph() {
    animateSpeech();
    showParagraph(currentParagraphIndex - 1);
  }

  function showNextParagraph() {
    animateSpeech();
    showParagraph(currentParagraphIndex + 1);
    clearInterval(nextSpeechBlinking);
  }

  function animateSpeech() {
    mumuki.presenterCharacter.playAnimation('talk', mumuki.kindergarten._getCharacterImage());
  }

  function animateHint() {
    mumuki.presenterCharacter.playAnimation('hint', mumuki.kindergarten._getCharacterImage());
  }

  mumuki.kindergarten.resultAction.passed = mumuki.kindergarten._showOnSuccessPopup;
  mumuki.kindergarten.resultAction.passed_with_warnings = mumuki.kindergarten._showOnCharacterBubble;

  mumuki.kindergarten.resultAction.aborted = mumuki.kindergarten._showOnFailurePopup;

  mumuki.kindergarten.resultAction.failed = mumuki.kindergarten._showOnCharacterBubble;
  mumuki.kindergarten.resultAction.errored = mumuki.kindergarten._showOnCharacterBubble;
  mumuki.kindergarten.resultAction.pending = mumuki.kindergarten._showOnCharacterBubble;


  $(document).ready(() => {
    // Speech initialization
    if (!$bubble.length) return;

    availableTabs.forEach(function (tabSelector) {
      tabParagraphs(tabSelector).contents().unwrap().wrapAll('<p>');
    });

    updateSpeechParagraphs();

    resizeSpeechParagraphs();

    $speechTabs.each(function (i) {
      var $tab = $($speechTabs[i]);
      if ($tab.data('target')) {
        $tab.click(function () {
          $speechTabs.removeClass('active');
          $tab.addClass('active');
          $texts.hide();
          $bubble.children('.' + $tab.data('target')).show();
          updateSpeechParagraphs();
        })
      }
    });

    if (paragraphCount > 1) {
      nextSpeechBlinking = mumuki.setInterval(() => $nextSpeech.fadeTo('slow', 0.1).fadeTo('slow', 1.0), 1000);
    }

    $hint.click(function () {
      animateHint();
      this.classList.remove('blink');
    });

    // States initial resizing
    mumuki.resize(function () {
      var margin = 15;
      var fullMargin = margin * 2;

      let $muKidsStatesContainer = $('.mu-kids-states');
      let $muKidsStates = $('.mu-kids-state');
      let $muKidsBlocks = $('.mu-kids-blocks');
      let $muKidsExercise = $('.mu-kids-exercise');
      let $muKidsExerciseDescription = $('.mu-kids-exercise-description');
      let $muKidsStateImage = $('.mu-kids-state-image');

      distributeAreas($muKidsStateImage, $muKidsStatesContainer, $muKidsBlocks, fullMargin);

      if (!$muKidsExerciseDescription.hasClass('mu-kids-exercise-description-fixed')) {
        $muKidsExerciseDescription.width($muKidsExercise.width() - $muKidsStatesContainer.width() - margin);
      }

      $muKidsStates.each((index, state) => mumuki.kindergarten.scaleState($(state), fullMargin));
      mumuki.kindergarten.scaleBlocksArea($muKidsBlocks);

      if (paragraphCount <= 1) clearInterval(nextSpeechBlinking);

      resizeSpeechParagraphs();
    });
  })
});
