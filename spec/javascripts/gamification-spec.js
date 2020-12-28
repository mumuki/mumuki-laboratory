describe('gamification', () => {
  describe('formula', () => {
    it('has positive coefficients', () => {
      expect(mumuki.gamification.Formula.QUADRATIC_COEFFICIENT).toBeGreaterThan(0);
      expect(mumuki.gamification.Formula.LINEAR_COEFFICIENT).toBeGreaterThan(0);
    });

    it('has negative constant term', () => {
      expect(mumuki.gamification.Formula.CONSTANT_TERM).toBeLessThan(0);
    });
  });

  describe('level progression', () => {
    describe('exp to level up', () => {
      it('takes 175 exp points to go from level 1 to 2', () => {
        expect(new mumuki.gamification.LevelProgression(0).expToLevelUp()).toBe(175);
      });

      it('takes 225 points to go from level 2 to 3', () => {
        expect(new mumuki.gamification.LevelProgression(175).expToLevelUp()).toBe(225);
      });
    });

    describe('current level', () => {
      it('is at level 1 when 0 exp points', () => {
        expect(new mumuki.gamification.LevelProgression(0).currentLevel()).toBe(1);
      });

      it('is at level 5 when 1000 exp points', () => {
        expect(new mumuki.gamification.LevelProgression(1000).currentLevel()).toBe(5);
      });
    });

    describe('triggers level change', () => {
      it('does not trigger when small exp difference', () => {
        expect(new mumuki.gamification.LevelProgression(1000).triggersLevelChange(50)).toBe(false);
      });

      it('does trigger when big exp difference', () => {
        expect(new mumuki.gamification.LevelProgression(1000).triggersLevelChange(500)).toBe(true);
      });
    });

    describe('current level progress', () => {
      it('is at 0% when just leveled up', () => {
        expect(new mumuki.gamification.LevelProgression(675).currentLevelProgress()).toBe(0);
      });

      it('is at 50% when halfway through', () => {
        expect(new mumuki.gamification.LevelProgression(837).currentLevelProgress()).toBeCloseTo(0.50, 0.01);
      });

      it('is at 99% when almost there', () => {
        expect(new mumuki.gamification.LevelProgression(999).currentLevelProgress()).toBeCloseTo(0.99, 0.01);
      });
    });
  });
});
