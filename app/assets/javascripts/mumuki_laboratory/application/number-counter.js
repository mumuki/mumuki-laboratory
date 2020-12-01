mumuki.animateNumberCounter = (selector, valueTo, seconds = 1) => {
  const $numberCounter = $(selector);

  if ($numberCounter.text()) return;

  const millis = seconds * 1000;
  const incrementStep = valueTo / (millis / 10);

  _increment();

  function _increment(initValue = 0, delay = 10) {
    if (initValue >= valueTo) return;
    const nextValue = initValue + incrementStep;
    // TODO: this one should be xp agnostic
    $numberCounter.text(`+${Math.min(Math.round(nextValue), valueTo)}exp`);
    setTimeout(() => _increment(nextValue), delay);
  }
};
