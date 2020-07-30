/**
 * @typedef {{status: SubmissionStatus, test_results: [{status: SubmissionStatus, title: string}]}} SubmissionClientResult
 */

/**
 * @typedef {{
 *  status: SubmissionStatus,
 *  class_for_progress_list_item?: string,
 *  guide_finished_by_solution?: boolean
 * }} SubmissionResult
 */

/**
 * @typedef {{solution: object, client_result?: SubmissionClientResult}} Submission
 */

/**
 * @typedef {"errored"|"failed"|"passed_with_warnings"|"passed"|"pending"|"aborted"} SubmissionStatus
 */

/**
 * @typedef {{content?: {solution: object}, result?: SubmissionResult}} SubmissionAndResult
 */

/** @module mumuki.bridge */
mumuki.bridge = {};
mumuki.bridge.Laboratory = (() => {
  /**
   * @type {SubmissionAndResult}
   */
  var lastSubmission = {};

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
     */
    _submitSolution(submission) {
      if(this._lastSubmissionFinishedSuccessfully() && this._sameAsLastSolution(submission)){
        return $.Deferred().resolve(lastSubmission.result);
      } else {
        return this._sendNewSolution(submission);
      }
    }

    _asString(json){
      return JSON.stringify(json);
    }

    _sameAsLastSolution(newSolution){
      return this._asString(lastSubmission.content) === this._asString(newSolution);
    }

    _lastSubmissionFinishedSuccessfully() {
      return lastSubmission.result && lastSubmission.result.status !== 'aborted';
    }

    /**
     * @param {Submission} submission the submission object
     */
    _sendNewSolution(submission){
      var token = new mumuki.CsrfToken();
      var request = token.newRequest({
        type: 'POST',
        url: window.location.origin + window.location.pathname + '/solutions' + window.location.search,
        data: submission
      });

      return $.ajax(request).then((result) => this._preRenderResult(result)).done(function (result) {
        lastSubmission = { content: {solution: submission.solution}, result: result };
      });
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

  mumuki.load(() => {
    lastSubmission = {};
  });

  return Laboratory;
})();
