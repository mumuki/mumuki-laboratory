mumuki.toast = {
  load() {
    document.querySelectorAll('.toast').forEach((toast) => new bootstrap.Toast(toast).show());
  }
};

mumuki.load(() => {
  mumuki.toast.load();
});
