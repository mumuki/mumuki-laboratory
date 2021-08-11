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
 * Contents of a submission expressed in the form of params
 * generated and accepted by laboratory HTTP Controllers
 *
 * @typedef {{"solution[content]":string}} ClassicContents
 */

/**
 * Contents of a submission expressed as an object
 * that are created programatically
 *
 * @typedef {{solution: Solution}} ProgramaticContents
 */

/**
 * Contents of a multifile submission expressed as dictionary of keys in the form
 * `solution[content[the-filename-goes-here]]`
 *
 * @typedef {object} MutifileContents
 */

/**
 * @typedef {ClassicContents|ProgramaticContents|MutifileContents} Contents
 */

/**
 * @typedef {Contents & {client_result?: SubmissionClientResult}} Submission
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
      const lastSubmission = mumuki.SubmissionsStore.getSubmissionResultFor(mumuki.exercise.id, submission);
      if (!mumuki.submission.pristine && lastSubmission) {
        return $.Deferred().resolve(lastSubmission);
      } else {
        return this._sendNewSolution(submission).done((result) => {
          mumuki.submission.pristine = false;
          mumuki.SubmissionsStore.setSubmissionResultFor(mumuki.exercise.id, {submission, result});
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
      result.class_for_progress_list_item = mumuki.renderers.results.progressListItemClassForStatus(result.status, true);
      result.title_html = mumuki.renderers.results.translatedTitleHtml(result.status, result.in_gamified_context);
      return result;
    }
  }

  return {
    Laboratory
  };
})();
