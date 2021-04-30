mumuki.load(() => {

  mumuki.isPrimaryExercise = () => !!$('.mu-kids-exercise').get(0) && !$('.mu-kindergarten').get(0);

  class MumukiPrimary extends mumuki.Kids {

    constructor() {
      super();
    }

    // ================
    // == Public API ==
    // ================

    initialize() {
      super.initialize();
      this.$characterSpeechBubble = $('.mu-kids-character-speech-bubble');
      this.$characterSpeechBubbleNormal = this.$characterSpeechBubble.children('.mu-kids-character-speech-bubble-normal');
      this.$contextModalButton = new mumuki.Button($('.mu-kids-context .modal-footer button'));

      this._paragraphHeight = undefined;
      this._currentParagraphIndex = 0;
      this._paragraphCount = 1;
      this._paragraphsLines = 2;
      this._availableTabs = ['.description', '.hint'];
      this._$speechParagraphs = undefined;
      this._paragraphHeight = undefined;
      this._scrollHeight = undefined;
      this._nextSpeechBlinking = undefined;
      this._$prevSpeech = $('.mu-kids-character-speech-bubble-normal > .mu-kids-prev-speech').hide();
      this._$nextSpeech = $('.mu-kids-character-speech-bubble-normal > .mu-kids-next-speech');
      this._$speechTabs = $('.mu-kids-character-speech-bubble-tabs > li:not(.separator)');
      this._$texts = this.$characterSpeechBubbleNormal.children(this._availableTabs.join(", "));
      this._$hint = $('.mu-kids-hint');
      this._$description = $('.mu-kids-description');

      this.resultActions.passed = this._showSuccessPopup.bind(this);
      this.resultActions.passed_with_warnings = this._showOnCharacterBubble.bind(this);
      this.resultActions.failed = this._showOnCharacterBubble.bind(this);
      this.resultActions.errored = this._showOnCharacterBubble.bind(this);
      this.resultActions.pending = this._showOnCharacterBubble.bind(this);
      this.resultActions.aborted = this.showAbortedPopup.bind(this);

      this.$contextModal.on('hidden.bs.modal', this.animateSpeech.bind(this));
    }

    showAbortedPopup(data) {
      super.showAbortedPopup(data);
      mumuki.submission.animateTimeoutError(this.submitButton);
    }

    // ==================
    // == Hook Methods ==
    // ==================

    _showSuccessPopup(data) {
      this.showNonAbortedPopup(data, 'success2_l', 4000);
    }

    _showPassedWithWarnings(data) {
      this.showNonAbortedPopup(data, 'passed_with_warnings', 4000);
    }

    _showFailurePopup(data) {
      this._showOnCharacterBubble(data);
    }

    // ====================
    // == Event Callback ==
    // ====================

    onReady() {
      mumuki.resize(this.onResize.bind(this));

      this._availableTabs.forEach((selector) => this._tabParagraphs(selector).contents().unwrap().wrapAll('<p>'));

      this._updateSpeechParagraphs();
      this._resizeSpeechParagraphs();

      this._$speechTabs.each((i) => {
        const $tab = $(this._$speechTabs[i]);
        if ($tab.data('bs-target')) {
          $tab.click(() => {
            this._$speechTabs.removeClass('active');
            $tab.addClass('active');
            this._$texts.hide();
            this.$characterSpeechBubbleNormal.children('.' + $tab.data('bs-target')).show();
            this._updateSpeechParagraphs();
          });
        }
      });

      if (this._paragraphCount > 1) {
        this._nextSpeechBlinking = mumuki.setInterval(() => this._$nextSpeech.fadeTo('slow', 0.1).fadeTo('slow', 1.0), 1000);
      }

      this._$nextSpeech.click(this._showNextParagraph.bind(this));
      this._$prevSpeech.click(this._showPrevParagraph.bind(this));
      this._$description.click(this.animateSpeech.bind(this));

      this._$hint.click(() => {
        this.animateHint();
        this._$hint.removeClass('blink');
      });
    }

    onResize() {
      const FULL_MARGIN = 30;

      distributeAreas(this.$stateImage, this.$states, this.$blocks, FULL_MARGIN);

      if (!this.$exerciseDescription.hasClass('mu-kids-exercise-description-fixed')) {
        this.$exerciseDescription.width(this.$exercise.width() - this.$states.width() - FULL_MARGIN / 2);
      }

      this.$state.each((_index, state) => this.scaleState($(state), FULL_MARGIN));
      this.scaleBlocksArea(this.$blocks);

      if (this._paragraphCount <= 1) clearInterval(this._nextSpeechBlinking);

      this._updateSpeechParagraphs();
      this._resizeSpeechParagraphs();
    }

    onNonAbortedPopupCall(data) {
      this._showMessageOnCharacterBubble(data);
    }

    onSubmissionResultModalOpen(data) {
      this._showCorollaryCharacter();
      super.onSubmissionResultModalOpen(data);
    }

    // ==========================
    // == Called by the runner ==
    // ==========================

    restart() {
      this._hideMessageOnCharacterBubble();
      const $bubble = this.$characterSpeechBubble;
      Object.keys(this.resultActions).forEach($bubble.removeClass.bind($bubble));
      mumuki.presenterCharacter.playAnimation('talk', this.$bubbleCharacterAnimation);
      this.hideOverlay();
    }

    // =======================
    // == Specific Behavior ==
    // =======================

    _hideMessageOnCharacterBubble() {
      const $bubble = this.$characterSpeechBubble;
      $bubble.find('.mu-kids-character-speech-bubble-tabs').show();
      $bubble.find('.mu-kids-character-speech-bubble-normal').show();
      $bubble.find('.mu-kids-character-speech-bubble-failed').addClass('d-none').removeClass('d-block');
      $bubble.find('.mu-kids-discussion-link').remove();
      Object.keys(this.resultActions).forEach($bubble.removeClass.bind($bubble));
    }

    _showMessageOnCharacterBubble(data) {
      const renderer = new mumuki.renderers.speechBubble.SpeechBubbleRenderer(this.$characterSpeechBubble);
      renderer.setDiscussionsLinkHtml($('#mu-kids-discussion-link-html').html());
      renderer.setResponseData(data);
      renderer.render();
    }

    _showOnCharacterBubble(data) {
      mumuki.presenterCharacter.playAnimation('failure', this.$bubbleCharacterAnimation);
      this._showMessageOnCharacterBubble(data);
    }

    _showCorollaryCharacter() {
      mumuki.characters.magnifying_glass.playAnimation('show', $('.mu-kids-corollary-animation'));
    }

    animateSpeech() {
      mumuki.presenterCharacter.playAnimation('talk', this.$bubbleCharacterAnimation);
    }

    animateHint() {
      mumuki.presenterCharacter.playAnimation('hint', this.$bubbleCharacterAnimation);
    }

    _showPrevParagraph() {
      this.animateSpeech();
      this._showParagraph(this._currentParagraphIndex - 1);
    }

    _showNextParagraph() {
      this.animateSpeech();
      this._showParagraph(this._currentParagraphIndex + 1);
      clearInterval(this._nextSpeechBlinking);
    }

    _resizeSpeechParagraphs(paragraphIndex) {
      const previousParagraphCount = this._paragraphCount;
      this._scrollHeight = this.$characterSpeechBubbleNormal[0].scrollHeight;
      this._paragraphHeight = floatFromPx(this._$speechParagraphs.css('line-height')) * this._paragraphsLines;
      this._paragraphCount = Math.ceil(this._scrollHeight / this._paragraphHeight);
      const newParagraphIndex = Math.floor((this._paragraphCount / previousParagraphCount) * this._currentParagraphIndex);
      this._showParagraph(paragraphIndex || newParagraphIndex);
    }

    _showParagraph(index) {
      this.$characterSpeechBubbleNormal[0].scrollTop = index * this._paragraphHeight;
      this._currentParagraphIndex = index;
      this._checkArrowsSpeechVisibility();
    }

    _checkArrowsSpeechVisibility() {
      this._setVisibility(this._$prevSpeech, this._currentParagraphIndex !== 0);
      this._setVisibility(this._$nextSpeech, this._currentParagraphIndex !== this._paragraphCount - 1);
    }

    _setVisibility(element, isVisible) {
      isVisible ? element.show() : element.hide();
    }

    _tabParagraphs(selector) {
      return $('.mu-kids-character-speech-bubble > .mu-kids-character-speech-bubble-normal > div' + selector + ' > p');
    }

    _updateSpeechParagraphs() {
      this._$speechParagraphs = this._tabParagraphs('.' + this._getSelectedTabName());
      this._resizeSpeechParagraphs(0);
    }

    _getSelectedTabName() {
      return this._$speechTabs.filter('.active').data('bs-target') || 'description';
    }

  }

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
      const ratio = $muKidsStatesContainer.hasClass('mu-kids-single-state') ? 1 : 2;
      $muKidsStatesContainer.width($muKidsStatesContainer.height() / ratio * 1.25 - fullMargin);
    } else {
      $muKidsStatesContainer.width(0);
      $muKidsBlocks.width('100%');
    }
  }

  function floatFromPx(value) {
    return parseFloat(value.substring(0, value.length - 2));
  }

  if (mumuki.isPrimaryExercise()) {
    mumuki.kids = new MumukiPrimary();
  }

});
