class MumukiInteractiveExercise {

  constructor() {
    this.submitButton = new mumuki.submission.SubmitButton($('#kids-btn-retry'), $('.submission_control'));
    this.resultActions = {};
    this.initialize();
    $(document).ready(this.onReady.bind(this));
  }

  // ==========
  // Public API
  // ==========

  initialize() {
    this.showContext();
  }

  // Sets a function that will be called each
  // time the states need to be resized. The function takes:
  //
  // * $state: a single state area
  // * fullMargin
  // * preferredWidth
  // * preferredHeight
  //
  // Runners must call this method on within the runner's editor.js extension
  registerStateScaler(scaler) {
    this._stateScaler = scaler;
  }

  // Sets a function that will be called each
  // time the blocks area needs to be resized. The function takes:
  //
  // * $blocks: the blocks area
  //
  // Runners must call this method on within the runner's editor.js extension
  registerBlocksAreaScaler(scaler) {
    this._blocksAreaScaler = scaler;
  }

  // Scales a single state.
  //
  // This method is called by the kids code, but the runner's editor.js extension may need
  // to perform additional calls to it.
  scaleState($state, fullMargin) {
    const preferredWidth = $state.width() - fullMargin * 2;
    const preferredHeight = $state.height() - fullMargin * 2;
    this._stateScaler($state, fullMargin, preferredWidth, preferredHeight);
  }

  // Scales the blocks area.
  //
  // This method is called by the kids code, but the runner's editor.js extension may need
  // to perform additional calls to it.
  scaleBlocksArea($blocks) {
    this._blocksAreaScaler($blocks);
  }

  // Displays the kids results, updating the progress bar
  // firing the modal and running appropriate animations.
  //
  // This method needs to be called by the runner's editor.html extension
  // in order to finish an exercise
  showContext() {
    this.$contextModal().modal({
      backdrop: 'static',
      keyboard: false
    });
  }

  // Displays the interactive results, updating the progress bar
  // firing the modal and running appropriate animations.
  //
  // This method needs to be called by the runner's editor.html extension
  // in order to finish an exercise
  showResult(data) {
    mumuki.progress.updateProgressBarAndShowModal(data);
    if (data.guide_finished_by_solution) return;
    this.resultActions[data.status](data);
  }

  disableContextModalButton() {
    this.$contextModalButton().setWaiting();
  }

  enableContextModalButton() {
    this.$contextModalButton().enable();
  }

  // ===========

  $states() {
    return $('.mu-kids-states');
  }
  $state() {
    return $('.mu-kids-state');
  }

  $blocks() {
    return $('.mu-kids-blocks');
  }

  $exercise() {
    return $('.mu-kids-exercise');
  }

  $exerciseDescription() {
    return $('.mu-kids-exercise-description');
  }

  $stateImage() {
    return $('.mu-kids-state-image');
  }


  // ===========
  // Private API
  // ===========

  _mustImplementThisMethod() {
    throw new Error('TODO: implement method')
  }

  // Restarts the kids exercise.
  //
  // This method may need to be called by the runner's editor.html extension
  // in order to recover from a failed submission
  restart() {
    this._mustImplementThisMethod();
  }

  _showCorollaryCharacter() {
    this._mustImplementThisMethod();
  }

  _updateSubmissionResult(html) {
    return this.$submissionResult().html(html);
  }

  $contextModal() {
    this._mustImplementThisMethod()
  }

  $resultsModal() {
    this._mustImplementThisMethod()
  }

  $resultsAbortedModal() {
    this._mustImplementThisMethod()
  }

  $characterImage() {
    this._mustImplementThisMethod()
  }

  $submissionResult() {
    this._mustImplementThisMethod()
  }

  $contextModalButton() {
    this._mustImplementThisMethod()
  }

  _showOnSuccessPopup() {
    this._mustImplementThisMethod()
  }

  _showOnFailurePopup() {
    this._mustImplementThisMethod()
  }

  _showMessageOnCharacterBubble() {
    this._mustImplementThisMethod();
  }

  openSubmissionResultModal(data) {
    this.$resultsModal().modal({ backdrop: 'static', keyboard: false })
    this.$resultsModal().find('.modal-header').first().html(data.title_html)
    this.$resultsModal().find('.modal-footer').first().html(data.button_html)
    this._showCorollaryCharacter();
    $('.mu-close-modal').click(() => this.$resultsModal().modal('hide'));
  }

  _showOnNonAbortedPopup(data, animation_name1, animation_name2, open_modal_delay_ms = 0) {
    this._updateSubmissionResult(data.html);
    mumuki.presenterCharacter.playAnimation(animation_name1, this.$characterImage());
    this._showMessageOnCharacterBubble(data);
    mumuki.presenterCharacter.playAnimation(animation_name2, $('.mu-kids-character-success'));
    setTimeout(this.openSubmissionResultModal.bind(this, data), open_modal_delay_ms);
  }

  _showOnAbortedPopup(_data) {
    this.submitButton.disable();
    this.$resultsAbortedModal().modal();
    mumuki.submission.animateTimeoutError(this.submitButton);
  }

  _stateScaler($state, fullMargin, preferredWidth, preferredHeight) {
    const $table = $state.find('gs-board > table');
    if (!$table.length) return setTimeout(() => this.scaleState($state, fullMargin));

    console.warn("You are using the default states scaler, which is gobstones-specific. Please register your own scaler in the future");

    $table.css('transform', 'scale(1)');
    const scaleX = preferredWidth / $table.width();
    const scaleY = preferredHeight / $table.height();
    $table.css('transform', 'scale(' + Math.min(scaleX, scaleY) + ')');
  }

  _blocksAreaScaler($blocks) {
    console.warn("You are using the default blocks scaler, which is blockly-specific. Please register your own scaler in the future");

    const $blockArea = $blocks.find('#blocklyDiv');
    const $blockSvg = $blocks.find('.blocklySvg');

    $blockArea.width($blocks.width());
    $blockArea.height($blocks.height());

    $blockSvg.width($blocks.width());
    $blockSvg.height($blocks.height());
  }

  // ======
  // Events
  // ======

  onReady() {
    // SubClasses should override this method
  }

  onResize() {
    // SubClasses should override this method
  }
}
