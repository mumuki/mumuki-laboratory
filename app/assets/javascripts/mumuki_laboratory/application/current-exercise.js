(() => {
  mumuki.load(() => {
    // Set global currentExerciseId
    const $muExerciseId = $('#mu-exercise-id')[0];
    if ($muExerciseId) {
      mumuki.currentExerciseId = $muExerciseId.value;
    } else {
      mumuki.currentExerciseId = null;
    }
  })
})();
