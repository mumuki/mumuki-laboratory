(() => {
  function shouldSkipChangesCheck() {
    return mumuki.isKidsExercise() || mumuki.exercise.isReadOnly;
  }

  function solutionChangedSinceLastSubmission() {
    return  mumuki.exercise.id &&
            mumuki.SubmissionsStore.getLastSubmissionAndResult(mumuki.exercise.id) &&
            !mumuki.SubmissionsStore.getSubmissionResultFor(mumuki.exercise.id, mumuki.editors.getSubmission());
  }

  function shouldWarnOfChanges() {
    return !shouldSkipChangesCheck() && solutionChangedSinceLastSubmission();
  }

  window.addEventListener("beforeunload", (event) => {
    if (shouldWarnOfChanges()) {
      event.returnValue = 'unsaved_progress';
    } else {
      delete event['returnValue'];
    }
  });

  window.addEventListener("turbolinks:before-visit", (event) => {
    if (shouldWarnOfChanges() && !confirm(mumuki.I18n.t('unsaved_progress'))) event.preventDefault();
  });
})();

/**
 * @typedef {"input_right" | "input_bottom" | "input_primary" | "input_kindergarten"} Layout
 * @typedef {{id: number, layout: Layout, settings: any}} Exercise
 */

mumuki.exercise = {

  /**
   * The current exercise's id
   *
   * @type {Exercise?}
   * */
  _current: null,

  /**
   * The current exercise's id
   *
   * @type {number?}
   * */
  get id() {
    return this._current ? this._current.id : null;
  },

  /**
   * The current exercise's layout
   *
   * @type {Layout?}
   * */
  get layout() {
    return this._current ? this._current.layout : null;
  },

  /**
   * The current exercise's settings
   *
   * @type {any?}
   * */
  get settings() {
    return this._current ? this._current.settings : null;
  },

  /**
   * @type {Exercise?}
   */
  get current() {
    return this._current;
  },

  /**
   * @type {Boolean?}
   */
  get isReadOnly() {
    return $('#mu-exercise-read-only').val() === 'true';
  },

  /**
   * Set global current exercise information
   */
  load() {
    const $muExerciseId = $('#mu-exercise-id');
    if ($muExerciseId.length) {
      this._current = {
        id: Number($muExerciseId.val()),
        // @ts-ignore
        layout: $('#mu-exercise-layout').val(),
        // @ts-ignore
        settings: JSON.parse($('#mu-exercise-settings').val())
      };
    } else {
      this._current = null;
    }
  }
};

mumuki.load(() => mumuki.exercise.load());
