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

  function _closeModalButtonHtml() {
    const keepLearning = "¡Seguí aprendiendo!"; // FIXME i18n
    return `<button class="btn btn-success btn-block mu-close-modal">${keepLearning}</button>`;
  }

  function _retryButtonHtml() {
    const retryMessage = "Reintentar"; // FIXME i18n
    return `<button class="btn btn-success btn-block submission-control" id="kids-btn-retry" data-dismiss="modal" aria-label="${retryMessage}"> ${retryMessage}</button>`;
  }

  function _nextExerciseButton() {
    return `<a class="btn btn-success btn-block" role="button" href="../exercises/${mumuki.currentExerciseId + 1}">Siguiente Ejercicio <i class="fa fa-chevron-right"></i></a>`; // TODO missing exercise title
  }

  mumuki.classForStatus = function (status) {
    switch (status) {
      case "passed": return "success";
      case "failed": return "danger";
      case "passed_with_warnings": return "warning";
      case "errored": return "broken";
      case "pending": return "muted";
    }
  };

  mumuki.renderTitleHtml = function (status) {
    return `<h4 class="text-${mumuki.classForStatus(status)}"><strong><i class="fa ${_iconForStatus(status)}"></i>${_messageForStatus(status)}</strong></h4>`;
  };

  mumuki.renderButtonHtml = function (status) {
    return `
      <div class="row">
        <div class="col-md-12">
          <div class="actions">
            ${status === 'passed' ? _nextExerciseButton() : _retryButtonHtml()}
          </div>
        </div>
      </div>`;
  };

  mumuki.renderCorollaryHtml = function(status, corollary) {
    // TODO support non-kids layout
    return `
      <div class="mu-kids-callout-${mumuki.classForStatus(status)}">
      </div>
      <img class="capital-animation mu-kids-corollary-animation"/>
      <div class="mu-last-box">
        ${corollary}
      </div>`;
  }
})();
