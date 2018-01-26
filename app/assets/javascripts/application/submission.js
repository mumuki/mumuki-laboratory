var mumuki = mumuki || {};

(function (mumuki) {
  function ResultsBox(submissionsResults) {
    this.submissionsresultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
  }

  function SubmissionController() {
    this.submitButton = $('.btn-submit');
    this.submissionControls = $('.submission_control');
  }

  ResultsBox.prototype = {
    waiting: function () {
      this.submissionsresultsArea.html(this.processingTemplate.html());
    },
    success: function (data) {
      this.submissionsresultsArea.html(data);
    },
    error: function () {
      this.submissionsresultsArea.html(generateNetworkError());
    },
    done: function () {
      mumuki.pin.scroll();
    }
  };

  SubmissionController.prototype = {
    disable: function () {
      document.prevSubmitState = this.submitButton.html();
      this.submitButton.html('<i class="fa fa-refresh fa-spin"></i> ' + this.submitButton.attr('data-waiting'));
      this.submissionControls.attr('disabled', 'disabled');
    },
    enable: function () {
      this.submitButton.html(document.prevSubmitState);
      this.submissionControls.removeAttr('disabled');
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var resultsBox = new ResultsBox(submissionsResults);
    var submissionController = new SubmissionController();

    $('form.new_solution').on('ajax:beforeSend', function (event) {
      submissionController.disable();
      resultsBox.waiting();
    }).on('ajax:complete', function (event) {
      $(document).renderMuComponents();
      resultsBox.done();
      $('#messages-tab').removeClass('hidden');
    }).on('ajax:success', function (event) {
      var data = event.detail[0].body.outerHTML;
      submissionController.enable();
      resultsBox.success(data);
    }).on('ajax:error', function (event) {
      resultsBox.error(submissionController);
      animateTimeoutError(submissionController);
    });
  });

  function generateNetworkError() {
    return [
      '<div class="bs-callout bs-callout-broken submission-result-error">',
      '  <h4>',
      '    <strong><i class="fa fa-fw fa-minus-circle"></i>¡Ups! No pudimos ejecutar tu solución</strong>',
      '  </h4>',
      '  <div class="submission-result-error-body">',
      '    <img id="submission-result-error-animation" src="' + mumuki.errors.error_timeout_1 + '"/>',
      '    <ul class="submission-result-error-body-description">',
      '      <li>Fijate que tu programa no tenga recursión o bucle infinito</li>',
      '      <li>Chequeá que tengas conexión a internet <img src="/assets/emojis/raise_hands.png"/></li>',
      '      <li>Recursividad</li>',
      '    </ul>',
      '  </div>',
      '</div>'
    ].join('')
  }

  function animateTimeoutError(submissionController) {
    setTimeout(function () {
      var image = $('#submission-result-error-animation')[0];
      image.src = mumuki.errors.error_timeout_2;
      setTimeout(function () {
        image.src = mumuki.errors.error_timeout_3;
        submissionController.enable();
      }, 4000);
    }, 10333);
  }

})(mumuki);
