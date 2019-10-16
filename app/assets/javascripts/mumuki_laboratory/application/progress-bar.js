(() => {
  // Updates the current exercise progress indicator
  mumuki.updateCurrentExerciseProgressBarAndShowModal = function (submission) {
    $('.progress-list-item.active').attr('class', mumuki.progressListItemClassForStatus(submission.status, true));
    if(submission.guide_finished_by_solution) $('#guide-done').modal();
  };

  mumuki.progressListItemClassForStatus = function (status, active = false) {
    return `progress-list-item text-center ${mumuki.classForStatus(status)} ${active ? 'active' : ''}`;
  };

  mumuki.load(() => {
    // Update all exercises progress indicators
    mumuki.Connection.renderExercisesProgressBar();
  })
})();
