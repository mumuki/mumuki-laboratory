/**
 * @typedef {"errored"|"failed"|"passed_with_warnings"|"passed"|"pending"|"aborted"} SubmissionStatus
 */

/**
 * @typedef {{
 *  status: SubmissionStatus,
 *  test_results: [{status: SubmissionStatus, title: string}]
 * }} SubmissionClientResult
 */

/**
 * @typedef {{
  *  status: SubmissionStatus,
  *  class_for_progress_list_item?: string,
  *  guide_finished_by_solution?: boolean
  * }} SubmissionResult
  */

/**
 * @typedef {object} Solution
 */

/**
 * @typedef {{
 *  "solution[content]"?:string,
 *  solution?: Solution,
 *  client_result?: SubmissionClientResult
 * }} Submission
 */

/**
 * @typedef {{submission?: Submission, result?: SubmissionResult}} SubmissionAndResult
 */

mumuki.bridge = (() => {

  class Laboratory {
    // ==========
    // Public API
    // ==========

    /**
     * Runs tests for the current exercise using the given submission
     * content.
     *
     * @param {object} content the content object
     * */
    runTests(content) {
      return this._submitSolution({ solution: content });
    }

    // ===========
    // Private API
    // ===========

    /**
     * Sends a solution object
     *
     * @param {Submission} submission the submission object
     * @returns {JQuery.Promise<SubmissionResult>}
     */
    _submitSolution(submission) {
      const lastSubmission = mumuki.SubmissionsStore.getSubmissionResultFor(mumuki.currentExerciseId, submission);
      if (lastSubmission) {
        return $.Deferred().resolve(lastSubmission);
      } else {
        return this._sendNewSolution(submission).done((result) => {
          mumuki.SubmissionsStore.setSubmissionResultFor(mumuki.currentExerciseId, {submission, result});
        });
      }
    }

    /**
     * @param {Submission} submission the submission object
     * @returns {JQuery.Promise<SubmissionResult>}
     */
    _sendNewSolution(submission){
      var token = new mumuki.CsrfToken();
      var request = token.newRequest({
        type: 'POST',
        url: window.location.origin + window.location.pathname + '/solutions' + window.location.search,
        data: submission
      });
      return $.ajax(request).then((result) => this._preRenderResult(result));
    }

    /**
     * Pre-renders some html parts of submission UI, adding them to the given result
     *
     * @param {SubmissionResult} result
     * @returns {SubmissionResult}
     */
    _preRenderResult(result) {
      result.class_for_progress_list_item = mumuki.renderers.progressListItemClassForStatus(result.status, true)
      return result;
    }
  }

  return {
    Laboratory
  };
})();
