mumuki.gamification = (() => {
  class Formula {
    static get QUADRATIC_COEFFICIENT()  { return 25; }
    static get LINEAR_COEFFICIENT()     { return 100; }
    static get CONSTANT_TERM()          { return -125; }
  }

  class LevelProgression {
    constructor(currentExp) {
      this.currentExp = currentExp;
    }

    expToLevelUp() {
      return this.baseExpNextLevel() - this.currentExp;
    }

    baseExpNextLevel() {
      return this.expFor(this.currentLevel() + 1);
    }

    expFor(level) {
      const ax2 = Formula.QUADRATIC_COEFFICIENT * Math.pow(level, 2);
      const bx = Formula.LINEAR_COEFFICIENT * level;
      const c = Formula.CONSTANT_TERM;

      return ax2 + bx + c;
    }

    currentLevel() {
      return this.levelFor(this.currentExp);
    }

    levelFor(exp) {
      const a = Formula.QUADRATIC_COEFFICIENT;
      const b = Formula.LINEAR_COEFFICIENT;
      const c = Formula.CONSTANT_TERM;

      return Math.floor((-b + Math.sqrt(Math.pow(b, 2) - 4 * a * (c - exp))) / (2 * a));
    }

    triggersLevelChange(exp) {
      return this.levelFor(exp) !== this.currentLevel();
    }

    currentLevelProgress() {
      return (this.currentExp - this.baseExpCurrentLevel()) / (this.baseExpNextLevel() - this.baseExpCurrentLevel());
    }

    baseExpCurrentLevel() {
      return this.expFor(this.currentLevel());
    }

    setExpMessage(exp) {
      let expGained = exp - this.currentExp;

      if (expGained > 0) {
        this.currentExp = exp;
        $('#mu-exp-points').html(expGained);

        this.updateLevel();
      }
    }

    updateLevel() {
      const $muLevelProgress = $('#mu-level-progress');

      $('.mu-level-number').html(this.currentLevel());
      $('.mu-level-tooltip').attr("title", (_, value) => `${value} ${this.currentLevel()}`);

      if (this.currentLevelProgress() == 0) {
        $muLevelProgress.attr("display", "none");
      }
    }
  }

  function _setUpCurrentLevelProgression() {
    mumuki.gamification._currentLevelProgression = new LevelProgression(currentExp());
  }

  function currentExp() {
    return $('#mu-current-exp').val();
  }

  return {
    Formula,
    LevelProgression,

    _setUpCurrentLevelProgression,

    /** @type {LevelProgression} */
    _currentLevelProgression: null
  };
})();

mumuki.load(() => {
  mumuki.gamification._setUpCurrentLevelProgression();
  mumuki.gamification._currentLevelProgression.updateLevel();
});
