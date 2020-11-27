mumuki.Kids = class {

  constructor() {
    this.initialize();
    this.showContext();
    $(document).ready(this.onReady.bind(this));
  }

  // ================
  // == Public API ==
  // ================

  initialize() {
    this.submitButton = new mumuki.submission.SubmitButton($('#kids-btn-retry'), $('.submission_control'));
    this.resultActions = {};
    this.$states = $('.mu-kids-states');
    this.$state = $('.mu-kids-state');
    this.$blocks = $('.mu-kids-blocks');
    this.$exercise = $('.mu-kids-exercise');
    this.$exerciseDescription = $('.mu-kids-exercise-description');
    this.$stateImage = $('.mu-kids-state-image');
    this.$contextModal = $('#mu-kids-context');
    this.$resultsModal = $('#kids-results');
    this.$resultsAbortedModal = $('#kids-results-aborted');
    this.$bubbleCharacterAnimation = $('.mu-kids-character-animation');
    this.$submissionResult =  $('.submission-results');
  }

  showContext() {
    this.$contextModal.modal({
      backdrop: 'static',
      keyboard: false
    });
  }

  showNonAbortedPopup(data, animation_name, open_modal_delay_ms = 0) {
    this.$submissionResult.html(data.html);
    mumuki.presenterCharacter.playAnimation(animation_name, $('.mu-kids-character-result'));
    setTimeout(() => this._openSubmissionResultModal(data), open_modal_delay_ms);
    this.onNonAbortedPopupCall(data);
  }

  showAbortedPopup(_data) {
    this.submitButton.disable();
    this.$resultsAbortedModal.modal();
  }

  // ==================
  // == Hook Methods ==
  // ==================

  _showSuccessPopup() {
    this._mustImplementThisMethod()
  }

  _showFailurePopup() {
    this._mustImplementThisMethod()
  }

  // ====================
  // == Event Callback ==
  // ====================

  onReady() {
    // SubClasses may override this method
  }

  onResize() {
    // SubClasses may override this method
  }

  onNonAbortedPopupCall(_data) {
    // SubClasses may override this method
  }

  onSubmissionResultModalOpen(_data) {
    // SubClasses may override this method
  }

  // =================
  // == Private API ==
  // =================

  _openSubmissionResultModal(data) {
    this.$resultsModal.modal({ backdrop: 'static', keyboard: false });
    this.$resultsModal.find('.modal-header').first().html(data.title_html);
    mumuki.numberCounter('.mu-experience');
    this.$resultsModal.find('.modal-footer').first().html(data.button_html);
    $('.mu-close-modal').click(() => this.$resultsModal.modal('hide'));
    this.onSubmissionResultModalOpen(data);
  }

  // ==========================
  // == Called by the runner ==
  // ==========================

  // Displays the exercise results, updating the progress bar
  // firing the modal and running appropriate animations.
  //
  // This method needs to be called by the runner's editor.html extension
  // in order to finish an exercise
  showResult(data) {
    mumuki.progress.updateProgressBarAndShowModal(data);
    if (data.guide_finished_by_solution) return;
    this.resultActions[data.status](data);
  }

  // Restarts the kids exercise.
  //
  // This method may need to be called by the runner's editor.html extension
  // in order to recover from a failed submission
  restart() {
    this._mustImplementThisMethod();
  }

  // =================================
  // == Called by the assets loader ==
  // =================================

  disableContextModalButton() {
    this.$contextModalButton.setWaiting();
  }

  enableContextModalButton() {
    this.$contextModalButton.enable();
  }

  // ============
  // == Helper ==
  // ============

  _mustImplementThisMethod() {
    throw new Error('TODO: implement method')
  }

  // ============
  // == Scaler ==
  // ============

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

}
