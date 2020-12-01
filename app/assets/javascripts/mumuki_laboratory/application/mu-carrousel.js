mumuki.Carrousel = (() => {

  class MuCarrousel {
    constructor(containerSelector, onShow = () => {}) {
      this.$container = $(containerSelector);
      this.onShow = onShow;
    }

    show() {
      this.onShow();
      this._showFirstSlide();
    }

    nextSlide() {
      this._clickButton('next');
    }

    prevSlide() {
      this._clickButton('prev');
    }

    _activeSlide() {
      return this.$container.find('.active');
    }

    _clickButton(prevOrNext) {
      this._activeSlide().removeClass('active')[prevOrNext]().addClass('active');
      this.showNextOrCloseButton();
      this._hidePreviousButtonIfFirstSlide();
    }

    showNextOrCloseButton() {
      const $next = $('.mu-kindergarten-modal-button.mu-next');
      const $close = $('.mu-kindergarten-modal-button.mu-close');
      const isLastChild = this._activeSlide().is(':last-child');
      this._addClassIf($next, 'hidden', () => isLastChild);
      this._addClassIf($close, 'hidden', () => !isLastChild);
    }

    _hidePreviousButtonIfFirstSlide() {
      const $prev = $('.mu-kindergarten-modal-button.mu-previous');
      this._addClassIf($prev, 'hidden', () => this._activeSlide().is(':first-child'))
    }

    _showFirstSlide() {
      this.$container.children().each((i, el) => this._addClassIf($(el), 'active', () => i === 0));
      this.showNextOrCloseButton();
      this._hidePreviousButtonIfFirstSlide();
    }

    _addClassIf(element, clazz, criteria) {
      if (criteria()) {
        element.addClass(clazz);
      } else {
        element.removeClass(clazz);
      }
    }
  }

  return MuCarrousel;
})();
