var mumuki = mumuki || {};
mumuki.console = {};

mumuki.console.submitQuery = function(exerciseId, content, query, token, report) {
  $.ajax({
    url: '/exercises/' + exerciseId + '/queries',
    type: 'POST',
    beforeSend: function (xhr) {
      xhr.setRequestHeader('X-CSRF-Token', token);
    },
    data: {content: content, query: query}}).
    done(function (response) {
      console.log(response);
      var className = response.status === 'passed' ? 'jquery-console-message-value' : 'jquery-console-message-error';
      report([
        {msg: response.result,
          className: className}
      ])
    }).fail(function (response) {
      console.log(response);
      report([
        {msg: '' + response.responseText,
          className: "jquery-console-message-error"}
      ])
    });
};

$(document).on('ready page:load', function () {
  var token = $('meta[name="csrf-token"]').attr('content');

  console.log('loading console');

  $('.console').console({
    promptLabel: 'ム ',
    commandValidate: function (line) {
      return line !== "";
    },
    commandHandle: function (line, report) {
      var exerciseId = $('#exercise_id').val();
      var content = mumuki.page.editors[0].getValue();

      mumuki.console.submitQuery(exerciseId, content, line, token, report);
    },
    autofocus: true,
    animateScroll: true,
    promptHistory: true
  });
});
