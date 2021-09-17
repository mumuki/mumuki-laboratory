mumuki.progress = (() => {
  /**
   * Updates the current exercise progress indicator
   *
   * @param {SubmissionResult} result
   * */
  function updateProgressListAndShowModal(result) {
    $('.progress-list-item.active').attr('class', result.class_for_progress_list_item);
    if(result.guide_finished_by_solution) new bootstrap.Modal('#guide-done').show();
  }

  /**
   * Update all links in the progress bar with the given function
   *
   * @param {(anchor: JQuery) => string} f
   */
  function updateWholeProgressList(f) {
    $('.progress-list-item').each((_, it) => {
      const $anchor = $(it);
      $anchor.attr('class', f($anchor));
    });
  }

  return {
    updateProgressListAndShowModal,
    updateWholeProgressList
  };
})();

/** @deprecated use {@code mumuki.progress.updateProgressListAndShowModal} instead */
mumuki.updateProgressBarAndShowModal = mumuki.progress.updateProgressListAndShowModal;
