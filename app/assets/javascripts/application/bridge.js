var mumuki = mumuki || {};

var lastSubmission = {};

(function (mumuki) {
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

  Laboratory.prototype = {
    runLocalTests: function (solution) {
      if(lastSubmissionFinishedSuccessfully() && sameAsLastSolution(solution)){
        return $.Deferred().resolve(lastSubmission.result)
      }else{
        var token = new mumuki.CsrfToken();
        var request = token.newRequest({
          type: 'POST',
          url: window.location.origin + window.location.pathname + '/solutions',
          data: solution
        });
        return $.ajax(request).done(function (result) {
          lastSubmission = { content: solution, result: result };
        });
      }
    },
    runTests: function(content) {
      return this.runLocalTests({ solution: content });
    }
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));
