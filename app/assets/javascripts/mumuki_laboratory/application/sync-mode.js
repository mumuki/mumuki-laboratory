/** @type {boolean} */
mumuki.incognitoUser;
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
      const lastSubmission = mumuki.SubmissionsStore.getLastSubmissionAndResult(mumuki.exercise.id);
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
      return mumuki.renderers.progressListItemClassForStatus(status, exerciseId == mumuki.exercise.id);
    }

  }

  /**
   * Syncs progress and solutions from server.
   *
   * This class does nothing actually, since a server-side behaviour is the default one
   * and no additional actions are needed.
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
    if (mumuki.incognitoUser) {
      mumuki.syncMode._current = new ClientSyncMode();
    } else {
      mumuki.syncMode._current = new ServerSyncMode();
    }
  }

  return {
    ServerSyncMode,
    ClientSyncMode,

    _selectSyncMode,

    /** @type {ClientSyncMode|ServerSyncMode}*/
    _current: null
  };
})();

mumuki.load(() => {
  mumuki.syncMode._selectSyncMode();
  mumuki.syncMode._current.syncProgress();
  mumuki.syncMode._current.syncEditorContent();
});
