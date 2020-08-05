mumuki.progress = (() => {

  class LocalSyncMode {
    syncProgress() {
      $('.progress-list-item').each((_, it) => {
        this._updateProgressListItemClass($(it))
      });
    }

    syncExerciseEditorValue() {
      const lastSubmission = mumuki.SubmissionsStore.getLastSubmission(mumuki.currentExerciseId);
      if (lastSubmission) {
        /** @todo reify editors module  */
        /** @todo extract core module  */
        const content = mumuki.SubmissionsStore.submissionSolutionContent(lastSubmission.submission);
        const $customEditor = $('#mu-custom-editor-value');
        if ($customEditor.length) {
          $customEditor.val(content);
        } else {
          mumuki.editor.setContent(content);
        }
      }
    }

    /**
     * @param {JQuery} $anchor
     */
    _updateProgressListItemClass($anchor) {
      const exerciseId = $anchor.data('mu-exercise-id');
      const status = mumuki.SubmissionsStore.getLastSubmissionStatus(exerciseId);
      $anchor.attr('class', mumuki.renderers.progressListItemClassForStatus(status, exerciseId == mumuki.currentExerciseId));
    }

  }

  class ServerSyncMode {
    syncProgress() {
      // nothing
    }

    syncExerciseEditorValue() {
      // nothing
    }
  }

  /**
   * Updates the current exercise progress indicator
   *
   * @param {SubmissionResult} data
   * */
  function updateProgressBarAndShowModal(data) {
    $('.progress-list-item.active').attr('class', data.class_for_progress_list_item);
    if(data.guide_finished_by_solution) $('#guide-done').modal();
  };


  /** Selects the most appropriate sync mode */
  function _selectSyncMode() {
    if (mumuki.incognitoMode) {
      mumuki.progress._syncMode = new LocalSyncMode();
    } else {
      mumuki.progress._syncMode = new ServerSyncMode();
    }
  }

  mumuki.load(() => {
    /** @todo move to another module & load sync mode lazily */
    mumuki.progress._selectSyncMode();
    mumuki.progress._syncMode.syncProgress();
    mumuki.progress._syncMode.syncExerciseEditorValue();
  })

  return {
    updateProgressBarAndShowModal,

    /** @type {LocalSyncMode|ServerSyncMode} */
    _syncMode: null,
    _selectSyncMode
  };
})();

/** @deprecated use {@code mumuki.progress.updateProgressBarAndShowModal} instead */
mumuki.updateProgressBarAndShowModal = mumuki.progress.updateProgressBarAndShowModal;
