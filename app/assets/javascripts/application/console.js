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
      $.ajax({
        url: '/exercises/' + exerciseId + '/queries',
        type: 'POST',
        beforeSend: function (xhr) {
          xhr.setRequestHeader('X-CSRF-Token', token);
        },
        data: {content: '', query: line}}).
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


    },
    autofocus: true,
    animateScroll: true,
    promptHistory: true
  });
});
