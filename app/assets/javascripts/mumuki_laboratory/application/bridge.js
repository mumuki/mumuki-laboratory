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

  function sendNewSolution(solution){
    var token = new mumuki.CsrfToken();
    var request = token.newRequest({
      type: 'POST',
      url: window.location.origin + window.location.pathname + '/solutions' + window.location.search,
      data: solution
    });

    return $.ajax(request).done(function (result) {
      lastSubmission = { content: solution, result: result };
    });
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
     * @param {{solution: object}} solution the solution object
     */
    _submitSolution: function (solution) {
      if(lastSubmissionFinishedSuccessfully() && sameAsLastSolution(solution)){
        return $.Deferred().resolve(lastSubmission.result);
      } else {
        return sendNewSolution(solution);
      }
    },
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));
