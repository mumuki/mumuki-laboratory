Book.build! do |b|
  b.chapter 'Fundamentos' do |c|
    c.organization 'sagrado-corazon-alcal'
    c.prefix 'fundamentos'
    c.locale 'es'
    c.description "\
      Aprendé los fundamentos de la programación de la manera más fácil utilizando [Gobstones](http://gobstones.org),\
      un **innovador lenguaje gráfico** creado en la Universidad de Quilmes, en el que utilizarás un tablero con bolitas\
      para resolver problemas. Si nunca programaste antes, **te recomendamos que empieces por acá**."

    c.guide 'primeros-programas'
    c.guide 'procedimientos'
    c.guide 'repeticion-simple'
    c.guide 'alternativa-condicional'
  end

  b.chapter 'Programacion Funcional' do |c|
    c.organization 'pdep-utn'
    c.prefix 'funcional'
    c.locale 'es'
    c.description "\
      El paradigma funcional es de los más **antiguos**, pero también de los más **simples** y **poderosos**.\
      Si querés abrir tu cabeza y aprender _a dominar el mundo con nada_, seguí por acá."

    c.guide 'valores-y-funciones'
    c.guide 'practica-valores-y-funciones'
    #p.guide A Tipos Simples
    #P Práctica Tipos Simples
    #A Aplicación Parcial y Funciones de Orden Superior [Currificacion]
    c.guide 'practica-aplicacion-parcial-y-orden-superior' #+ alguno de orden superior simple
    #A Funciones Partidas: Guardas y Pattern Matching [Tuplas]
    c.guide 'practica-funciones-partidas' #y pdep-utn/mumuki-funcional-guia-2 (1-4)
    #A Listas, Parte 1: Introducción, length, head, tail, zip
    #A Listas, Parte 2: Orden superior, map, filter, any, all, zipWith
    #A Tipos Paramétricos
    c.guide 'practica-listas'
    #A Listas, Parte 3: Comprensión
    c.guide 'practica-listas-por-comprension'
    #A Funciones Anónimas
    c.guide 'practica-expresiones-lambda'

    #p.guide 'modelado'
    #p.guide alguna practica integradora

    #p.guide 'recursividad'
    c.guide 'practica-recursividad'

    #p.guide 'evaluacion-diferida-y-listas-infinitas'
    #A typeclasses: Restricciones de Tipos
    c.guide 'inferencia-de-tipos'

    #A Declaraciones Locales

    c.guide 'practica-chocobos'
  end

  b.chapter 'Programación Lógica' do |c|
    c.organization 'pdep-utn'
    c.prefix 'logico'
    c.locale 'es'
    c.description "\
      ¿Querés volar tu cabeza? ¿Querés aprender a programar _enseñándole_ reglas a una computadora, sin\
      usar `ifs`, `fors` ni operadores lógicos? ¿Querés escribir código que cualquiera puede entender?\
      Entonces aprendé sobre el paradigma lógico, utilizando su lenguaje más conocido: Prolog."

    # A Hechos y Reglas [Base de conocimiento]
    # A Inversibilidad [limites]
    c.guide 'practica-primeros-pasos'

    # A Predicados de Orden Superior
    c.guide 'practica-aritmetica-y-negacion'

    c.guide 'functores'
    c.guide 'practica-functores'

    # R(evist) haskell listas
    # A Listas
    c.guide 'practica-listas'

    # A Colectando Soluciones
    # P pdep-utn/mumuki-logico-guia-4

    c.guide 'practica-pulp-fiction'
  end
end

