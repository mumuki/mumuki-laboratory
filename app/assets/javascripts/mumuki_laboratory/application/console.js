(() => {
  function historicalQueries() {
    var queries = $('#historical_queries').val();
    if (queries) {
      return JSON.parse(queries);
    } else {
      return [];
    }
  }
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
    $('.jquery-console-prompt-box:not(:last)').remove();
  }

  class QueryConsole {
    constructor() {
      this.endpoint = $('#console_endpoint').val();
      this.token = new mumuki.CsrfToken();
      this.statefulConsole = $('#stateful_console').val() === "true";
      this.lines = [];
      this.controller = null;
    }
    newQuery(line) {
      var cookies = this.statefulConsole ? this.lines : [];
      return new Query(line, cookies, this);
    }
    clearState() {
      this.lines = [];
      clearConsole();
    }
    sendQuery(queryContent) {
      this.controller.promptText(queryContent);
      this.controller.typer.commandTrigger();
    }
    preloadQuery(queryWithResults) {
      this.lines.push(queryWithResults.query);
      this.enqueuePreloadedQuery(queryWithResults);
      this.sendQuery(queryWithResults.query);
    }
    enqueuePreloadedQuery(queryWithResults) {
      this.preloadedQuery = queryWithResults;
    }
    dequeuePreloadedQuery() {
      var result = this.preloadedQuery;
      this.preloadedQuery = undefined;
      return result;
    }
    preloadHistoricalQueries() {
      var self = this;
      historicalQueries().forEach(function (queryWithResults) {
        self.preloadQuery(queryWithResults);
      });
    }
  }

  class Query {
    constructor(line, cookie, console) {
      this.console = console;
      this.line = line;
      this.cookie = cookie;
    }
    get token() {
      return this.console.token;
    }
    get content() {
      var firstEditor = mumuki.page.editors[0];
      if (firstEditor && this.includeSolution())
        return firstEditor.getValue();
      else
        return '';
    }
    submit(report, queryConsole, line) {
      var self = this;
      var preloadedQuery = queryConsole.dequeuePreloadedQuery();
      if (preloadedQuery) {
        return reportStatus(preloadedQuery.result, preloadedQuery.status, report);
      }

      $.ajax(self._request).done(function (response) {
        if (response.query_result) {
          self.displayGoalResult(response);
          response = response.query_result;
        }
        self.displayQueryResult(report, queryConsole, line, response);
      }).fail(function (response) {
        reportStatus(response.responseText, 'failed', report);
      });
    }
    displayGoalResult(response) {
      if (response.status == 'passed') {
        $('.submission-results').show();
        $('.submission-results').html(response.html);
        mumuki.pin.scroll();
        mumuki.updateProgressBarAndShowModal(response);
      } else {
        $('.submission-results').hide();
        $('.progress-list-item.active').attr('class', "progress-list-item text-center danger active");
      }
    }
    displayQueryResult(report, queryConsole, line, response) {
      if (response.status !== 'errored') {
        queryConsole.lines.push(line);
        reportStatus(response.result, response.status, report);
      } else {
        reportStatus(response.result, 'failed', report);
      }
    }
    get _request() {
      var self = this;
      return self.token.newRequest({
        url: self._requestUrl,
        type: 'POST',
        data: self._requestData
      });
    }
    get _requestUrl() {
      return this.console.endpoint;
    }
    get _requestData() {
      return {content: this.content, query: this.line, cookie: this.cookie};
    }
    includeSolution() {
      return !this._includeSolutionCheckbox || this._includeSolutionCheckbox.checked;
    }
    get _includeSolutionCheckbox() {
      return $("#include_solution")[0];
    }
  }


  mumuki.load(() => {
    var prompt = $('#prompt').attr('value');
    var queryConsole = new QueryConsole();

    $('.console-reset').click(function () {
      queryConsole.clearState();
    });

    queryConsole.controller = $('.console').console({
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
    queryConsole.preloadHistoricalQueries();
  });

})();
