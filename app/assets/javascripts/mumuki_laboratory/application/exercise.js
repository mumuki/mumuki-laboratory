mumuki.exercise = {
  /**
   * The current exercise's id
   *
   * @type {number}
   * */
  id: null,

  /**
   * The current exercise's layout
   *
   * @type {"input_right" | "input_bottom" | "input_primary" | "input_kindergarten"}
   * */
  layout: null,

  /**
   * Set global current exercise information
   */
  load() {
    const $muExerciseId = $('#mu-exercise-id');
    if ($muExerciseId.length) {
      this.id = Number($muExerciseId.val());
      // @ts-ignore
      this.layout = $('#mu-exercise-layout').val();
    } else {
      this.id = null;
      this.layout = null;
    }
  }
}

mumuki.load(() => mumuki.exercise.load())
