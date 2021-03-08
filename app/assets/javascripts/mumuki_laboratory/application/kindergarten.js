mumuki.load(() => {

  mumuki.isKindergartenExercise = () => !!$('.mu-kindergarten').get(0);

  class MumukiKindergarten extends mumuki.Kids {

    constructor() {
      super();
    }

    initialize() {
      super.initialize();
      this.$contextModalButton = new mumuki.Button($('#mu-kids-context .mu-kids-modal-button.mu-close'));

      this.resultActions.passed = this._showSuccessPopup.bind(this);
      this.resultActions.passed_with_warnings = this._showPassedWithWarnings.bind(this);
      this.resultActions.failed = this._showFailurePopup.bind(this);
      this.resultActions.errored = this._showFailurePopup.bind(this);
      this.resultActions.pending = this._showFailurePopup.bind(this);
      this.resultActions.aborted = this.showAbortedPopup.bind(this);

      this.speech.verifyBrowserSupport();
      this.hint.showOrHideExpandHintButton();
      this.context.showNextOrCloseButton();
    }

    // ================
    // == Public API ==
    // ================

    showNonAbortedPopup(data, animation_name) {
      this.$submissionResult.html(data.title_html);
      this.$resultsModal.find('.modal-content').removeClass().addClass('modal-content kindergarten').addClass(data.status);
      super.showNonAbortedPopup(data, animation_name);
    }

    showAbortedPopup(data) {
      const $closeResultAbortedModalButton = new mumuki.Button(this.$resultsAbortedModal.find('.mu-close'));
      $closeResultAbortedModalButton.setWaiting();
      mumuki.presenterCharacter.playAnimation('failed', $('.mu-kids-character-result-aborted'));
      super.showAbortedPopup(data);
      setTimeout(() => $closeResultAbortedModalButton.enable(), 2500);
    }

    // ==================
    // == Hook Methods ==
    // ==================

    _showSuccessPopup(data) {
      this.showNonAbortedPopup(data, 'success2_l');
    }

    _showPassedWithWarnings(data) {
      this.showNonAbortedPopup(data, 'passed_with_warnings');
    }

    _showFailurePopup(data) {
      this.showNonAbortedPopup(data, 'failure');
    }

    // ====================
    // == Event Callback ==
    // ====================

    onReady() {
      mumuki.resize(this.onResize.bind(this));
    }

    onResize() {
      this.scaleState(this.$states, 50);
      this.scaleBlocksArea(this.$blocks);
    }

    // ==========================
    // == Called by the runner ==
    // ==========================

    showResult(data) {
      data.guide_finished_by_solution = false;
      super.showResult(data);
    }

    restart() {
      mumuki.presenterCharacter.playAnimation('talk', this.$bubbleCharacterAnimation);
      this.hideOverlay();
    }

    // =======================
    // == Specific Behavior ==
    // =======================

    get speech() {
      return {
        _isPlaying: false,
        click(selector, locale) {
          if (this._isPlaying) {
            this.stop();
          } else {
            this.play(selector, locale);
          }
        },
        play(selector, locale) {
          const msg = new SpeechSynthesisUtterance();
          msg.text = $(selector).text();
          msg.lang = locale.split('_')[0];
          msg.pitch = 0;
          msg.onend = () => this.stop();
          this._action('play', 'stop', true, (speech) => {
            mumuki.presenterCharacter.playAnimation('talk', mumuki.kids.$bubbleCharacterAnimation);
            speech.speak(msg);
          });
        },
        stop() {
          this._action('stop', 'play', false, (speech) => speech.cancel());
        },
        _action(add, remove, isPlaying, callback) {
          callback(window.speechSynthesis);
          const $button = $('.mu-kindergarten-play-description');
          $button.find(`.mu-kindergarten-${add}`).addClass('d-none');
          $button.find(`.mu-kindergarten-${remove}`).removeClass('d-none');
          this._isPlaying = isPlaying;
        },
        verifyBrowserSupport() {
          if (!window.speechSynthesis) {
            const $button = $('.mu-kindergarten-play-description');
            $button.prop('disabled', true);
            $button.css('cursor', 'not-allowed');
            this._action('play', 'stop', false);
          }
        }
      };

    }

    get hint() {
      return {
        toggle() {
          $('.mu-kindergarten-light-speech-bubble').toggleClass('open');
        },
        toggleMedia() {
          const $hintMedia = $('.mu-kindergarten-hint-media');
          const $i = $('.expand-or-collapse-hint-media').children('i');
          $i.toggleClass('fa-caret-up').toggleClass('fa-caret-down');
          $hintMedia.toggleClass('closed');
        },
        showOrHideExpandHintButton() {
          const $button = $('.expand-or-collapse-hint-media');
          const $hintMedia = $('.mu-kindergarten-hint-media');
          if (!$hintMedia.get(0)) $button.addClass('d-none');
        },
      };
    }

    get context() {
      return new mumuki.ModalCarrousel('.mu-kindergarten-context-image-slides', () => mumuki.kids.showContext());
    }

  }

  if (mumuki.isKindergartenExercise()) {
    mumuki.kids = new MumukiKindergarten();
  }

});
