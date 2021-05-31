mumuki.toast = {
  load() {
    document.querySelectorAll('.toast').forEach((toast) => new bootstrap.Toast(toast).show());
  },

  addToast(content) {
    $('.toast-container').html(content);
    mumuki.toast.load();
  }
};

mumuki.load(() => {
  mumuki.toast.load();
});
