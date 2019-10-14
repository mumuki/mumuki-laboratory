var mumuki = mumuki || {};

(function (mumuki) {
  var lastSubmission = {};

  function Laboratory(){
    this.exerciseId = $('#mu-exercise-id')[0].value;
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

  function progressListItemClassForStatus(status) {
    return `progress-list-item text-center ${classForStatus(status)}`;
  }

  function classForStatus(status) {
    switch (status) {
      case "passed": return "success";
      case "failed": return "danger";
      case "passed_with_warnings": return "warning";
      case "errored": return "broken";
    }
  }

  function messageForStatus(status) {
    switch (status) {
      case "passed": return "¡Muy bien! Tu solución pasó todas las pruebas";
      case "failed": return "Tu solución no pasó las pruebas";
      case "passed_with_warnings": return "Tu solución funcionó, pero hay cosas que mejorar";
      case "errored": return "¡Ups! Tu solución no se puede ejecutar";
    }
  }

  function titleHtmlForStatus(status) {
    return `<h4 class=\"text-${classForStatus(status)}\">\n  <strong><i class=\"fa fa-times-circle\"></i>${messageForStatus(status)}</strong>\n</h4>\n`;
  }

  function sendNewSolution(exerciseId, solution) {
    const status = "failed"; // FIXME hardcoded
    const result = {
      "status":status,
      "guide_finished_by_solution": false,
      "class_for_progress_list_item": progressListItemClassForStatus(status),
      "html":"\n<div class=\"mu-kids-callout-danger\">\n  \n</div>\n\n  <img class=\"capital-animation mu-kids-corollary-animation\"/>\n  \n        <div class=\"mu-last-box\">\n          <p><p>Como ves, para que el tractor siembre lechuga, tenemos que decirle a Mukinita que ponga 2 bolitas verdes.  Y en este ejemplo acabamos de sembrar una hilera de 4 lechugas. </p>\n<p>Pero fue un poco difícil entenderlo, ¿no? </p>\n</p>\n        </div>\n      \n",
      "title_html": titleHtmlForStatus(status),
      "button_html":"<div class=\"row\">\n  <div class=\"col-md-12\">\n    <div class=\"actions\">\n        <button class=\"btn btn-success btn-block submission-control\" id=\"kids-btn-retry\" data-dismiss=\"modal\" aria-label=\"Reintentar\"> Reintentar </button>\n    </div>\n  </div>\n</div>\n",
      "expectations_html":"",
      "remaining_attempts_html":null,
      "test_results":[
         {
            "title":null,
            "status":"failed",
            "result":"<style>\n\n  .boards-container {\n    display: inline-flex;\n  }\n\n  .error-text {\n    color: #d9534f;\n  }\n\n  .boom-text {\n    margin-top: 20px;\n  }\n\n  .title {\n    color: #b4bcc2;\n    text-align: left;\n    font-family: Arial, Helvetica, sans-serif;\n    font-size: 9pt;\n  }\n\n  .board {\n    margin: 0 15px;\n  }\n\n</style>\n\n\n  <p class=\"error-text\">\n    Se obtuvo un tablero distinto al esperado.\n  </p>\n\n\n<div class=\"boards-container\">\n\n  \n    <div class=\"board\">\n      <p class=\"title\">Tablero inicial</p>\n      <p class=\"initial_board\">\n        \n          <gs-board >\n            GBB/1.0\nsize 4 2\nhead 0 0\n\n          </gs-board>\n        \n      </p>\n    </div>\n  \n    <div class=\"board\">\n      <p class=\"title\">Tablero final esperado</p>\n      <p class=\"expected_board\">\n        \n          <gs-board without-header>\n            GBB/1.0\nsize 4 2\ncell 0 0 Verde 2\ncell 1 0 Verde 2\ncell 2 0 Verde 2\ncell 3 0 Verde 2\nhead 3 0\n\n          </gs-board>\n        \n      </p>\n    </div>\n  \n    <div class=\"board\">\n      <p class=\"title\">Tablero final obtenido</p>\n      <p class=\"actual_board\">\n        \n          <gs-board >\n            GBB/1.0\nsize 4 2\ncell 0 0 Verde 1\nhead 0 0\n\n          </gs-board>\n        \n      </p>\n    </div>\n  \n\n</div>\n\n\n"
         }
      ]
    };
    lastSubmission = { content: solution, result: result };
    window.localStorage.setItem(localStorageExerciseKey(exerciseId), JSON.stringify(lastSubmission));
    result.class_for_progress_list_item += ' active';
    return Promise.resolve(result);
  }

  function localStorageExerciseKey(exerciseId) {
    return `/exercise/${exerciseId}/submission`;
  }

  function lastSubmissionForExercise(exerciseId) {  
    return window.localStorage.getItem(localStorageExerciseKey(exerciseId));

  }

  function updateProgressListItemClass(a) {
    const submission = lastSubmissionForExercise(a.data('mu-exercise-id'));

    if (submission) {
      a.attr('class', JSON.parse(submission).result.class_for_progress_list_item);
    }
  }

  mumuki.load(function () {
    lastSubmission = {};
    $('.progress-list-item').each((_, it) => updateProgressListItemClass($(it)));
  });

  Laboratory.prototype = {

    // ==========
    // Public API
    // ==========

    // Runs tests for the current exercise using the given submission
    // content.
    runTests: function(content) {
      return this._submitSolution({ solution: content });
    },

    // ===========
    // Private API
    // ===========

    _submitSolution: function (solution) {
      if(lastSubmissionFinishedSuccessfully() && sameAsLastSolution(solution)){
        return $.Deferred().resolve(lastSubmission.result);
      } else {
        return sendNewSolution(this.exerciseId, solution);
      }
    },
  };

  mumuki.bridge = {
    Laboratory: Laboratory
  };

}(mumuki));
