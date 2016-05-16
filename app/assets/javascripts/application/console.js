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
  function clearConsole() {
      $('.jquery-console-message-error').remove();
      $('.jquery-console-message-value').remove();
      $('.jquery-console-prompt-box:not(:last)').remove()
  }

  function QueryConsole() {
    this.exerciseId = $('#exercise_id').val();
    this.token = $('meta[name="csrf-token"]').attr('content');
    this.lines = [];
  }

  QueryConsole.prototype = {
    newQuery: function (line) {
      this.lines.push(line);
      return new Query(this.lines.join('\n'), this);
    },
    clearState: function() {
      this.lines = [];
      clearConsole();
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
      var firstEditor = mumuki.page.editors[0];
      if (firstEditor)
        return firstEditor.getValue();
      else
        return '';
    },
    submit: function (report) {
      var self = this;
      $.ajax(self._request).
        done(function (response) {
          if (response.status === 'passed') {
            reportValue(response.result, report)
          } else {
            reportError(response.result, report)
          }
        }).
        fail(function (response) {
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
    var prompt = $('#prompt').attr('value');
    var queryConsole = new QueryConsole();

    $('.clear-console').click(function(){
      queryConsole.clearState();
    });

    $('.console').console({
      promptLabel: prompt + ' ',
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
