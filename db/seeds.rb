Tenant.find_or_create_by(name: 'central').switch!

haskell = Language.find_or_create_by(name: 'haskell',
                           test_runner_url: 'http://mumuki-hspec-server.herokuapp.com',
                           extension: 'hs',
                           image_url: 'https://www.haskell.org/wikistatic/haskellwiki_logo.png')


[ "pdep-utn/mumuki-funcional-guia-0",
  "pdep-utn/mumuki-funcional-guia-1",
  "pdep-utn/mumuki-funcional-guia-2-orden-superior"].each do |slug|
    Guide.find_or_create_by(url: "http://bibliotheca.mumuki.io/guides/#{slug}").import!
  end


functional = Category.find_or_create_by(name: 'Programación Funcional',
                              locale: :es,
                              description: 'Programación Funcional',
                              image_url: 'http://mumuki.io/favicon')

Path.find_or_create_by(category: functional, language: haskell).rebuild!(Guide.all)
