(() => {
  // Allow polimorphism between standard promise and jquery promise
  Promise.prototype.done = Promise.prototype.finally;
})
