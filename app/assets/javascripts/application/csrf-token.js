var mumuki = mumuki || {};
(function (mumuki) {
  function CsrfToken() {
    this.value = $('meta[name="csrf-token"]').attr('content');
  }

  CsrfToken.prototype = {
    newRequest: function (data) {
      var self = this;
      data.beforeSend = function (xhr) {
        xhr.setRequestHeader('X-CSRF-Token', self.value);
      };
      return data;
    }
  };

  mumuki.CsrfToken = CsrfToken;
}(mumuki));
