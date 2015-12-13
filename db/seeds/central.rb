PathBuilder.build do |p|
  b.chapter 'Fundamentos' do |p|
    p.organization 'sagrado-corazon-alcal'
    p.guide 'fundamentos-gobstones-guia-1-primeros-programas'
    p.guide 'fundamentos-gobstones-guia-2-procedimientos'
    p.guide 'fundamentos-gobstones-guia-3-repeticion-simple'
  end
  b.chapter 'Programacion Funcional' do |p|
    p.organization 'pdep-utn'
    p.prefix 'funcional'

    p.guide 'valores-y-funciones'
    p.guide 'practica-funcional-valores-y-funciones'
    #p.guide A Tipos Simples
    #P Práctica Tipos Simples
    #A Aplicación Parcial y Funciones de Orden Superior [Currificacion]
    p.guide 'practica-aplicacion-parcial-y-orden-superior' #+ alguno de orden superior simple
    #A Funciones Partidas: Guardas y Pattern Matching [Tuplas]
    p.guide 'practica-funciones-partidas' #y pdep-utn/mumuki-funcional-guia-2 (1-4)
    #A Listas, Parte 1: Introducción, length, head, tail, zip
    #A Listas, Parte 2: Orden superior, map, filter, any, all, zipWith
    #A Tipos Paramétricos
    p.guide 'practica-listas'
    #A Listas, Parte 3: Compresión
    p.guide 'practica-listas-por-compresion'
    #A Funciones Anónimas
    p.guide 'practica-expresiones-lambda'

    #p.guide 'modelado'
    #p.guide alguna practica integradora

    #p.guide 'recursividad'
    p.guide 'practica-recursividad'

    #p.guide 'evaluacion-diferida-y-listas-infinitas'
    #A typeclasses: Restricciones de Tipos
    p.guide 'inferencia-de-tipos'

    #A Declaraciones Locales

    p.guide 'practica-chocobos'
  end
  b.chapter 'Programación Lógica' do |p|

=begin
    Programación Lógica

    A Hechos y Reglas [Base de conocimiento]
    A Inversibilidad [limites]
    P pdep-utn/mumuki-logico-guia-1

    A Predicados de Orden Superior
    P pdep-utn/mumuki-logico-guia-2

    A Functores

    R(evist) haskell listas
    A Listas
    P pdep-utn/mumuki-logico-guia-3

    A Colectando Soluciones
    P pdep-utn/mumuki-logico-guia-4

    P pulp fiction
=end

  end
  b.chapter 'Programación con Objetos' do |p|

  end
end

