(() => {

  const OfflineMode = new class {
    // Runs solution by evaluating it locally
    runNewSolution(exerciseId, solution, _bridge) {
      return mumuki.runSolutionLocally(exerciseId, solution);
    }

    // Renders progress from SubmissionsStore
    renderExercisesProgressBar() {
      $('.progress-list-item').each((_, it) => this._updateProgressListItemClass($(it)));
    }

    _updateProgressListItemClass(a) {
      const exerciseId = a.data('mu-exercise-id');
      const status = mumuki.SubmissionsStore.getLastSubmissionStatus(exerciseId);
      a.attr('class', mumuki.progressListItemClassForStatus(status, exerciseId == mumuki.currentExerciseId));
    }
  }

  const OnlineMode = new class {
    // Runs solution by sending it to server
    runNewSolution(exerciseId, solution, bridge) {
      return bridge.submitCurrentExerciseSolution(exerciseId, solution);
    }

    // Does nothing. Progress is rendered by server
    renderExercisesProgressBar() {
    }
  }

  mumuki.goOnline = function () {
    mumuki.Connection = OnlineMode;
  };

  mumuki.goOffline = function () {
    mumuki.Connection = OfflineMode;
  };

  mumuki.goOnline();
})();
