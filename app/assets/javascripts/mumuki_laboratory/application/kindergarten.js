mumuki.load(() => {

  mumuki.isKindergartenExercise = () => !!$('.mu-kindergarten').get(0);

  class MumukiKindergarten extends mumuki.Kids {

    constructor() {
      super();
      this._$contextModalButton = new mumuki.Button($('#mu-kids-context .mu-kindergarten-modal-button.mu-close'));
    }

    initialize() {
      super.initialize();
      this.speech.verifyBrowserSupport();
      this.hint.showOrHideExpandHintButton();
      this.context.showNextOrCloseButton();
      this.resultActions.passed = this._showSuccessPopup.bind(this);
      this.resultActions.passed_with_warnings = this._showSuccessPopup.bind(this);
      this.resultActions.failed = this._showFailurePopup.bind(this);
      this.resultActions.errored = this._showFailurePopup.bind(this);
      this.resultActions.pending = this._showFailurePopup.bind(this);
      this.resultActions.aborted = this.showAbortedPopup.bind(this);
    }

    // ================
    // == Public API ==
    // ================

    showNonAbortedPopup(data, animation_name1, animation_name2) {
      data.guide_finished_by_solution = false;
      this.$submissionResult().html(data.title_html);
      this.$resultsModal().find('.modal-content').removeClass().addClass('modal-content').addClass(data.status);
      super.showNonAbortedPopup(data, animation_name1, animation_name2, 1000);
    }

    // ==================
    // == Hook Methods ==
    // ==================

    _showSuccessPopup(data) {
      this.showNonAbortedPopup(data, 'success_l', 'success2_l');
    }

    _showFailurePopup(data) {
      this.showNonAbortedPopup(data, 'failure', 'failure');
    }

    $contextModalButton() {
      return this._$contextModalButton;
    }

    // ====================
    // == Event Callback ==
    // ====================

    onReady() {
      mumuki.resize(this.onResize.bind(this));
    }

    onResize() {
      this.scaleState(this.$states(), 50);
      this.scaleBlocksArea(this.$blocks());
    }


    // ==========================
    // == Called by the runner ==
    // ==========================

    restart() {
      mumuki.presenterCharacter.playAnimation('talk', this.$characterImage());
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
          this._action('play', 'stop', true, (speech) => speech.speak(msg))
        },
        stop() {
          this._action('stop', 'play', false, (speech) => speech.cancel())
        },
        _action(add, remove, isPlaying, callback = () => {
        }) {
          callback(window.speechSynthesis);
          const $button = $('.mu-kindergarten-play-description')
          $button.find(`.mu-kindergarten-${add}`).addClass('hidden');
          $button.find(`.mu-kindergarten-${remove}`).removeClass('hidden');
          this._isPlaying = isPlaying;
        },
        verifyBrowserSupport() {
          if (!window.speechSynthesis) {
            const $button = $('.mu-kindergarten-play-description')
            $button.prop('disabled', true);
            $button.css('cursor', 'not-allowed');
            this._action('play', 'stop', false)
          }
        }
      }

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
          if (!$hintMedia.get(0)) $button.addClass('hidden');
        },
      }
    }

    get context() {
      return {
        showContext() {
          mumuki.kids.showContext();
          this._showFirstSlideImage();
        },
        nextSlide() {
          this._clickButton('next');
        },
        prevSlide() {
          this._clickButton('prev');
        },
        _imageSlides() {
          return $('.mu-kindergarten-context-image-slides');
        },
        _activeSlideImage() {
          return this._imageSlides().find('.active');
        },
        _clickButton(prevOrNext) {
          this._activeSlideImage().removeClass('active')[prevOrNext]().addClass('active');
          this.showNextOrCloseButton();
          this._hidePreviousButtonIfFirstImage();
        },
        showNextOrCloseButton() {
          const $next = $('.mu-kindergarten-modal-button.mu-next');
          const $close = $('.mu-kindergarten-modal-button.mu-close');
          const isLastChild = this._activeSlideImage().is(':last-child');
          this._addClassIf($next, 'hidden', () => isLastChild);
          this._addClassIf($close, 'hidden', () => !isLastChild);
        },
        _hidePreviousButtonIfFirstImage() {
          const $prev = $('.mu-kindergarten-modal-button.mu-previous');
          this._addClassIf($prev, 'hidden', () => this._activeSlideImage().is(':first-child'))
        },
        _showFirstSlideImage() {
          this._imageSlides().find('img').each((i, el) => this._addClassIf($(el), 'active', () => i === 0))
          this.showNextOrCloseButton();
          this._hidePreviousButtonIfFirstImage();
        },
        _addClassIf(element, clazz, criteria) {
          if (criteria()) {
            element.addClass(clazz)
          } else {
            element.removeClass(clazz);
          }
        }
      }
    }

  }

  if (mumuki.isKindergartenExercise()) {
    mumuki.kids = new MumukiKindergarten();
  }

});
