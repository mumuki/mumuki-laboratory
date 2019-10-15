(() => {
  // Updates the current exercise progress indicator
  mumuki.updateProgressBarAndShowModal = function (submission) {
    $('.progress-list-item.active').attr('class', mumuki.progressListItemClassForStatus(submission.status, true));
    if(submission.guide_finished_by_solution) $('#guide-done').modal();
  };

  mumuki.progressListItemClassForStatus = function (status, active = false) {
    return `progress-list-item text-center ${mumuki.classForStatus(status)} ${active ? 'active' : ''}`;
  };

  mumuki.classForStatus = function (status) {
    switch (status) {
      case "passed": return "success";
      case "failed": return "danger";
      case "passed_with_warnings": return "warning";
      case "errored": return "broken";
      case "pending": return "muted";
    }
  };

  function _updateProgressListItemClass(a) {
    const exerciseId = a.data('mu-exercise-id');
    const status = mumuki.SubmissionsStore.getLastSubmissionStatus(exerciseId);

    a.attr('class', mumuki.progressListItemClassForStatus(status, exerciseId == mumuki.currentExerciseId));
  }

  mumuki.load(() => {
    // Set global currentExerciseId
    const $muExerciseId = $('#mu-exercise-id')[0];
    if ($muExerciseId) {
      mumuki.currentExerciseId = $muExerciseId.value;
    } else {
      mumuki.currentExerciseId = null;
    }

    // Update all exercises progress indicators
    $('.progress-list-item').each((_, it) => _updateProgressListItemClass($(it)));
  })
})();
