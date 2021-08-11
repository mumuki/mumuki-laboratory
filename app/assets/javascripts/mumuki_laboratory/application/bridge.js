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
  *  guide_finished_by_solution?: boolean,
  *  title_html?: string,
  *  in_gamified_context?: boolean
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
 * A submission, composed by:
 *
 *  * its actual contents
 *  * the client results
 *  * the _pristine flag, that tells whether the submission has been sent without previous results
 *
 * @typedef {Contents & {client_result?: SubmissionClientResult, _pristine: boolean}} Submission
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
      if (submission._pristine || !lastSubmission) {
        return this._sendNewSolution(submission).done((result) => {
          mumuki.SubmissionsStore.setSubmissionResultFor(mumuki.exercise.id, {submission, result});
        });
      } else {
        return $.Deferred().resolve(lastSubmission);
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
     * @param {SubmissionResult} result
     * @returns {SubmissionResult}
     * @see mumuki.renderers.results.preRenderResult
     */
    _preRenderResult(result) {
      mumuki.renderers.results.preRenderResult(result);
      return result;
    }
  }

  return {
    Laboratory
  };
})();
