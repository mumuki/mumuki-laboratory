/** @type {boolean} */
mumuki.incognitoMode;
mumuki.syncMode = (() => {

  /**
   * Syncs progress and solutions
   * from local storage
   */
  class ClientSyncMode {
    syncProgress() {
      mumuki.progress.updateWholeProgressBar($anchor => this._getProgressListItemClass($anchor));
    }

    syncEditorContent() {
      const lastSubmission = mumuki.SubmissionsStore.getLastSubmissionAndResult(mumuki.currentExerciseId);
      if (lastSubmission) {
        /** @todo extract core module  */
        const content = mumuki.SubmissionsStore.submissionSolutionContent(lastSubmission.submission);
        mumuki.editors.setContent(content);
      }
    }

    /**
     * @param {JQuery} $anchor
     */
    _getProgressListItemClass($anchor) {
      const exerciseId = $anchor.data('mu-exercise-id');
      const status = mumuki.SubmissionsStore.getLastSubmissionStatus(exerciseId);
      return mumuki.renderers.progressListItemClassForStatus(status, exerciseId == mumuki.currentExerciseId);
    }

  }

  /**
   * Syncs progress and solutions
   * from server.
   *
   * This class does actually nothing
   * since that behaviour is actually the default one, son no additional actions
   * are nedeed.
   */
  class ServerSyncMode {
    syncProgress() {
      // nothing
    }

    syncEditorContent() {
      // nothing
    }
  }


  /** Selects the most appropriate sync mode */
  function _selectSyncMode() {
    if (mumuki.incognitoMode) {
      mumuki.syncMode._current = new ClientSyncMode();
    } else {
      mumuki.syncMode._current = new ServerSyncMode();
    }
  }

  mumuki.load(() => {
    mumuki.syncMode._selectSyncMode();
    mumuki.syncMode._current.syncProgress();
    mumuki.syncMode._current.syncEditorContent();
  })

  return {
    ServerSyncMode,
    ClientSyncMode,

    _selectSyncMode,

    /** @type {ClientSyncMode|ServerSyncMode}*/
    _current: null
  }
})();
