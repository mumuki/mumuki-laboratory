(() => {
  mumuki.load(() => {
    // Set global currentExerciseId
    const $muExerciseId = $('#mu-exercise-id')[0];
    const $muExerciseResource = $('#mu-exercise-resource')[0];
    if ($muExerciseId) {
      mumuki.currentExerciseId = $muExerciseId.value;
      mumuki.currentExerciseResource = $muExerciseResource.value;
      mumuki.ExercisesStore.saveJson(mumuki.currentExerciseId, mumuki.currentExerciseResource);
    } else {
      mumuki.currentExerciseId = null;
      mumuki.currentExerciseResource = null;
    }
  })
})();
