var mumuki = mumuki || {};

(function (mumuki) {
  function ResultsBox(submissionsResults) {
    this.submissionsresultsArea = submissionsResults;
    this.processingTemplate = $('#processing-template');
  }

  ResultsBox.prototype = {
    waiting: function () {
      this.submissionsresultsArea.html(this.processingTemplate.html());
    },
    success: function (data) {
      this.submissionsresultsArea.html(data);
    },
    error: function (error) {
      this.submissionsresultsArea.html(generateNetworkError());
      animateTimeoutError();
    },
    done: function () {
      mumuki.pin.scroll();
    }
  };

  mumuki.load(function () {
    var submissionsResults = $('.submission-results');
    if (!submissionsResults) return;

    var submitButton = $('.btn-submit');
    var submissionControls = $('.submission_control');

    var resultsBox = new ResultsBox(submissionsResults);

    $('form.new_solution').on('ajax:beforeSend', function (event) {
      document.prevSubmitState = submitButton.html();
      submitButton.html('<i class="fa fa-refresh fa-spin"></i> ' + submitButton.attr('data-waiting'));
      submissionControls.attr('disabled', 'disabled');
      resultsBox.waiting();
    }).on('ajax:complete', function (event) {
      submitButton.html(document.prevSubmitState);
      submissionControls.removeAttr('disabled');
      $(document).renderMuComponents();
      resultsBox.done();
      $('#messages-tab').removeClass('hidden');
    }).on('ajax:success', function (event) {
      var data = event.detail[0].body.outerHTML;
      resultsBox.success(data);
    }).on('ajax:error', function (event) {
      resultsBox.error("Network error :( Please check your internet connection and try again");
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

  function animateTimeoutError() {
    setTimeout(function () {
      var image = $('#submission-result-error-animation')[0];
      image.src = mumuki.errors.error_timeout_2;
      setTimeout(function () {
        image.src = mumuki.errors.error_timeout_3;
      }, 4000);
    }, 10333);
  }

})(mumuki);
