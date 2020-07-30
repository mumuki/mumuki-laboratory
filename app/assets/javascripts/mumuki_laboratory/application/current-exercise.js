(() => {
  mumuki.load(() => {
    // Set global currentExerciseId
    const $muExerciseId = $('#mu-exercise-id');
    if ($muExerciseId) {
      mumuki.currentExerciseId = Number($muExerciseId.val());
    } else {
      mumuki.currentExerciseId = null;
    }
  })
})();
