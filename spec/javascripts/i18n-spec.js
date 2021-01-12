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

})
