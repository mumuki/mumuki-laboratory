/**
 * @typedef {{status: string, test_results: [{status: string, title: string}]}} ClientResult
 */

/**
 * @typedef {{solution: object, client_result?: ClientResult}} Submission
 */

var mumuki = mumuki || {};

(function (mumuki) {
  var lastSubmission = {};

  function Laboratory(exerciseId){
    this.exerciseId = exerciseId;
  }

  function asString(json){
    return JSON.stringify(json);
  }

  function sameAsLastSolution(newSolution){
    return asString(lastSubmission.content) === asString(newSolution);
  }

  function lastSubmissionFinishedSuccessfully(){
    return lastSubmission.result && lastSubmission.result.status !== 'aborted';
  }

  function sendNewSolution(submission){
    var token = new mumuki.CsrfToken();
    var request = token.newRequest({
      type: 'POST',
      url: window.location.origin + window.location.pathname + '/solutions' + window.location.search,
      data: submission
    });

    return $.ajax(request).then(preRenderResult).done(function (result) {
      lastSubmission = { content: {solution: submission.solution}, result: result };
    });
  }


  /**
   * Pre-renders some html parts of submission UI
   * */
  function preRenderResult(result) {
    result.class_for_progress_list_item = mumuki.renderers.progressListItemClassForStatus(result.status, true)
    return result;
  }

  mumuki.load(function () {
    lastSubmission = {};
  });

  Laboratory.prototype = {

    // ==========
    // Public API
    // ==========

    /**
     * Runs tests for the current exercise using the given submission
     * content.
     *
     * @param {object} content the content object
     * */
    runTests: function(content) {
      return this._submitSolution({ solution: content });
    },

    // ===========
    // Private API
    // ===========

    /**
     * Sends a solution object
     *
     * @param {Submission} submission the submission object
     */
    _submitSolution: function (submission) {
      if(lastSubmissionFinishedSuccessfully() && sameAsLastSolution(submission)){
        return $.Deferred().resolve(lastSubmission.result);
      } else {
        return sendNewSolution(submission);
      }
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));
