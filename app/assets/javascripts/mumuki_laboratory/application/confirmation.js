mumuki.load(() => {
  $('.btn-confirmation').on('click change', function (_event) {
    const token = new mumuki.CsrfToken();
    const $element = $(this);

    $.ajax(token.newRequest({
      method: 'POST',
      url: $element.data('confirmation-url'),
      xhrFields: {withCredentials: true},
      success: function(result) {
        result.status = "passed";
        mumuki.renderers.results.preRenderResult(result)
        mumuki.updateProgressBarAndShowModal(result);
        window.location = $element.attr("href");
      }
    }));
    return false;
  });
});
