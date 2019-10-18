(() => {
  mumuki.load(() => {
    // Set global currentExerciseId
    const $muExerciseId = $('#mu-exercise-id')[0];
    const $muExerciseResource = $('#mu-exercise-resource')[0];
    if ($muExerciseId) {
      mumuki.currentExerciseId = Number($muExerciseId.value);
      mumuki.ExercisesStore.saveJson(mumuki.currentExerciseId, $muExerciseResource.value);
    } else {
      mumuki.currentExerciseId = null;
    }
  })
})();
