(() => {
  const ExercisesStore = new class {
    find(exerciseId) {
      const exercise = window.localStorage.getItem(this._keyFor(exerciseId));
      if (!exercise) return null;
      return JSON.parse(exercise);
    }

    // Saves an exercise object
    save(exerciseId, exercise) {
      this.saveJson(exerciseId, JSON.stringify(exercise));
    }

    // Saves an exercise json string
    saveJson(exerciseId, exerciseJson) {
      window.localStorage.setItem(this._keyFor(exerciseId), exerciseJson);
    }

    // Shortcut for getting corollary for an existent exercise
    // Fails if exercise is missing
    getCorollary(exerciseId) {
      const exercise = this.find(exerciseId);
      if (!exercise) throw new Error(`Missing exercise ${exerciseId}. Can not get corollary`);
      return exercise.corollary;
    }

    _keyFor(exerciseId) {
      return `/exercise/${exerciseId}`;
    }
  };
  mumuki.ExercisesStore = ExercisesStore;
})();
