mumuki.load(() => {
  mumuki.kindergarten = {
    initialize() {
      this.speech.verifyBrowserSupport();
      this.hint.showOrHideExpandHintButton();
      this.context.showNextOrCloseButton();
      this.result.configureCallbacks();
    },
    speech: {
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
        this._action('fa-stop-circle', 'fa-volume-up', true, (speech) => speech.speak(msg))
      },
      stop() {
        this._action('fa-volume-up', 'fa-stop-circle', false, (speech) => speech.cancel())
      },
      _action(add, remove, isPlaying, callback) {
        $('.mu-kindergarten-play-description').children('i').removeClass(remove).addClass(add);
        callback(window.speechSynthesis);
        this._isPlaying = isPlaying;
      },
      verifyBrowserSupport() {
        if (!window.speechSynthesis) {
          const $button = $('.mu-kindergarten-play-description')
          $button.prop('disabled', true);
          $button.css('cursor', 'not-allowed');
          $button.children('i').removeClass('fa-volume-up').addClass('fa-volume-off');
        }
      }
    },
    hint: {
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
    },
    context: {
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
    },
    result: {
      configureCallbacks() {
        mumuki.kids.resultAction.passed = this._showOnSuccessPopup;
        mumuki.kids.resultAction.passed_with_warnings = this._showOnSuccessPopup;

        mumuki.kids.resultAction.failed = this._showOnFailurePopup;
        mumuki.kids.resultAction.errored = this._showOnFailurePopup;
        mumuki.kids.resultAction.pending = this._showOnFailurePopup;
      },
      _showOnSuccessPopup(data) {
        $('.submission-results').html(data.title_html);
        mumuki.kids._showOnSuccessPopup(data);
        $('#kids-results .modal-content').addClass(data.status);
      },
      _showOnFailurePopup() {
        mumuki.kids.submitButton.disable();
        mumuki.kids._getResultsAbortedModal().modal();
        mumuki.presenterCharacter.playAnimation('failure', mumuki.kids._getCharacterImage());
      }
    }
  };

  $(document).ready(() => {

    if ($('.mu-kindergarten').get(0)) {

      mumuki.resize(() => {
        mumuki.kids.scaleState($('.mu-kids-states'), 100);
        mumuki.kids.scaleBlocksArea($('.mu-kids-blocks'));
      })

      mumuki.kindergarten.initialize()

    }

  })

});
