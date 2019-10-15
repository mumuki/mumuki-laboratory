(() => {
  function _messageForStatus(status) {
    switch (status) {
      case "passed": return "¡Muy bien! Tu solución pasó todas las pruebas";
      case "failed": return "Tu solución no pasó las pruebas";
      case "passed_with_warnings": return "Tu solución funcionó, pero hay cosas que mejorar";
      case "errored": return "¡Ups! Tu solución no se puede ejecutar";
    }
  }

  function _titleHtmlForStatus(status) {
    return `<h4 class=\"text-${mumuki.classForStatus(status)}\">\n  <strong><i class=\"fa fa-times-circle\"></i>${_messageForStatus(status)}</strong>\n</h4>\n`;
  }

  function _sendNewSolution(exerciseId, solution) {
    const status = "passed"; // FIXME hardcoded
    const result = {
      "status": status,
      "guide_finished_by_solution": false,
      "html":"\n<div class=\"mu-kids-callout-danger\">\n  \n</div>\n\n  <img class=\"capital-animation mu-kids-corollary-animation\"/>\n  \n        <div class=\"mu-last-box\">\n          <p><p>Como ves, para que el tractor siembre lechuga, tenemos que decirle a Mukinita que ponga 2 bolitas verdes.  Y en este ejemplo acabamos de sembrar una hilera de 4 lechugas. </p>\n<p>Pero fue un poco difícil entenderlo, ¿no? </p>\n</p>\n        </div>\n      \n",
      "title_html": _titleHtmlForStatus(status),
      "button_html":"<div class=\"row\">\n  <div class=\"col-md-12\">\n    <div class=\"actions\">\n        <button class=\"btn btn-success btn-block submission-control\" id=\"kids-btn-retry\" data-dismiss=\"modal\" aria-label=\"Reintentar\"> Reintentar </button>\n    </div>\n  </div>\n</div>\n",
      "expectations_html":"",
      "remaining_attempts_html":null,
      "test_results":[]
    };
    lastSubmission = { content: solution, result: result };
    mumuki.SubmissionsStore.setLastSubmission(exerciseId, lastSubmission);
    return Promise.resolve(result);
  }

  class Laboratory {
    // ==========
    // Public API
    // ==========

    // Runs tests for the current exercise using the given submission
    // content.
    runTests(content) {
      return this._submitSolution({ solution: content });
    }

    // ===========
    // Private API
    // ===========

    _submitSolution(solution) {
      const cachedSolution = mumuki.SubmissionsStore.getCachedResultFor(mumuki.currentExerciseId, solution);
      if(cachedSolution){
        return $.Deferred().resolve(cachedSolution);
      }

      return _sendNewSolution(mumuki.currentExerciseId, solution);
    }
  }

  mumuki.bridge = {
    Laboratory: Laboratory
  };
})();
