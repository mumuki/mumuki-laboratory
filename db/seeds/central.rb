Book.build! do |b|
  b.chapter 'Fundamentos' do |c|
    c.organization 'sagrado-corazon-alcal'
    c.guide 'primeros-programas'
    c.guide 'procedimientos'
    c.guide 'repeticion-simple'
  end
  b.chapter 'Programacion Funcional' do |c|
    c.organization 'pdep-utn'
    c.prefix 'funcional'

    c.guide 'valores-y-funciones'
    c.guide 'practica-funcional-valores-y-funciones'
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
    #A Listas, Parte 3: Compresión
    c.guide 'practica-listas-por-compresion'
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

