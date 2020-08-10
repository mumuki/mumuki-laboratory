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
    let ax2 = Formula.QUADRATIC_COEFFICIENT * Math.pow(level, 2);
    let bx = Formula.LINEAR_COEFFICIENT * level;
    let c = Formula.CONSTANT_TERM;

    return ax2 + bx + c;
  }

  expToLevelUp() {
    let baseExpNextLevel = this.expFor(this.currentLevel() + 1);

    return baseExpNextLevel - this.currentExp;
  }

  levelFor(exp) {
    let a = Formula.QUADRATIC_COEFFICIENT;
    let b = Formula.LINEAR_COEFFICIENT;
    let c = Formula.CONSTANT_TERM;

    return Math.floor((-b + Math.sqrt(Math.pow(b, 2) - 4 * a * (c - exp))) / (2 * a));
  }

  currentLevel() {
    return this.levelFor(this.currentExp);
  }

  triggersLevelChange(exp) {
    return this.levelFor(exp) != this.currentLevel();
  }

  currentLevelProgress() {
    let currentLevel = this.currentLevel();
    let baseExpCurrentLevel = this.expFor(currentLevel);
    let baseExpNextLevel = this.expFor(currentLevel + 1);

    return (this.currentExp - baseExpCurrentLevel) / (baseExpNextLevel - baseExpCurrentLevel);
  }
}

(function (mumuki) {
  mumuki.setUpCurrentExp = function (currentExp) {
    mumuki.gamification = new LevelProgression(currentExp);
  };
})(mumuki);
