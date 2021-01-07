/**
 * A generic button component.
 *
 * It exposes three APIs: low level, common and high level.
 *
 * The low level allows you to control all aspects of the button, but it is legacy
 * and should not be used in new code.
 *
 * The common API offers the start function, which can be used under both the low
 * and high level APIs to configure the initial on-click button handler.
 *
 * The high level allows to implement a simple state-like button handling
 * that goes as follow:
 *
 * 1. simple flow: {init} -start-> {enabled} -wait-> {waiting} -continue-> {enabled}
 * 2. extended flow: {init} -start-> {enabled} -wait-> {waiting} -ready-> {ready-to-continue} -continue-> {enabled}
 */
mumuki.Button = class {

  constructor($button, $container) {
    this.$button = $button;
    this.$container = $container || $button;
    this.originalContent = $button.html();
  }

  // ==========
  // Common API
  // ==========

  /**
   * Initializes the button, configuring the action that will be called
   * before wating, moving it into the {enabled} state.
   */
  start(main) {
    this.main = (e) => {
      e.preventDefault();
      main();
    };
    this.$button.on('click', this.main);
  }

  // ==============
  // High level API
  // ==============

  /**
   * Moves this button into the {waiting} state,
   * disabling its usage and updating its legend
   */
  wait() {
    this.$button.off('click');
    this.setWaiting();
  }

  /**
   * Moves this button into {ready-to-continue} state,
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
   * Puts this button back in the {enabled} state,
   * making it ready-to-use.
   */
  continue() {
    this.$button.off('click');
    this.enable();

    this.$button.on('click', this.main);
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
    this.$button.html('<i class="fas fa-sync-alt fa-spin"></i> ' + this.$button.attr('data-waiting'));
  }

  setRetryText() {
    this.$button.html('<i class="fas fa-undo"></i>');
  }

  setOriginalContent () {
    this.$button.html(this.originalContent);
  }

  preventClick () {
    this.disable();
    this.$button.on('click', (e) => e.preventDefault());
  }
};

