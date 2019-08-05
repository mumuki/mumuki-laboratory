mumuki.Button = class {

  constructor($button, $container) {
    this.$button = $button;
    this.$container = $container || $button;
    this.originalContent = $button.html();
  }

  disable () {
    this.$container.attr('disabled', 'disabled');
  }

  setWaiting () {
    this.preventClick();
    this.setWaitingText();
  }

  enable () {
    this.setOriginalContent();
    this.$container.removeAttr('disabled');
  }

  setWaitingText () {
    this.$button.html('<i class="fa fa-refresh fa-spin"></i> ' + this.$button.attr('data-waiting'));
  }

  setOriginalContent () {
    this.$button.html(this.originalContent);
  }

  preventClick () {
    this.disable();
    this.$button.on('click', (e) => e.preventDefault());
  }
};

