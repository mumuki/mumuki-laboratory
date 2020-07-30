mumuki.updateProgressBarAndShowModal = (() => {

  /**
   * Updates the current exercise progress indicator
   *
   * @param {SubmissionResult} data
   * */
  function updateProgressBarAndShowModal(data) {
    $('.progress-list-item.active').attr('class', data.class_for_progress_list_item);
    if(data.guide_finished_by_solution) $('#guide-done').modal();
  };

  return updateProgressBarAndShowModal;
})();
