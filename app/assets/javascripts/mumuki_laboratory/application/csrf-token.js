mumuki.CsrfToken =  (() => {
  class CsrfToken {
    constructor() {
      this.value = $('meta[name="csrf-token"]').attr('content');
    }
    newRequest(data) {
      var self = this;
      data.beforeSend = function (xhr) {
        xhr.setRequestHeader('X-CSRF-Token', self.value);
      };
      return data;
    }
  }
  return CsrfToken;
})();
