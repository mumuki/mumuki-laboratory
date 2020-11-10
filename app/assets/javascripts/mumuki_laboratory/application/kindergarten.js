mumuki.load(() => {
  mumuki.kindergarten = {
    initialize() {
      this.speech.verifyBrowserSupport();
      this.hint.showOrHideExpandHintButton();
      this.context.showNextOrCloseButton();
      this.result.configureCallbacks();
    },
    isAvailable() {
      return !!$('.mu-kindergarten').get(0);
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
        this._action('play', 'stop', true, (speech) => speech.speak(msg))
      },
      stop() {
        this._action('stop', 'play', false, (speech) => speech.cancel())
      },
      _action(add, remove, isPlaying, callback = () => {}) {
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
        mumuki.kids.resultAction.passed = this._showSuccessOnPopup;
        mumuki.kids.resultAction.passed_with_warnings = this._showSuccessOnPopup;
        mumuki.kids.resultAction.failed = this._showOnFailurePopup;
        mumuki.kids.resultAction.errored = this._showOnFailurePopup;
        mumuki.kids.resultAction.pending = this._showOnFailurePopup;

        mumuki.kindergarten.result._show = mumuki.kids.showResult;
        mumuki.kids.showResult = mumuki.kindergarten.result.show.bind(mumuki.kids);
      },
      show(data) {
          data.guide_finished_by_solution = false;
          mumuki.kindergarten.result._show(data);
      },
      _showOnPopup(data) {
        $('.submission-results').html(data.title_html);
        $('#kids-results .modal-content').removeClass().addClass('modal-content').addClass(data.status);
        mumuki.kids._showOnSuccessPopup(data);
      },
      _showSuccessOnPopup(data) {
        data.animation = 'success_l';
        mumuki.kindergarten.result._showOnPopup(data);
      },
      _showOnFailurePopup(data) {
        data.animation = 'failure';
        mumuki.kindergarten.result._showOnPopup(data);
      }
    }
  };

  $(document).ready(() => {

    if (mumuki.kindergarten.isAvailable()) {

      mumuki.resize(() => {
        mumuki.kids.scaleState($('.mu-kids-states'), 50);
        mumuki.kids.scaleBlocksArea($('.mu-kids-blocks'));
      })

      mumuki.kindergarten.initialize();

    }

  })

});
