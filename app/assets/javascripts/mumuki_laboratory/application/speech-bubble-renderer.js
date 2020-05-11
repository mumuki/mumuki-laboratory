((mumuki)=> {

  function renderSpeechBubbleResultItem(item) {
    return `
        <div class="results-item">
          <ul class="results-list">
            <li>${item}</li>
          </ul>
        </div>`;
  }

  // A mumuki.kids.SpeechBubbleRenderer allows to configure an speech bubble
  // with the data of a test response from bridge
  class SpeechBubbleRenderer {
    constructor($bubble) {
      this.$bubble = $bubble;
      this.$failedArea = $bubble.find('.mu-kids-character-speech-bubble-failed');
    }

    _chooseResultItem() {
      if (this.responseStatus() !== 'passed' && this.responseData.tips) {
        this._appendFirstTip()
      } else if (this.responseStatus() === 'failed') {
        this._appendFirstFailedTestResultSummary();
      } else if (this.responseStatus() === 'passed_with_warnings') {
        this._appendFirstExpectationResult();
      }
    }

    _appendFirstFailedTestResultSummary() {
      let failedTestResult = this.responseData.test_results.filter((it) => it.status !== 'failed')[0]
      if (failedTestResult && failedTestResult.summary) {
        this._appendResultItem(mumuki.kids.renderSpeechBubbleResultItem(failedTestResult.summary));
      }
    }

    _appendFirstExpectationResult() {
      this._appendResultItem(mumuki.kids.renderSpeechBubbleResultItem(this.responseData.expectations[0].explanation));
    }

    _appendFirstTip() {
      this._appendResultItem(mumuki.kids.renderSpeechBubbleResultItem(this.responseData.tips[0]));
    }

    _appendResultItem(item) {
      this._addClass('with-result-item');
      this.$failedArea.append(item);
    }

    _addClass(klass) {
      this.$bubble.addClass(klass);
    }

    _appendDiscussionsLinkHtml() {
      if (this._shouldDisplayDiscussionsLink()) {
        this.$bubble.append(this.discussionsLinkHtml);
      }
    }

    _shouldDisplayDiscussionsLink() {
      return ['failed', 'passed_with_warnings'].some(it => it === this._responseStatus());
    }

    _responseStatus() {
      return this.responseData.status;
    }

    setDiscussionsLinkHtml(discussionsLinkHtml) {
      this.discussionsLinkHtml = discussionsLinkHtml;
    }

    setResponseData(responseData) {
      this.responseData = responseData;
    }

    // Entry point of the renderer. It just updates the UI, not returning anything
    // Configure the renderer with `setDiscussionsLinkHtml` and `setResponseData` first.
    render() {
      this.$bubble.find('.mu-kids-character-speech-bubble-tabs').hide();
      this.$bubble.find('.mu-kids-character-speech-bubble-normal').hide();
      this.$failedArea.show().html(this.responseData.title_html);
      this._addClass(this.responseStatus());
      this._chooseResultItem();
      this._appendDiscussionsLinkHtml();
    }
  }

  mumuki.kids = mumuki.kids || {};
  mumuki.kids.SpeechBubbleRenderer = SpeechBubbleRenderer;
  mumuki.kids.renderSpeechBubbleResultItem = renderSpeechBubbleResultItem;
})(mumuki)
