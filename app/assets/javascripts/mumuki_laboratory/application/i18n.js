mumuki.I18n = (() => {

  const translations = {
    'es': {
      aborted: () => "Ups, no pudimos evaluar tu solución",
      errored: () => "¡Ups! Tu solución no se puede ejecutar",
      failed: () => "Tu solución no pasó las pruebas",
      passed: () => "¡Muy bien! Tu solución pasó todas las pruebas",
      passed_with_warnings: () => "Tu solución funcionó, pero hay cosas que mejorar",
      pending: () => "Pendiente",
      skipped: () => "Venís aprendiendo muy bien, por lo que aprobaste este ejercicio",
      unsaved_progress: () => "Tu solución tiene cambios sin guardar, ¿Querés salir de todos modos?",
    },
    'es-CL': {
      aborted: () => "Ups, no pudimos evaluar tu solución",
      errored: () => "¡Ups! Tu solución no se puede ejecutar",
      failed: () => "Tu solución no pasó las pruebas",
      passed: () => "¡Muy bien! Tu solución pasó todas las pruebas",
      passed_with_warnings: () => "Tu solución funcionó, pero hay cosas que mejorar",
      pending: () => "Pendiente",
      skipped: () => "Vienes aprendiendo muy bien, por lo que aprobaste este ejercicio",
      unsaved_progress: () => "Tu solución tiene cambios sin guardar, ¿Quieres salir de todos modos?",
    },
    'en': {
      aborted: () => "Oops, we couldn't evaluate your solution",
      errored: () => "Oops, your solution didn't work",
      failed: () => "Oops, something went wrong",
      passed: () => "Everything is in order! Your solution passed all our tests!",
      passed_with_warnings: () => "It worked, but you can do better",
      pending: () => "Pending",
      skipped: () => "You are doing very well, so you've passed this exercise",
      unsaved_progress: () => "Your solution has unsaved changes, leave anyways?",
    },
    'pt': {
      aborted: () => "Opa, não pudemos avaliar sua solução",
      errored: () => "Opa! Sua solução não pode ser executada",
      failed: () => "Sua solução não passou as provas",
      passed: () => "Muito bem! Sua solução passou todos os testes",
      passed_with_warnings: () => "Sua solução funcionou, mas há coisas para melhorar",
      pending: () => "Pendente",
      skipped: () => "Você está aprendendo muito bem e passou neste exercício",
      unsaved_progress: () => "Sua solução tem alterações não salvas. Deseja sair mesmo assim?",
    }
  }

  return new class {

    translate(key, data = {}) {
      const translationValue = this._translationValue(key);
      switch (typeof(translationValue)) {
        case 'string': return translationValue;
        case 'function': return translationValue(data);
        default: return `Translation missing: ${mumuki.locale}, \`${key}\``;
      }
    }

    t(key, data = {}) {
      return mumuki.I18n.translate(key, data);
    }

    register(translationsToOverride) {
      const locales = Object.keys(translations);
      locales.forEach((it) => translations[it] = Object.assign(translations[it], translationsToOverride[it]));
    }

    _prefixTranslationKey(key) {
      this._prefix = $('[data-i18n-prefix]');
      return this._prefix.get(0) ? `${this._prefix.data('i18n-prefix')}_${key}` : key;
    }

    _translationValue(key) {
      let translationLocale = translations[mumuki.locale];
      return translationLocale && (translationLocale[this._prefixTranslationKey(key)] || translationLocale[key]);
    }

  }
})();
