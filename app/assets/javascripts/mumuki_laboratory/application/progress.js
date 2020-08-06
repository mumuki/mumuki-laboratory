mumuki.progress = (() => {
  /**
   * Updates the current exercise progress indicator
   *
   * @param {SubmissionResult} data
   * */
  function updateProgressBarAndShowModal(data) {
    $('.progress-list-item.active').attr('class', data.class_for_progress_list_item);
    if(data.guide_finished_by_solution) $('#guide-done').modal();
  };

  /**
   * Update all links in the progress bar with the given function
   *
   * @param {(anchor: JQuery) => string} f
   */
  function updateWholeProgressBar(f) {
    $('.progress-list-item').each((_, it) => {
      const $anchor = $(it);
      $anchor.attr('class', f($anchor))
    });
  }

  return {
    updateProgressBarAndShowModal,
    updateWholeProgressBar
  };
})();

/** @deprecated use {@code mumuki.progress.updateProgressBarAndShowModal} instead */
mumuki.updateProgressBarAndShowModal = mumuki.progress.updateProgressBarAndShowModal;
