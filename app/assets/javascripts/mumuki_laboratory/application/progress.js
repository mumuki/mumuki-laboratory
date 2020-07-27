var mumuki = mumuki || {};

(function (mumuki) {

  /**
   * Updates the current exercise progress indicator
   * */
  mumuki.updateProgressBarAndShowModal = function (data) {
    $('.progress-list-item.active').attr('class', data.class_for_progress_list_item);
    if(data.guide_finished_by_solution) $('#guide-done').modal();
  };

})(mumuki);
