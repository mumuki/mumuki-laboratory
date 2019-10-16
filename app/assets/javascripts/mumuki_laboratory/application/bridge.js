(() => {
  function _messageForStatus(status) {
    switch (status) { // FIXME i18n
      case "errored":              return "¡Ups! Tu solución no se puede ejecutar";
      case "failed":               return "Tu solución no pasó las pruebas";
      case "passed_with_warnings": return "Tu solución funcionó, pero hay cosas que mejorar";
      case "passed":               return "¡Muy bien! Tu solución pasó todas las pruebas";
    }
  }

  function _iconForStatus(status) {
    switch (status) {
      case "errored":              return "fa-minus-circle";
      case "failed":               return "fa-times-circle";
      case "passed_with_warnings": return "fa-exclamation-circle";
      case "passed":               return "fa-check-circle";
    }
  }

  function _titleHtmlForStatus(status) {
    return `<h4 class="text-${mumuki.classForStatus(status)}"><strong><i class="fa ${_iconForStatus(status)}"></i>${_messageForStatus(status)}</strong></h4>`;
  }

  function _closeModalButtonHtml() {
    const keepLearning = "¡Seguí aprendiendo!"; // FIXME i18n
    return `<button class="btn btn-success btn-block mu-close-modal">${keepLearning}</button>`;
  }

  function _retryButtonHtml() {
    const retryMessage = "Reintentar"; // FIXME i18n
    return `<button class="btn btn-success btn-block submission-control" id="kids-btn-retry" data-dismiss="modal" aria-label="${retryMessage}"> ${retryMessage}</button>`;
  }

  function _nextExerciseButton() {
    return _closeModalButtonHtml(); // TODO render next button
  }

  function _buttonHtmlForStatus(status) {
    return `
      <div class="row">
        <div class="col-md-12">
          <div class="actions">
            ${status === 'passed' ? _nextExerciseButton() : _retryButtonHtml()}
          </div>
        </div>
      </div>`;
  }

  function _sendNewSolution(exerciseId, solution) {
    const status = "passed"; // FIXME hardcoded
    const result = {
      "status": status,
      "guide_finished_by_solution": false,
      "html":"<div class=\"mu-kids-callout-danger\">  </div>  <img class=\"capital-animation mu-kids-corollary-animation\"/><div class=\"mu-last-box\"><p><p>Como ves, para que el tractor siembre lechuga, tenemos que decirle a Mukinita que ponga 2 bolitas verdes.  Y en este ejemplo acabamos de sembrar una hilera de 4 lechugas. </p><p>Pero fue un poco difícil entenderlo, ¿no? </p></p>        </div>      ",
      "title_html": _titleHtmlForStatus(status),
      "button_html":_buttonHtmlForStatus(status),
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
