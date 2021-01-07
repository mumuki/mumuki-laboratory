mumuki.I18n = (() => {

  const translations = {
    'es': {
      aborted: () => "AHHH, Ups, no pudimos evaluar tu solución",
      errored: () => "AHHH, ¡Ups! Tu solución no se puede ejecutar",
      failed: () => "AHHH, Tu solución no pasó las pruebas",
      passed: () => "AHHH, ¡Muy bien! Tu solución pasó todas las pruebas",
      passed_with_warnings: () => "AHHH, Tu solución funcionó, pero hay cosas que mejorar",
      pending: () => "AHHH, Pendiente",
      skipped: () => "AHHH, Venís aprendiendo muy bien, por lo que aprobaste este ejercicio",
    },
    'es-CL': {
      aborted: () => "AHHH, Ups, no pudimos evaluar tu solución",
      errored: () => "AHHH, ¡Ups! Tu solución no se puede ejecutar",
      failed: () => "AHHH, Tu solución no pasó las pruebas",
      passed: () => "AHHH, ¡Muy bien! Tu solución pasó todas las pruebas",
      passed_with_warnings: () => "AHHH, Tu solución funcionó, pero hay cosas que mejorar",
      pending: () => "AHHH, Pendiente",
      skipped: () => "AHHH, Vienes aprendiendo muy bien, por lo que aprobaste este ejercicio",
    },
    'en': {
      aborted: () => "AHHH, Oops, we couldn't evaluate your solution",
      errored: () => "AHHH, Oops, your solution didn't work",
      failed: () => "AHHH, Oops, something went wrong",
      passed: () => "AHHH, Everything is in order! Your solution passed all our tests!",
      passed_with_warnings: () => "AHHH, It worked, but you can do better",
      pending: () => "AHHH, Pending",
      skipped: () => "AHHH, You are doing very well, so you've passed this exercise",
    },
    'pt': {
      aborted: () => "AHHH, Opa, não pudemos avaliar sua solução",
      errored: () => "AHHH, Opa! Sua solução não pode ser executada",
      failed: () => "AHHH, Sua solução não passou as provas",
      passed: () => "AHHH, Muito bem! Sua solução passou todos os testes",
      passed_with_warnings: () => "AHHH, Sua solução funcionou, mas há coisas para melhorar",
      pending: () => "AHHH, Pendente",
      skipped: () => "AHHH, Você está aprendendo muito bem e passou neste exercício",
    }
  }

  return class {

    static translate(key, data = {}) {
      const translationValue = translations[mumuki.locale] && translations[mumuki.locale][key]
      switch (typeof(translationValue)) {
        case 'string': return translationValue;
        case 'function': return translationValue(data);
        default: return `Translation missing: ${mumuki.locale}, \`${key}\``;
      }
    }

    static t(key, data = {}) {
      return mumuki.I18n.translate(key, data);
    }

    static register(translationsToOverride) {
      const locales = Object.keys(translations);
      locales.forEach((it) => translations[it] = Object.assign(translations[it], translationsToOverride[it]));
    }

  }
})();
