(() => {
  // Allow polimorphism between standard promise and jquery promise
  Promise.prototype.always = Promise.prototype.finally;
  Promise.prototype.fail = Promise.prototype.catch;
})();
