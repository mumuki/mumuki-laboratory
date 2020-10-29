mumuki.load(() => {
  mumuki.kindergarten = {
    speak(selector, locale) {
      const msg = new SpeechSynthesisUtterance();
      msg.text = $(selector).text();
      msg.lang = locale.split('_')[0];
      msg.pitch = 0;
      window.speechSynthesis.speak(msg);
    },
    showContext() {
      mumuki.kids.showContext();
      this.modal.showFirstSlideImage();
    },
    disablePlaySoundButtonIfNotSupported() {
      if (!window.speechSynthesis) {
        const $button = $('.mu-kindergarten-play-description')
        $button.prop('disabled', true);
        $button.css('cursor', 'not-allowed');
        $button.children('i').removeClass('fa-volume-up').addClass('fa-volume-off');
      }
    },
    toggleHint() {
      $('.mu-kindergarten-light-speech-bubble').toggleClass('open');
    },
    toggleHintMedia() {
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
    modal: {
      _imageSlides() {
        return $('.mu-kindergarten-context-image-slides');
      },
      _activeSlideImage() {
        return this._imageSlides().find('.active');
      },
      clickButton(prevOrNext) {
        this._activeSlideImage().removeClass('active')[prevOrNext]().addClass('active');
        this.showNextOrCloseButton();
        this.hidePreviousButtonIfFirstImage();
      },
      nextSlide() {
        this.clickButton('next');
      },
      prevSlide() {
        this.clickButton('prev');
      },
      showNextOrCloseButton() {
        const $next = $('.mu-kindergarten-modal-button.mu-next');
        const $close = $('.mu-kindergarten-modal-button.mu-close');
        const isLastChild = this._activeSlideImage().is(':last-child');
        this.addClassIf($next, 'hidden', () => isLastChild);
        this.addClassIf($close, 'hidden', () => !isLastChild);
      },
      hidePreviousButtonIfFirstImage() {
        const $prev = $('.mu-kindergarten-modal-button.mu-previous');
        this.addClassIf($prev, 'hidden', () => this._activeSlideImage().is(':first-child'))
      },
      showFirstSlideImage() {
        this._imageSlides().find('img').each((i, el) => this.addClassIf($(el), 'active', () => i === 0))
        this.showNextOrCloseButton();
        this.hidePreviousButtonIfFirstImage();
      },
      addClassIf(element, clazz, criteria) {
        if (criteria()) {
          element.addClass(clazz)
        } else {
          element.removeClass(clazz);
        }
      }
    },
    resultPopup: {
      _showOnSuccessPopup(data) {
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
        mumuki.kids.scaleState($('.mu-kids-states'), 40);
        mumuki.kids.scaleBlocksArea($('.mu-kids-blocks'));
      })

      mumuki.kindergarten.showOrHideExpandHintButton();
      mumuki.kindergarten.disablePlaySoundButtonIfNotSupported();

      mumuki.kindergarten.modal.showNextOrCloseButton();

      mumuki.kids.resultAction.passed = mumuki.kindergarten.resultPopup._showOnSuccessPopup;
      mumuki.kids.resultAction.passed_with_warnings = mumuki.kindergarten.resultPopup._showOnSuccessPopup;

      mumuki.kids.resultAction.failed = mumuki.kindergarten.resultPopup._showOnFailurePopup;
      mumuki.kids.resultAction.errored = mumuki.kindergarten.resultPopup._showOnFailurePopup;
      mumuki.kids.resultAction.pending = mumuki.kindergarten.resultPopup._showOnFailurePopup;

    }

  })

});
