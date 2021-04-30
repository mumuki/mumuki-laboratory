mumuki.renderers = mumuki.renderers || {};
mumuki.renderers.speechBubble = (()=> {

  function renderSpeechBubbleResultItem(item) {
    return `
        <div class="results-item">
          <ul class="results-list">
            <li>${item}</li>
          </ul>
        </div>`;
  }

  // A mumuki.renderers.SpeechBubbleRenderer allows to configure a kids speech bubble
  // with the data of a test response from bridge
  class SpeechBubbleRenderer {
    constructor($bubble) {
      this.$bubble = $bubble;
      this.$failedArea = $bubble.find('.mu-kids-character-speech-bubble-failed');
    }

    _chooseResultItem() {
      if (this._responseStatus() !== 'passed' && this._hasTips()) {
        this._appendFirstTip();
      } else if (this._responseStatus() === 'failed') {
        this._appendFirstFailedTestResultSummary();
      } else if (this._responseStatus() === 'passed_with_warnings') {
        this._appendFirstExpectationResult();
      }
    }

    _appendFirstFailedTestResultSummary() {
      const failedTestResult = this._failedTestResults()[0];
      if (failedTestResult && failedTestResult.summary) {
        this._appendResultItem(mumuki.renderers.renderSpeechBubbleResultItem(failedTestResult.summary));
      }
    }

    _appendFirstExpectationResult() {
      this._appendResultItem(mumuki.renderers.renderSpeechBubbleResultItem(this.responseData.expectations[0].explanation));
    }

    _appendFirstTip() {
      this._appendResultItem(mumuki.renderers.renderSpeechBubbleResultItem(this.responseData.tips[0]));
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

    _hasTips() {
      return this.responseData.tips && this.responseData.tips.length;
    }

    _failedTestResults() {
      return this.responseData.test_results.filter((it) => it.status === 'failed');
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
      this.$failedArea.removeClass('d-none').addClass('d-block').html(this.responseData.title_html);
      this._addClass(this._responseStatus());
      this._chooseResultItem();
      this._appendDiscussionsLinkHtml();
    }
  }

  return {
    SpeechBubbleRenderer,
    renderSpeechBubbleResultItem
  };
})();

/** @deprecated use {@code mumuki.renderers.speechBubble.SpeechBubbleRenderer} instead */
mumuki.renderers.SpeechBubbleRenderer = mumuki.renderers.speechBubble.SpeechBubbleRenderer;
/** @deprecated use {@code mumuki.renderers.speechBubble.renderSpeechBubbleResultItem} instead */
mumuki.renderers.renderSpeechBubbleResultItem = mumuki.renderers.speechBubble.renderSpeechBubbleResultItem;
