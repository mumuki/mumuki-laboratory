mumuki.load(() => {
  document.querySelectorAll('.toast').forEach((toast) => new bootstrap.Toast(toast).show());
});
