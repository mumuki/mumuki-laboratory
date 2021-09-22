mumuki.CsrfToken =  (() => {
  class CsrfToken {
    get token() {
      return $('meta[name="csrf-token"]').attr('content');
    }

    newRequest(data) {
      data.beforeSend = (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', this.token);
      };
      return data;
    }
  }
  return CsrfToken;
})();
