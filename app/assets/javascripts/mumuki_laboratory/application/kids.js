mumuki.load(function () {
  var $bubble = $('.mu-kids-character-speech-bubble').children('.mu-kids-character-speech-bubble-normal');

  var availableTabs = ['.description', '.hint'];
  var $speechParagraphs, paragraphHeight, scrollHeight, nextSpeechBlinking;
  var currentParagraphIndex = 0;
  var paragraphCount = 1;
  var paragraphsLines = 2;
  var $prevSpeech = $('.mu-kids-character-speech-bubble-normal > .mu-kids-prev-speech').hide();
  var $nextSpeech = $('.mu-kids-character-speech-bubble-normal > .mu-kids-next-speech');
  var $speechTabs = $('.mu-kids-character-speech-bubble-tabs > li:not(.separator)');
  var $defaultSpeechTabName = 'description';
  var $texts = $bubble.children(availableTabs.join(", "));
  var $hint = $('.mu-kids-hint');
  var $description = $('.mu-kids-description');
  var discussionsLinkHtml = $('#mu-kids-discussion-link-html').html();
  var contextModalButton = new mumuki.Button($('.mu-kids-context .modal-footer button'));

  function floatFromPx(value) {
    return parseFloat(value.substring(0, value.length - 2));
  }

  function resizeSpeechParagraphs(paragraphIndex) {
    var previousParagraphCount = paragraphCount;
    scrollHeight = $bubble[0].scrollHeight;
    paragraphHeight = floatFromPx($speechParagraphs.css('line-height')) * paragraphsLines;
    paragraphCount = Math.ceil(scrollHeight / paragraphHeight);
    var newParagraphIndex = Math.floor((paragraphCount / previousParagraphCount) * currentParagraphIndex);
    showParagraph(paragraphIndex || newParagraphIndex);
  }

  function tabParagraphs(selector) {
    return $('.mu-kids-character-speech-bubble > .mu-kids-character-speech-bubble-normal > div' + selector + ' > p');
  }

  function updateSpeechParagraphs() {
    $speechParagraphs = tabParagraphs('.' + getSelectedTabName());
    resizeSpeechParagraphs(0);
  }

  function getSelectedTabName() {
    return $speechTabs.filter(".active").data('target') || $defaultSpeechTabName;
  }

  function showParagraph(index) {
    $bubble[0].scrollTop = index * paragraphHeight;
    currentParagraphIndex = index;
    checkArrowsSpeechVisibility();
  }

  function checkArrowsSpeechVisibility() {
    setVisibility($prevSpeech, currentParagraphIndex !== 0);
    setVisibility($nextSpeech, currentParagraphIndex !== paragraphCount - 1);
  }

  function setVisibility(element, isVisible) {
    isVisible ? element.show() : element.hide();
  }

  mumuki.kids = {

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
      mumuki.kids.resultAction[data.status](data);
    },

    // Restarts the kids exercise.
    //
    // This method may need to be called by the runner's editor.html extension
    // in order to recover from a failed submission
    restart: function () {
      mumuki.kids._hideMessageOnCharacterBubble();
      var $bubble = mumuki.kids._getCharacterBubble();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.presenterCharacter.playAnimation('talk', mumuki.kids._getCharacterImage());
    },

    disableContextModalButton: function () {
      contextModalButton.setWaiting();
    },

    enableContextModalButton: function () {
      contextModalButton.enable();
    },

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
      var $bubble = mumuki.kids._getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').show();
      $bubble.find('.mu-kids-character-speech-bubble-normal').show();
      $bubble.find('.mu-kids-character-speech-bubble-failed').hide();
      $bubble.find('.mu-kids-discussion-link').remove();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.kids._getOverlay().hide();
    },

    _showMessageOnCharacterBubble: function (data) {
      var $bubble = mumuki.kids._getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').hide();
      $bubble.find('.mu-kids-character-speech-bubble-normal').hide();
      $bubble.find('.mu-kids-character-speech-bubble-failed').show().html(data.title_html);
      $bubble.addClass(data.status);
      if (data.status === 'passed_with_warnings') {
        $bubble.find('.mu-kids-character-speech-bubble-failed').append(data.expectations_html);
      }
      if (this._shouldDisplayDiscussionsLink(data.status)) {
        $bubble.append(discussionsLinkHtml);
      }
      mumuki.kids._getOverlay().show();
    },

    _shouldDisplayDiscussionsLink: function (status) {
      return ['failed', 'passed_with_warnings'].some(it => it === status);
    },

    _showOnSuccessPopup: function (data) {
      mumuki.kids._updateSubmissionResult(data.html);
      mumuki.presenterCharacter.playAnimation('success_l', mumuki.kids._getCharacterImage());
      mumuki.kids._showMessageOnCharacterBubble(data);
      mumuki.presenterCharacter.playAnimation('success2_l', $('.mu-kids-character-success'));
      setTimeout(function () {
        var $resultsKidsModal = mumuki.kids._getResultsModal();
        if ($resultsKidsModal) {
          $resultsKidsModal.modal({
            backdrop: 'static',
            keyboard: false
          });
          $resultsKidsModal.find('.modal-header').first().html(data.title_html);
          $resultsKidsModal.find('.modal-footer').first().html(data.button_html);
          mumuki.kids._showCorollaryCharacter();
          $('.mu-close-modal').click(() => mumuki.kids._getResultsModal().modal('hide'));
        }
      }, 1000 * 4);
    },

    _showOnFailurePopup: function () {
      mumuki.kids.submitButton.disable();
      mumuki.kids._getResultsAbortedModal().modal();
      mumuki.submission.animateTimeoutError(mumuki.kids.submitButton);
    },

    _showOnCharacterBubble: function (data) {
      mumuki.presenterCharacter.playAnimation('failure', mumuki.kids._getCharacterImage());
      mumuki.kids._showMessageOnCharacterBubble(data);
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

  mumuki.kids.submitButton = new mumuki.submission.SubmitButton($('#kids-btn-retry'), $('.submission_control'));

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
    mumuki.presenterCharacter.playAnimation('talk', mumuki.kids._getCharacterImage());
  }

  function animateHint() {
    mumuki.presenterCharacter.playAnimation('hint', mumuki.kids._getCharacterImage());
  }

  mumuki.kids.resultAction.passed = mumuki.kids._showOnSuccessPopup;
  mumuki.kids.resultAction.passed_with_warnings = mumuki.kids._showOnCharacterBubble;

  mumuki.kids.resultAction.aborted = mumuki.kids._showOnFailurePopup;

  mumuki.kids.resultAction.failed = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.errored = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.pending = mumuki.kids._showOnCharacterBubble;

  $('.mu-kids-context').on('hidden.bs.modal', function () {
    animateSpeech();
  });

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
      $tab.click(function () {
        $speechTabs.removeClass('active');
        $tab.addClass('active');
        $texts.hide();
        $bubble.children('.' + $tab.data('target')).show();
        updateSpeechParagraphs();
      })
    });

    if (paragraphCount > 1) {
      nextSpeechBlinking = mumuki.setInterval(() => $nextSpeech.fadeTo('slow', 0.1).fadeTo('slow', 1.0), 1000);
    }

    $nextSpeech.click(showNextParagraph);
    $prevSpeech.click(showPrevParagraph);
    $description.click(animateSpeech);

    $hint.click(function () {
      animateHint();
      this.classList.remove('blink');
    });

    // States initial resizing

    mumuki.resize(function () {
      var margin = 15;
      var fullMargin = margin * 2;

      var $muKidsStatesContainer = $('.mu-kids-states');
      var $muKidsStates = $('.mu-kids-state');

      var dimension = $muKidsStatesContainer.height() / 2 * 1.25 - fullMargin;
      $muKidsStatesContainer.width(dimension);

      var $muKidsExercise = $('.mu-kids-exercise');
      var $muKidsExerciseDescription = $('.mu-kids-exercise-description');

      $muKidsExerciseDescription.width($muKidsExercise.width() - $muKidsStatesContainer.width() - margin);

      $muKidsStates.each((index, state) => mumuki.kids.scaleState($(state), fullMargin));
      mumuki.kids.scaleBlocksArea($('.mu-kids-blocks'));

      if (paragraphCount <= 1) clearInterval(nextSpeechBlinking);

      resizeSpeechParagraphs();
    });
  })
});
