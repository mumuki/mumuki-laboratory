mumuki.progress = (() => {
  /**
   * Updates the current exercise progress indicator
   *
   * @param {SubmissionResult} result
   * */
  function updateProgressBarAndShowModal(result) {
    $('.progress-list-item.active').attr('class', result.class_for_progress_list_item);
    if(result.guide_finished_by_solution) new bootstrap.Modal('#guide-done').show();
  }

  /**
   * Update all links in the progress bar with the given function
   *
   * @param {(anchor: JQuery) => string} f
   */
  function updateWholeProgressBar(f) {
    $('.progress-list-item').each((_, it) => {
      const $anchor = $(it);
      $anchor.attr('class', f($anchor));
    });
  }

  return {
    updateProgressBarAndShowModal,
    updateWholeProgressBar
  };
})();

/** @deprecated use {@code mumuki.progress.updateProgressBarAndShowModal} instead */
mumuki.updateProgressBarAndShowModal = mumuki.progress.updateProgressBarAndShowModal;
