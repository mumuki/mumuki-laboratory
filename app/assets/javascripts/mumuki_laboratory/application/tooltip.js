mumuki.load(() => {
  document.querySelectorAll('[data-bs-toggle="tooltip"]').forEach((tooltip) => new bootstrap.Tooltip(tooltip));
});
