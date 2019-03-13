mumuki.load(function () {
  var $bubble = $('.mu-kids-character-speech-bubble').children('.mu-kids-character-speech-bubble-normal');
  if(!$bubble.length) return;

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
    registerStateScaler: function(scaler) {
      this._stateScaler = scaler;
    },

    // Sets a function that will be called each
    // time the blocks area needs to be resized. The function takes:
    //
    // * $blocks: the blocks area
    //
    // Runners must call this method on within the runner's editor.js extension
    registerBlocksAreaScaler: function(scaler) {
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
    scaleBlocksArea: function($blocks) {
      this._blocksAreaScaler($blocks);
    },

    getResultsModal: function () {
      return $('#kids-results');
    },

    getResultsAbortedModal: function () {
      return $('#kids-results-aborted');
    },

    getCharaterImage: function () {
      return $('.mu-kids-character > img');
    },

    getCharacterBubble: function () {
      return $('.mu-kids-character-speech-bubble');
    },

    getSubmissionResult: function () {
      return $('.submission-results');
    },

    getOverlay: function () {
      return $('.mu-kids-overlay');
    },

    showResult: function (data) {  // This function is called by the custom runner
      mumuki.updateProgressBarAndShowModal(data);
      if (data.guide_finished_by_solution) return;
      mumuki.kids.resultAction[data.status](data);
    },

    restart: function () {  // This function is called by the custom runner
      mumuki.kids._hideMessageOnCharacterBubble();
      var $bubble = mumuki.kids.getCharacterBubble();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.presenterCharacter.playAnimation('jump', mumuki.kids.getCharaterImage());
    },

    _hideMessageOnCharacterBubble: function () {
      var $bubble = mumuki.kids.getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').show();
      $bubble.find('.mu-kids-character-speech-bubble-normal').show();
      $bubble.find('.mu-kids-character-speech-bubble-failed').hide();
      Object.keys(mumuki.kids.resultAction).forEach($bubble.removeClass.bind($bubble));
      mumuki.kids.getOverlay().hide();
    },

    _showMessageOnCharacterBubble: function (data) {
      var $bubble = mumuki.kids.getCharacterBubble();
      $bubble.find('.mu-kids-character-speech-bubble-tabs').hide();
      $bubble.find('.mu-kids-character-speech-bubble-normal').hide();
      $bubble.find('.mu-kids-character-speech-bubble-failed').show().html(data.title_html);
      $bubble.addClass(data.status);
      if (data.status === 'passed_with_warnings') {
        $bubble.find('.mu-kids-character-speech-bubble-failed').append(data.expectations_html);
      }
      mumuki.kids.getOverlay().show();
    },

    _showOnSuccessPopup: function (data) {
      mumuki.kids.getSubmissionResult().html(data.html);
      mumuki.presenterCharacter.playAnimation('success_l', mumuki.kids.getCharaterImage());
      mumuki.kids._showMessageOnCharacterBubble(data);
      mumuki.presenterCharacter.playAnimation('success2_l', $('.mu-kids-character-success'));
      setTimeout(function () {
        var results_kids_modal = mumuki.kids.getResultsModal();
        if (results_kids_modal) {
          results_kids_modal.modal({
            backdrop: 'static',
            keyboard: false
          });
          results_kids_modal.find('.modal-header').first().html(data.title_html);
          results_kids_modal.find('.modal-footer').first().html(data.button_html);
          mumuki.kids._showCorollaryCharacter();
          $('.mu-close-modal').click(() => $('#kids-results').modal('hide'));
        }
      }, 1000 * 4);
    },

    _showOnFailurePopup: function () {
      mumuki.kids.submitButton.disable();
      mumuki.kids.getResultsAbortedModal().modal();
      mumuki.submission.animateTimeoutError(mumuki.kids.submitButton);
    },

    _showOnCharacterBubble: function (data) {
      mumuki.presenterCharacter.playAnimation('failure', mumuki.kids.getCharaterImage());
      mumuki.kids._showMessageOnCharacterBubble(data);
    },

    _showCorollaryCharacter: function () {
      mumuki.characters.magnifying_glass.playAnimation('show', $('.mu-kids-corollary-animation'));
    },

    _stateScaler: function ($state, fullMargin, preferredWidth, preferredHeight) {
      var $table = $state.find('gs-board > table');
      if(!$table.length) return setTimeout(() => this.scaleState($state, fullMargin));

      console.warn("You are using the default states scaler, which is gobstones-specific. Please register your own scaler in the future");

      $table.css('transform', 'scale(1)');
      var scaleX = preferredWidth / $table.width();
      var scaleY = preferredHeight / $table.height();
      $table.css('transform', 'scale(' + Math.min(scaleX, scaleY) + ')');
    },

    _blocksAreaScaler: function($blocks) {
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
    mumuki.presenterCharacter.playAnimation('talk', mumuki.kids.getCharaterImage());
  }

  mumuki.kids.resultAction.passed = mumuki.kids._showOnSuccessPopup;
  mumuki.kids.resultAction.passed_with_warnings = mumuki.kids._showOnCharacterBubble;

  mumuki.kids.resultAction.aborted = mumuki.kids._showOnFailurePopup;

  mumuki.kids.resultAction.failed = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.errored = mumuki.kids._showOnCharacterBubble;
  mumuki.kids.resultAction.pending = mumuki.kids._showOnCharacterBubble;

  $(document).ready(() => {
    // Speech initialization

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

    if(paragraphCount > 1) {
      nextSpeechBlinking = setInterval(() => $nextSpeech.fadeTo('slow', 0.1).fadeTo('slow', 1.0), 1000);
    }

    $nextSpeech.click(showNextParagraph);
    $prevSpeech.click(showPrevParagraph);

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

      resizeSpeechParagraphs();
    });
  })
});
