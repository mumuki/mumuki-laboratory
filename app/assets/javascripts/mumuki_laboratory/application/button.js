mumuki.Button = class {

  constructor($button, $container) {
    this.$button = $button;
    this.$container = $container || $button;
    this.originalContent = $button.html();
  }

  // ==============
  // High level API
  // ==============

  /**
   * Puts this button into the waiting state,
   * disabling its usage and updating its legend
   */
  wait() {
    this.setWaiting();
  }

  /**
   * Puts this button again in the normal state,
   * making it ready-to-use.
   */
  continue() {
    this.enable();
  }

  // =============
  // Low level API
  // =============

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

