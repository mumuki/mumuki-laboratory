class Formula {
  static get QUADRATIC_COEFFICIENT()  { return 25; }
  static get LINEAR_COEFFICIENT()     { return 100; }
  static get CONSTANT_TERM()          { return -125; }
}

class LevelProgression {
  constructor(currentExp) {
    this.currentExp = currentExp;
  }

  expFor(level) {
    const ax2 = Formula.QUADRATIC_COEFFICIENT * Math.pow(level, 2);
    const bx = Formula.LINEAR_COEFFICIENT * level;
    const c = Formula.CONSTANT_TERM;

    return ax2 + bx + c;
  }

  expToLevelUp() {
    return this.baseExpNextLevel() - this.currentExp;
  }

  baseExpNextLevel() {
    return this.expFor(this.currentLevel() + 1);
  }

  levelFor(exp) {
    const a = Formula.QUADRATIC_COEFFICIENT;
    const b = Formula.LINEAR_COEFFICIENT;
    const c = Formula.CONSTANT_TERM;

    return Math.floor((-b + Math.sqrt(Math.pow(b, 2) - 4 * a * (c - exp))) / (2 * a));
  }

  currentLevel() {
    return this.levelFor(this.currentExp);
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
      $('#mu-level-number').html(this.currentLevel());
    }
  }
}

(function (mumuki) {
  mumuki.setUpCurrentExp = function (currentExp) {
    mumuki.gamification = new LevelProgression(currentExp);
  };
})(mumuki);
