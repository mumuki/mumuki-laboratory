var mumuki = mumuki || {};
(function (mumuki) {
  function renderPrompt() {
    var prompt = $('#prompt').attr('value');
    if (prompt && prompt.indexOf('ム') >= 0) {
      $('.jquery-console-prompt-label')
        .html('')
        .append('<i class="text-primary da da-mumuki"></i>')
        .append('<span>&nbsp;&nbsp;</span>');
    }
  }

  function classForStatus(status) {
    return 'jquery-console-message-' + (status === 'passed' ? 'value' : 'error');
  }

  function reportStatus(message, status, report) {
    report([{
      msg: message,
      className: classForStatus(status)
    }]);
    renderPrompt();
  }

  function clearConsole() {
    $('.jquery-console-message-error').remove();
    $('.jquery-console-message-value').remove();
    $('.jquery-console-prompt-box:not(:last)').remove()
  }

  function QueryConsole() {
    this.endpoint = $('#console_endpoint').val();
    this.token = new mumuki.CsrfToken();
    this.statefulConsole = $('#stateful_console').val() === "true";
    this.lines = [];
  }

  QueryConsole.prototype = {
    newQuery: function (line) {
      var cookies = this.statefulConsole ? this.lines : [];
      return new Query(line, cookies, this);
    },
    clearState: function () {
      this.lines = [];
      clearConsole();
    },
    preloadQuery: function(queryWithResults) {
      this.lines.push(queryWithResults.query);
      reportStatus(queryWithResults.result, queryWithResults.status, this.controller.report);
    }
  };

  function Query(line, cookie, console) {
    this.console = console;
    this.line = line;
    this.cookie = cookie;
  }

  Query.prototype = {
    get token() {
      return this.console.token;
    },
    get content() {
      var firstEditor = mumuki.page.editors[0];
      if (firstEditor && $("#include_solution").prop("checked"))
        return firstEditor.getValue();
      else
        return '';
    },
    submit: function (report, queryConsole, line) {
      var self = this;
      $.ajax(self._request).done(function (response) {
        if (response.query_result) {
          if (response.status == 'passed') {
            $('.mu-try-results').show();
            mumuki.pin.scroll();
          } else {
            $('.mu-try-results').hide();
          }
          response = response.query_result;
        }
        if (response.status !== 'errored') {
          queryConsole.lines.push(line);
          reportStatus(response.result, response.status, report);
        } else {
          reportStatus(response.result, 'failed', report);
        }
      }).fail(function (response) {
        reportStatus(response.responseText, 'failed', report);
      });
    },
    get _request() {
      var self = this;
      return self.token.newRequest({
        url: self._requestUrl,
        type: 'POST',
        data: self._requestData
      })
    },
    get _requestUrl() {
      return this.console.endpoint;
    },
    get _requestData() {
      return {content: this.content, query: this.line, cookie: this.cookie};
    }
  };


  mumuki.load(function () {
    var prompt = $('#prompt').attr('value');
    var queryConsole = new QueryConsole();

    $('.console-reset').click(function () {
      queryConsole.clearState();
    });

    var controller = $('.console').console({
      promptLabel: prompt + ' ',
      commandValidate: function (line) {
        return line !== "";
      },
      commandHandle: function (line, report) {
        queryConsole.newQuery(line).submit(report, queryConsole, line);
      },
      autofocus: !!$('#solution_editor_bottom').val(),
      animateScroll: true,
      promptHistory: true
    });

    renderPrompt();

    queryConsole.controller = controller;
    mumuki.queryConsole = queryConsole;
  });

}(mumuki));
