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
   * Initializes the button, configuring the action that will be called
   * before wating
   */
  start(main) {
    this.main = (e) => {
      e.preventDefault();
      main();
    };
    this.$button.on('click', this.main)
  }

  /**
   * Puts this button into the waiting state,
   * disabling its usage and updating its legend
   */
  wait() {
    this.$button.off('click');

    this.setWaiting();
  }

  /**
   * Puts this button in ready-to-continue state,
   * and sets the given callback to be called before continue.
   *
   * Going through this state is optional.
   */
  ready(secondary) {
    this.$button.off('click');

    this.undisable();
    this.setRetryText();

    this.$button.on('click', (e) => {
      e.preventDefault();
      secondary();
    });
  }

  /**
   * Puts this button again in the normal state,
   * making it ready-to-use.
   */
  continue() {
    this.$button.off('click');

    this.enable();

    this.$button.on('click', this.main)
  }

  // =============
  // Low level API
  // =============

  disable () {
    this.$container.attr('disabled', 'disabled');
  }

  undisable() {
    this.$container.removeAttr('disabled');
  }

  setWaiting () {
    this.preventClick();
    this.setWaitingText();
  }

  enable () {
    this.setOriginalContent();
    this.undisable();
  }

  setWaitingText () {
    this.$button.html('<i class="fa fa-refresh fa-spin"></i> ' + this.$button.attr('data-waiting'));
  }

  setRetryText() {
    this.$button.html('<i class="fa fa-undo"></i>');
  }

  setOriginalContent () {
    this.$button.html(this.originalContent);
  }

  preventClick () {
    this.disable();
    this.$button.on('click', (e) => e.preventDefault());
  }
};

