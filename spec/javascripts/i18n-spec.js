describe('I18n', () => {

  describe('t / translate', () => {

    it('accept english translations', () => {
      mumuki.locale = 'en';
      expect(mumuki.I18n.translate('passed')).toBe('Everything is in order! Your solution passed all our tests!');
    })
    it('accept spanish translations', () => {
      mumuki.locale = 'es';
      expect(mumuki.I18n.translate('passed_with_warnings')).toBe('Tu solución funcionó, pero hay cosas que mejorar');
    })
    it('accept chilean translations', () => {
      mumuki.locale = 'es-CL';
      expect(mumuki.I18n.translate('failed')).toBe('Tu solución no pasó las pruebas');
    })
    it('accept portuguese translations', () => {
      mumuki.locale = 'pt';
      expect(mumuki.I18n.translate('errored')).toBe('Opa! Sua solução não pode ser executada');
    })
    it('fails when translation missing', () => {
      mumuki.locale = 'en';
      expect(mumuki.I18n.translate('foo')).toBe('Translation missing: en, `foo`');
    })

  })

  describe('register', () => {
    beforeEach(() => {
      mumuki.locale = 'en';
      mumuki.I18n.register({
        en: {
          greet: (data) => `Hi ${data.name}`,
          errored: "D'Oh!"
        }
      })
    })
    it('overrides existing translation key', () => {
      expect(mumuki.I18n.translate('errored')).toBe("D'Oh!");
    })
    it('add missing translation key', () => {
      expect(mumuki.I18n.translate('greet', {name: 'Jane'})).toBe('Hi Jane');
    })
    it('keep non overriding translation key', () => {
      expect(mumuki.I18n.translate('passed')).toBe('Everything is in order! Your solution passed all our tests!');
    })
  })

  describe('with some prefix', () => {

    fixture.set(`
        <div class="mu-kindergarten" data-i18n-prefix="testing">
            <button class="mu-kids-button">Click me<button>
            <div class="mu-kids-overlay" style="display: none"></div>
        </div>
    `);

    beforeEach(() => {
      mumuki.locale = 'en';
      mumuki.I18n.register({
        en: {
          testing_failed: 'Ops! Execution failed',
        }
      })
    });

    it('Using prefix with existing translation key', () => {
      expect(mumuki.I18n.t('passed')).toBe('Everything is in order! Your solution passed all our tests!');
    });
    it('Use prefix with none existing translation key but default key exists', () => {
      expect(mumuki.I18n.t('failed')).toBe('Ops! Execution failed');
    });
    it('No key found', () => {
      expect(mumuki.I18n.t('foo')).toBe('Translation missing: en, `foo`');
    })

  });

});
