var mumuki = mumuki || {};
(function (mumuki) {

  function reportValue(message, report) {
    report([
      {msg: message, className: 'jquery-console-message-value'}
    ])
  }

  function reportError(message, report) {
    report([
      {msg: message, className: "jquery-console-message-error"}
    ])
  }

  function QueryConsole() {
    this.exerciseId = $('#exercise_id').val();
    this.token = $('meta[name="csrf-token"]').attr('content');
  }

  QueryConsole.prototype = {
    newQuery: function (line) {
      return new Query(line, this);
    }
  };

  function Query(line, console) {
    this.console = console;
    this.line = line;
  }

  Query.prototype = {
    get exerciseId() {
      return this.console.exerciseId;
    },
    get token() {
      return this.console.token;
    },
    get content() {
      return mumuki.page.editors[0].getValue();
    },
    submit: function (report) {
      var self = this;
      $.ajax(self._request).
        done(function (response) {
          console.log(response);
          if (response.status === 'passed') {
            reportValue(response.result, report)
          } else {
            reportError(response.result, report)
          }
        }).
        fail(function (response) {
          console.log(response);
          reportError(response.responseText, report);
        });
    },
    get _request() {
      var self = this;
      return {
        url: self._requestUrl,
        type: 'POST',
        data: self._requestData,
        beforeSend: function (xhr) {
          xhr.setRequestHeader('X-CSRF-Token', self.token);
        }
      }
    },
    get _requestUrl() {
      return '/exercises/' + this.exerciseId + '/queries';
    },
    get _requestData() {
      return {content: this.content, query: this.line};
    }
  };


  $(document).on('ready page:load', function () {
    console.log('loading console');
    var queryConsole = new QueryConsole();

    $('.console').console({
      promptLabel: 'ム ',
      commandValidate: function (line) {
        return line !== "";
      },
      commandHandle: function (line, report) {
        queryConsole.newQuery(line).submit(report);
      },
      autofocus: true,
      animateScroll: true,
      promptHistory: true
    });
  });

})(mumuki);