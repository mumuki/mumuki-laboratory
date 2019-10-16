(() => {
  class Laboratory {
    // ==========
    // Public API
    // ==========

    // Runs tests for the current exercise using the given submission
    // content.
    runTests(content) {
      return this.runCurrentExerciseSolution({ solution: content });
    }

    // Runs the current exercise solution, trying to get the response from cache first
    runCurrentExerciseSolution(solution) {
      const cachedSolution = mumuki.SubmissionsStore.getCachedResultFor(mumuki.currentExerciseId, solution);
      if(cachedSolution) {
        return $.Deferred().resolve(cachedSolution);
      }
      return this._runNewSolution(mumuki.currentExerciseId, solution);
    }

    // Actually sends the solution to server
    submitCurrentExerciseSolution(_exerciseId, solution) { // TODO use exerciseId instead of window.location
      const token = new mumuki.CsrfToken();
      const request = token.newRequest({
        type: 'POST',
        url: window.location.origin + window.location.pathname + '/solutions' + window.location.search,
        data: solution
      });
      return $.ajax(request);
    }

    // ===========
    // Private API
    // ===========

    _runNewSolution(exerciseId, solution){
      const responsePromise = mumuki.Connection.runNewSolution(exerciseId, solution, this);
      return responsePromise.then((result) => {
        const status = result.status;

        result.button_html = mumuki.buttonHtmlForStatus(status); // TODO defer rendering calculation

        const lastSubmission = { content: solution, result: result };
        mumuki.SubmissionsStore.setLastSubmission(exerciseId, lastSubmission);
        return result;
      });
    }
  }

  mumuki.bridge = {
    Laboratory: Laboratory
  };
})();
